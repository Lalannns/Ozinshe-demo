//
//  CategoryViewController.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 27.08.2026.
//

//
//  CategoryViewController.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 27.08.2026.
//

import UIKit
import SnapKit
import Alamofire
import SVProgressHUD

// MARK: - Page Wrapper Struct
struct CategoryMoviesResponse: Codable {
    let content: [Movie]?
}

class CategoryViewController: UIViewController {

    // MARK: - Properties
    var categoryID: Int?
    var categoryName: String?
    
    private var movies: [Movie] = []

    // MARK: - Dynamic Colors
    private let appBackgroundColor = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 11/255, green: 19/255, blue: 43/255, alpha: 1.0) // #0B132B
            : .white
    }
    
    private let labelTextColor = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark
            ? .white
            : UIColor(red: 17/255, green: 24/255, blue: 39/255, alpha: 1.0) // #111827
    }

    // MARK: - UI Elements
    private lazy var navigationBarView: UIView = {
        let view = UIView()
        view.backgroundColor = appBackgroundColor
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        button.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        button.tintColor = labelTextColor
        button.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = labelTextColor
        label.font = UIFont(name: "SFProDisplay-Bold", size: 16) ?? .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        tv.dataSource = self
        tv.delegate = self
        tv.showsVerticalScrollIndicator = false
        return tv
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = appBackgroundColor
        
        setupUI()
        titleLabel.text = categoryName ?? "Телехикая"
        
        if let id = categoryID {
            fetchCategoryMovies(categoryID: id)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Setup
    private func setupUI() {
        view.addSubview(navigationBarView)
        navigationBarView.addSubview(backButton)
        navigationBarView.addSubview(titleLabel)
        view.addSubview(tableView)
        
        navigationBarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.greaterThanOrEqualToSuperview().inset(60)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navigationBarView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    // MARK: - Networking
    private func fetchCategoryMovies(categoryID: Int) {
        let token = Storage.sharedInstance.accessToken.isEmpty
            ? UserDefaults.standard.string(forKey: "accessToken") ?? ""
            : Storage.sharedInstance.accessToken
            
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "categoryId": categoryID
        ]
        
        SVProgressHUD.show()
        
        AF.request(URLs.MOVIES_BY_CATEGORY_URL, method: .get, parameters: parameters, headers: headers)
            .responseData { [weak self] response in
                SVProgressHUD.dismiss()
                guard let self = self else { return }
                
                switch response.result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    
                    // 1. Try decoding as direct array [Movie]
                    if let directMovies = try? decoder.decode([Movie].self, from: data) {
                        self.movies = directMovies
                        self.tableView.reloadData()
                        return
                    }
                    
                    // 2. Try decoding as Paginated response
                    if let wrappedResponse = try? decoder.decode(CategoryMoviesResponse.self, from: data),
                       let contentMovies = wrappedResponse.content {
                        self.movies = contentMovies
                        self.tableView.reloadData()
                        return
                    }
                    
                    // 3. Fallback: SearchResponse wrapper
                    if let searchResponse = try? decoder.decode(SearchResponse.self, from: data),
                       let contentMovies = searchResponse.content {
                        self.movies = contentMovies
                        self.tableView.reloadData()
                        return
                    }
                    
                    print("⚠️ JSON Decoding failed. Raw Payload:")
                    if let rawString = String(data: data, encoding: .utf8) {
                        print(rawString)
                    }
                    
                case .failure(let error):
                    print("❌ Network Error: \(error.localizedDescription)")
                }
            }
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableView Extensions
extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: movies[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedMovie = movies[indexPath.row]
        
        let detailVC = DetailViewController()
        detailVC.movieID = selectedMovie.id
        detailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
