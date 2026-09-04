//
//  DetailViewController.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 04.09.2026.
//

import UIKit
import SnapKit
import Alamofire

class DetailViewController: UIViewController {

    var movieID: Int?
    var movie: Movie?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appBackground
        
        if let id = movieID {
            fetchMovieDetails(id: id)
        }
    }

    private func fetchMovieDetails(id: Int) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "userToken") ?? "")"
        ]

        AF.request("\(URLs.SEARCH_MOVIES_URL)/\(id)", method: .get, headers: headers)
            .validate()
            .responseDecodable(of: Movie.self) { [weak self] response in
                switch response.result {
                case .success(let movieDetails):
                    self?.movie = movieDetails
                    // Update detail views here
                case .failure(let error):
                    print("Error fetching details: \(error.localizedDescription)")
                }
            }
    }
}
