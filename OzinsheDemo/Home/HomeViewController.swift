//
//  HomeViewController.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 12.07.2026.
//

import UIKit
import SnapKit
import Alamofire

// MARK: - Main Screen Section Types
enum MainSectionType {
    case mainBanner([Banner])
    case userHistory([Movie])
    case moviesCategory(MainMovies)
    case genres([Genre])
    case ageCategory([AgeCategory])
}

// MARK: - Main Protocols
protocol MainTableViewCellDelegate: AnyObject {
    func didSelectMovie(_ movie: Movie)
    func didTapSeeAll(categoryID: Int, title: String)
}

protocol MainBannerTableViewCellDelegate: AnyObject {
    func didSelectMovie(_ movie: Movie)
}

class HomeViewController: UIViewController {

    // MARK: - UI Elements
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logoMain")?.withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        tableView.register(MainBannerTableViewCell.self, forCellReuseIdentifier: MainBannerTableViewCell.identifier)
        tableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.identifier)
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        tableView.register(GenresTableViewCell.self, forCellReuseIdentifier: GenresTableViewCell.identifier)
        tableView.register(AgeCategoryTableViewCell.self, forCellReuseIdentifier: AgeCategoryTableViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    private let refreshControl = UIRefreshControl()

    // MARK: - API Base Config
    private let baseURL = "https://apiozinshe.mobydev.kz/core/V1"

    // MARK: - Data Properties
    private var sectionData: [MainSectionType] = []
    
    private var mainBanners: [Banner] = []
    private var userHistory: [Movie] = []
    private var mainMovies: [MainMovies] = []
    private var genres: [Genre] = []
    private var ageCategories: [AgeCategory] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRefreshControl()
        loadAllData()
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = UIColor(named: "Background") ?? .systemBackground
        
        let logoContainer = UIView()
        logoContainer.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(32)
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoContainer)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func setupRefreshControl() {
        refreshControl.tintColor = UIColor(named: "9753E0") ?? .systemPurple
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc private func handleRefresh() {
        loadAllData()
    }

    // MARK: - Network Requests
    private func loadAllData() {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        fetchMainBanners { [weak self] banners in
            self?.mainBanners = banners
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchUserHistory { [weak self] history in
            self?.userHistory = history
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchMainMovies { [weak self] categories in
            self?.mainMovies = categories
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchGenres { [weak self] genresList in
            self?.genres = genresList
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchAgeCategories { [weak self] ages in
            self?.ageCategories = ages
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.buildSections()
            self?.tableView.reloadData()
        }
    }

    // MARK: - Section Assembly
    private func buildSections() {
        sectionData.removeAll()

        if !mainBanners.isEmpty {
            sectionData.append(.mainBanner(mainBanners))
        }

        if !userHistory.isEmpty {
            sectionData.append(.userHistory(userHistory))
        }

        for (index, category) in mainMovies.enumerated() {
            sectionData.append(.moviesCategory(category))
            
            if index == 1 && !genres.isEmpty {
                sectionData.append(.genres(genres))
            }
            
            if index == 4 && !ageCategories.isEmpty {
                sectionData.append(.ageCategory(ageCategories))
            }
        }
    }

    // MARK: - API Calls
    private func getAuthHeaders() -> HTTPHeaders {
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        return [
            "Authorization": "Bearer \(token)",
            "Accept-Language": "qs"
        ]
    }

    private func fetchMainBanners(completion: @escaping ([Banner]) -> Void) {
        let url = "\(baseURL)/banners"
        AF.request(url, method: .get, headers: getAuthHeaders())
            .validate()
            .responseDecodable(of: [Banner].self) { response in
                switch response.result {
                case .success(let banners): completion(banners)
                case .failure: completion([])
                }
            }
    }

    private func fetchUserHistory(completion: @escaping ([Movie]) -> Void) {
        let url = "\(baseURL)/history"
        AF.request(url, method: .get, headers: getAuthHeaders())
            .validate()
            .responseDecodable(of: [Movie].self) { response in
                switch response.result {
                case .success(let history): completion(history)
                case .failure: completion([])
                }
            }
    }

    private func fetchMainMovies(completion: @escaping ([MainMovies]) -> Void) {
        let url = "\(baseURL)/movies/main"
        AF.request(url, method: .get, headers: getAuthHeaders())
            .validate()
            .responseDecodable(of: [MainMovies].self) { response in
                switch response.result {
                case .success(let categories): completion(categories)
                case .failure: completion([])
                }
            }
    }

    private func fetchGenres(completion: @escaping ([Genre]) -> Void) {
        let url = "\(baseURL)/genres"
        AF.request(url, method: .get, headers: getAuthHeaders())
            .validate()
            .responseDecodable(of: [Genre].self) { response in
                switch response.result {
                case .success(let genres): completion(genres)
                case .failure: completion([])
                }
            }
    }

    private func fetchAgeCategories(completion: @escaping ([AgeCategory]) -> Void) {
        let url = "\(baseURL)/category-ages"
        AF.request(url, method: .get, headers: getAuthHeaders())
            .validate()
            .responseDecodable(of: [AgeCategory].self) { response in
                switch response.result {
                case .success(let ages): completion(ages)
                case .failure: completion([])
                }
            }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionData.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sectionData[indexPath.section]

        switch section {
        case .mainBanner(let banners):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainBannerTableViewCell.identifier, for: indexPath) as? MainBannerTableViewCell else { return UITableViewCell() }
            cell.configure(with: banners)
            cell.delegate = self
            return cell

        case .userHistory(let movies):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier, for: indexPath) as? HistoryTableViewCell else { return UITableViewCell() }
            cell.configure(with: movies)
            cell.delegate = self
            return cell

        case .moviesCategory(let mainMovieCategory):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
            cell.configure(with: mainMovieCategory)
            cell.delegate = self
            return cell

        case .genres(let genresList):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GenresTableViewCell.identifier, for: indexPath) as? GenresTableViewCell else { return UITableViewCell() }
            cell.configure(with: genresList)
            cell.delegate = self
            return cell

        case .ageCategory(let ages):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AgeCategoryTableViewCell.identifier, for: indexPath) as? AgeCategoryTableViewCell else { return UITableViewCell() }
            cell.configure(with: ages)
            cell.delegate = self
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sectionData[indexPath.section]
        
        switch section {
        case .mainBanner:
            return 280
        case .userHistory:
            return 220
        case .moviesCategory:
            return 288
        case .genres, .ageCategory:
            return 160
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
}

// MARK: - Navigation Delegates
extension HomeViewController: MainTableViewCellDelegate, MainBannerTableViewCellDelegate, HistoryTableViewCellDelegate, GenresTableViewCellDelegate, AgeCategoryTableViewCellDelegate {
    
    func didSelectMovie(_ movie: Movie) {
        let detailVC = DetailViewController()
        detailVC.movie = movie
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func didTapSeeAll(categoryID: Int, title: String) {
        let categoryVC = CategoryViewController()
        categoryVC.categoryID = categoryID
        categoryVC.title = title
        navigationController?.pushViewController(categoryVC, animated: true)
    }
    
    func didSelectGenre(_ genre: Genre) {
        let categoryVC = CategoryViewController()
        categoryVC.categoryID = genre.id
        categoryVC.title = genre.name
        navigationController?.pushViewController(categoryVC, animated: true)
    }
    
    func didSelectAgeCategory(_ ageCategory: AgeCategory) {
        let categoryVC = CategoryViewController()
        categoryVC.categoryID = ageCategory.id
        categoryVC.title = ageCategory.name
        navigationController?.pushViewController(categoryVC, animated: true)
    }
}
