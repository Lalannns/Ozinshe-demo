//
//  HomeViewController.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 12.07.2026.
//

import UIKit
import SnapKit
import Alamofire
import SDWebImage

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
        updateLogoImage()
        setupRefreshControl()
        loadAllData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLogoImage()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateLogoImage()
        }
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = UIColor(named: "Background") ?? .systemBackground
        
        logoImageView.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(32)
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoImageView)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func updateLogoImage() {
        let isDark = traitCollection.userInterfaceStyle == .dark
        let imageName = isDark ? "logo-dark" : "logo-light"
        logoImageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
    }

    private func setupRefreshControl() {
        refreshControl.tintColor = UIColor(named: "9753E0") ?? .systemPurple
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    private func setupSDWebImage() {
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        SDWebImageDownloader.shared.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }

    @objc private func handleRefresh() {
        loadAllData()
    }

    // MARK: - Network Requests Coordinator
    private func loadAllData() {
        setupSDWebImage()
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        downloadMainBanners { dispatchGroup.leave() }

        dispatchGroup.enter()
        downloadHistory { dispatchGroup.leave() }

        dispatchGroup.enter()
        downloadMainMovies { dispatchGroup.leave() }

        dispatchGroup.enter()
        downloadGenres { dispatchGroup.leave() }

        dispatchGroup.enter()
        downloadCategoryAges { dispatchGroup.leave() }

        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
            self.buildSections()
            self.tableView.reloadData()
        }
    }

    // MARK: - Headers
    private func getAuthHeaders() -> HTTPHeaders {
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        return [
            "Authorization": "Bearer \(token)",
            "Accept-Language": "qs"
        ]
    }

    // MARK: - API Calls
    func downloadMainBanners(completion: (() -> Void)? = nil) {
        let url = URLs.BASE_URL + "main/banners"
        AF.request(url, method: .get, headers: getAuthHeaders())
            .validate()
            .responseDecodable(of: [Banner].self) { [weak self] response in
                defer { completion?() }
                if case .success(let banners) = response.result {
                    self?.mainBanners = banners
                }
            }
    }

    func downloadHistory(completion: (() -> Void)? = nil) {
        let url = URLs.BASE_URL + "history/"
        AF.request(url, method: .get, headers: getAuthHeaders())
            .validate()
            .responseDecodable(of: [Movie].self) { [weak self] response in
                defer { completion?() }
                if case .success(let history) = response.result {
                    self?.userHistory = history
                }
            }
    }

    func downloadMainMovies(completion: (() -> Void)? = nil) {
        AF.request(URLs.MAIN_MOVIES_URL, method: .get, headers: getAuthHeaders())
            .validate()
            .responseDecodable(of: [MainMovies].self) { [weak self] response in
                defer { completion?() }
                if case .success(let categories) = response.result {
                    self?.mainMovies = categories
                }
            }
    }

    func downloadGenres(completion: (() -> Void)? = nil) {
        AF.request(URLs.GENRES_URL, method: .get, headers: getAuthHeaders())
            .validate()
            .responseDecodable(of: [Genre].self) { [weak self] response in
                defer { completion?() }
                if case .success(let genres) = response.result {
                    self?.genres = genres
                }
            }
    }

    func downloadCategoryAges(completion: (() -> Void)? = nil) {
        let url = URLs.BASE_URL + "category-ages"
        AF.request(url, method: .get, headers: getAuthHeaders())
            .validate()
            .responseDecodable(of: [AgeCategory].self) { [weak self] response in
                defer { completion?() }
                if case .success(let ages) = response.result {
                    self?.ageCategories = ages
                }
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

        var addedMovieCategoryCount = 0

        for category in mainMovies {
            guard let movies = category.movies, !movies.isEmpty else { continue }
            
            sectionData.append(.moviesCategory(category))
            addedMovieCategoryCount += 1

            if addedMovieCategoryCount == 2 && !genres.isEmpty {
                sectionData.append(.genres(genres))
            }

            if addedMovieCategoryCount == 5 && !ageCategories.isEmpty {
                sectionData.append(.ageCategory(ageCategories))
            }
        }

        let hasGenres = sectionData.contains { if case .genres = $0 { return true }; return false }
        if !hasGenres && !genres.isEmpty {
            sectionData.append(.genres(genres))
        }

        let hasAgeCategories = sectionData.contains { if case .ageCategory = $0 { return true }; return false }
        if !hasAgeCategories && !ageCategories.isEmpty {
            sectionData.append(.ageCategory(ageCategories))
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
            return 168
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
        detailVC.movieID = movie.id
        detailVC.hidesBottomBarWhenPushed = true
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
