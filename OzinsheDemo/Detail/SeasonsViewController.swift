//
//  SeasonsViewController.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 14.10.2026.
//

import UIKit
import SnapKit
import Alamofire
import SVProgressHUD

class SeasonsViewController: UIViewController {

    var movieID: Int?
    private var seasons: [Season] = []
    private var selectedSeasonIndex: Int = 0

    // MARK: - UI Components
    
    private lazy var customNavBar: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private lazy var backButton: UIButton = {
        let btn = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
        btn.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        btn.tintColor = UIColor { trait in
            return trait.userInterfaceStyle == .dark ? .white : .black
        }
        btn.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        return btn
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Бөлімдер"
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = UIColor { trait in
            return trait.userInterfaceStyle == .dark ? .white : UIColor(red: 17/255, green: 24/255, blue: 39/255, alpha: 1.0)
        }
        return label
    }()

    private lazy var seasonsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 8
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        cv.register(SeasonTabCell.self, forCellWithReuseIdentifier: SeasonTabCell.identifier)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()

    private lazy var episodesTableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.register(EpisodeCell.self, forCellReuseIdentifier: EpisodeCell.identifier)
        tv.dataSource = self
        tv.delegate = self
        return tv
    }()

    // MARK: - Lifecycle

        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = UIColor { trait in
                return trait.userInterfaceStyle == .dark
                    ? UIColor(red: 11/255, green: 19/255, blue: 43/255, alpha: 1.0)
                    : .white
            }
            setupUI()
            
            if let id = movieID {
                fetchSeasons(movieId: id)
            }
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(true, animated: animated)
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            navigationController?.setNavigationBarHidden(false, animated: animated)
        }

    // MARK: - Setup UI

    private func setupUI() {
        view.addSubview(customNavBar)
        customNavBar.addSubview(backButton)
        customNavBar.addSubview(titleLabel)
        view.addSubview(seasonsCollectionView)
        view.addSubview(episodesTableView)

        customNavBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }

        // Match design reference: clean back button without background pill
        backButton.backgroundColor = .clear
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }

        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        // Ensure seasons tab collection view has enough height and spacing
        seasonsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(customNavBar.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }

        episodesTableView.snp.makeConstraints { make in
            make.top.equalTo(seasonsCollectionView.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }

    // MARK: - API Request

    private func fetchSeasons(movieId: Int) {
        let token = Storage.sharedInstance.accessToken.isEmpty
            ? UserDefaults.standard.string(forKey: "accessToken") ?? ""
            : Storage.sharedInstance.accessToken

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]

        SVProgressHUD.show()

        AF.request("\(URLs.SEASONS_URL)\(movieId)", method: .get, headers: headers)
            .validate()
            .responseDecodable(of: [Season].self) { [weak self] response in
                SVProgressHUD.dismiss()
                guard let self = self else { return }
                if case .success(let seasons) = response.result {
                    self.seasons = seasons
                    self.seasonsCollectionView.reloadData()
                    self.episodesTableView.reloadData()
                }
            }
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }

    private func extractYouTubeID(from urlString: String) -> String? {
        if urlString.count == 11, !urlString.contains("/") {
            return urlString
        }
        let pattern = "(?:v=|\\.be/|embed/|live/)([a-zA-Z0-9_-]{11})"
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: urlString, range: NSRange(urlString.startIndex..., in: urlString)),
              let range = Range(match.range(at: 1), in: urlString) else {
            return nil
        }
        return String(urlString[range])
    }
}

// MARK: - CollectionView DataSource & Delegate (Seasons)

extension SeasonsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ cv: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return seasons.count
    }

    func collectionView(_ cv: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = cv.dequeueReusableCell(withReuseIdentifier: SeasonTabCell.identifier, for: indexPath) as? SeasonTabCell else {
            return UICollectionViewCell()
        }
        let seasonNumber = seasons[indexPath.item].number
        cell.configure(seasonNumber: seasonNumber, isSelected: indexPath.item == selectedSeasonIndex)
        return cell
    }

    func collectionView(_ cv: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSeasonIndex = indexPath.item
        seasonsCollectionView.reloadData()
        episodesTableView.reloadData()
    }
}

// MARK: - TableView DataSource & Delegate (Episodes)

extension SeasonsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tv: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !seasons.isEmpty else { return 0 }
        return seasons[selectedSeasonIndex].videos?.count ?? 0
    }

    func tableView(_ tv: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tv.dequeueReusableCell(withIdentifier: EpisodeCell.identifier, for: indexPath) as? EpisodeCell,
              let video = seasons[selectedSeasonIndex].videos?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.configure(with: video)
        return cell
    }

    func tableView(_ tv: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let video = seasons[selectedSeasonIndex].videos?[indexPath.row],
              let link = video.link else { return }

        let videoID = extractYouTubeID(from: link) ?? link
        let playerVC = YouTubePlayerViewController(videoID: videoID)
        present(playerVC, animated: true)
    }
}
