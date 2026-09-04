//
//  FavoritesViewController.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 12.07.2026.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import SnapKit

class FavoritesViewController: UIViewController {

    // MARK: - UI Components
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    // MARK: - Properties
    
    private var favoriteMovies: [Movie] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appBackground
        navigationItem.title = "favorites_title".localized()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavorites()
    }
    
    // MARK: - Layout Setup
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - API Data Fetching
    
    private func fetchFavorites() {
        let token = Storage.sharedInstance.accessToken.isEmpty
            ? UserDefaults.standard.string(forKey: "accessToken") ?? ""
            : Storage.sharedInstance.accessToken
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        SVProgressHUD.show()
        
        AF.request(URLs.FAVORITES_URL, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: [Movie].self) { [weak self] response in
                SVProgressHUD.dismiss()
                guard let self = self else { return }
                
                switch response.result {
                case .success(let movies):
                    self.favoriteMovies = movies
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error fetching favorites: \(error.localizedDescription)")
                    SVProgressHUD.showError(withStatus: "CONECTION_ERROR".localized())
                }
            }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        
        let movie = favoriteMovies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
