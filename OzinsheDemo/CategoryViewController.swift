//
//  CategoryViewController.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 27.08.2026.
//


import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

class CategoryViewController: UIViewController {

    // MARK: - Properties
    var categoryID: Int?
    var categoryName: String?

    private var movies: [Movie] = []

    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appBackground
        
        setupNavigationBar()
        setupUI()
        fetchCategoryMovies()
    }

    // MARK: - Navigation Setup
    private func setupNavigationBar() {
        title = categoryName ?? ""
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .appTextColor
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)

        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    // MARK: - API Call
    private func fetchCategoryMovies() {
        guard let categoryID = categoryID else { return }
        
        activityIndicator.startAnimating()

        let parameters: [String: Any] = ["categoryId": categoryID]
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "userToken") ?? "")"
        ]

        AF.request(URLs.MOVIES_BY_CATEGORY_URL, method: .get, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: [Movie].self) { [weak self] response in
                guard let self = self else { return }
                self.activityIndicator.stopAnimating()

                switch response.result {
                case .success(let fetchedMovies):
                    self.movies = fetchedMovies
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error fetching category movies: \(error.localizedDescription)")
                }
            }
    }
}


// MARK: - UITableView DataSource & Delegate
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
        return 120
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedMovie = movies[indexPath.row]
        
        let detailVC = DetailViewController()
        detailVC.movieID = selectedMovie.id
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
