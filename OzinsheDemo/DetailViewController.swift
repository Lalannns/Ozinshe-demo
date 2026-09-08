//
//  DetailViewController.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 04.09.2026.
//

import UIKit
import SnapKit
import Alamofire
import SDWebImage
import SVProgressHUD
import AVKit

class DetailViewController: UIViewController {

    // MARK: - Properties
    
    var movieID: Int?
    private var movie: Movie?
    private var screenshots: [Screenshot] = []
    private var similarMovies: [Movie] = []
    
    private var isDescriptionExpanded = false

    // MARK: - UI Elements
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.contentInsetAdjustmentBehavior = .never
        return sv
    }()
    
    private let contentView = UIView()
    
    // Top Hero Backdrop & Container
    private let heroContainerView = UIView()
    
    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray5
        return iv
    }()
    
    private let gradientOverlay: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        return v
    }()
    
    private lazy var backButton: UIButton = {
        let btn = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        btn.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        btn.layer.cornerRadius = 18
        btn.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var favoriteButton: UIButton = {
        let btn = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        btn.setImage(UIImage(systemName: "bookmark", withConfiguration: config), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        return btn
    }()
    
    //rework favorites so that it unsaves and removes from list.
    
    private let favoriteLabel: UILabel = {
        let l = UILabel()
        l.text = "Тізімге қосу"
        l.textColor = .white
        l.font = .systemFont(ofSize: 11, weight: .medium)
        l.textAlignment = .center
        return l
    }()
    
    private lazy var playButton: UIButton = {
        let btn = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .bold)
        btn.setImage(UIImage(systemName: "play.fill", withConfiguration: config), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor(red: 120/255, green: 69/255, blue: 228/255, alpha: 1.0)
        btn.layer.cornerRadius = 28
        btn.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var shareButton: UIButton = {
        let btn = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        btn.setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: config), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        return btn
    }()
    
    private let shareLabel: UILabel = {
        let l = UILabel()
        l.text = "Бөлісу"
        l.textColor = .white
        l.font = .systemFont(ofSize: 11, weight: .medium)
        l.textAlignment = .center
        return l
    }()

    // White Rounded Sheet Container
    private let cardContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .appBackground
        view.layer.cornerRadius = 32
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .boldSystemFont(ofSize: 22)
        l.textColor = .appTextColor
        l.numberOfLines = 0
        return l
    }()
    
    private let subTitleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12, weight: .regular)
        l.textColor = .systemGray
        l.numberOfLines = 0
        return l
    }()
    
    private let dividerLine1: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.systemGray5
        return v
    }()
    
    private let descriptionLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13)
        l.textColor = .secondaryLabel
        l.numberOfLines = 3
        return l
    }()
    
    private lazy var readMoreButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Толығырақ", for: .normal)
        btn.setTitleColor(UIColor(red: 120/255, green: 69/255, blue: 228/255, alpha: 1.0), for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        btn.addTarget(self, action: #selector(readMoreTapped), for: .touchUpInside)
        return btn
    }()
    
    private let directorTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Режиссер:"
        l.font = .systemFont(ofSize: 13)
        l.textColor = .systemGray
        return l
    }()
    
    private let directorValueLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13, weight: .semibold)
        l.textColor = .appTextColor
        return l
    }()
    
    private let producerTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Продюсер:"
        l.font = .systemFont(ofSize: 13)
        l.textColor = .systemGray
        return l
    }()
    
    private let producerValueLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13, weight: .semibold)
        l.textColor = .appTextColor
        return l
    }()
    
    private let dividerLine2: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.systemGray5
        return v
    }()
    
    // Episodes ("Бөлімдер") Row
    private lazy var episodesRowView: UIView = {
        let v = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(episodesTapped))
        v.addGestureRecognizer(tap)
        v.isUserInteractionEnabled = true
        return v
    }()
    
    private let episodesTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Бөлімдер"
        l.font = .boldSystemFont(ofSize: 16)
        l.textColor = .appTextColor
        return l
    }()
    
    private let episodesCountLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13)
        l.textColor = .systemGray
        return l
    }()
    
    private let episodesChevron: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .semibold)
        let iv = UIImageView(image: UIImage(systemName: "chevron.right", withConfiguration: config))
        iv.tintColor = .systemGray
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    // Screenshots Section
    private let screenshotsTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Скриншоттар"
        l.font = .boldSystemFont(ofSize: 16)
        l.textColor = .appTextColor
        return l
    }()
    
    private lazy var screenshotsCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 184, height: 112)
        layout.minimumLineSpacing = 12
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        cv.register(ScreenshotCell.self, forCellWithReuseIdentifier: ScreenshotCell.identifier)
        cv.dataSource = self
        return cv
    }()
    
    // Similar Movies Section
    private let similarTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Ұқсас телехикаялар"
        l.font = .boldSystemFont(ofSize: 16)
        l.textColor = .appTextColor
        return l
    }()
    
    private lazy var similarAllButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Барлығы", for: .normal)
        btn.setTitleColor(UIColor(red: 120/255, green: 69/255, blue: 228/255, alpha: 1.0), for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        return btn
    }()
    
    private lazy var similarCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 112, height: 190)
        layout.minimumLineSpacing = 12
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        cv.register(SimilarMovieCell.self, forCellWithReuseIdentifier: SimilarMovieCell.identifier)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        if let id = movieID {
            loadData(id: id)
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
    
    // MARK: - Networking
    
    private func loadData(id: Int) {
        let token = Storage.sharedInstance.accessToken.isEmpty
            ? UserDefaults.standard.string(forKey: "accessToken") ?? ""
            : Storage.sharedInstance.accessToken
            
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        SVProgressHUD.show()
        
        // 1. Fetch Movie Detail
        AF.request("\(URLs.MOVIE_DETAIL_URL)\(id)", method: .get, headers: headers)
            .validate()
            .responseDecodable(of: Movie.self) { [weak self] response in
                SVProgressHUD.dismiss()
                if case .success(let movie) = response.result {
                    self?.movie = movie
                    self?.updateUI(with: movie)
                }
            }
            
        // 2. Fetch Screenshots
        AF.request("\(URLs.SCREENSHOTS_URL)\(id)", method: .get, headers: headers)
            .validate()
            .responseDecodable(of: [Screenshot].self) { [weak self] response in
                if case .success(let screenshots) = response.result {
                    self?.screenshots = screenshots
                    self?.screenshotsCV.reloadData()
                }
            }
            
        // 3. Fetch Similar Movies
        AF.request("\(URLs.SIMILAR_MOVIES_URL)\(id)", method: .get, headers: headers)
            .validate()
            .responseDecodable(of: [Movie].self) { [weak self] response in
                if case .success(let similar) = response.result {
                    self?.similarMovies = similar
                    self?.similarCV.reloadData()
                }
            }
    }
    
    private func updateUI(with movie: Movie) {
        titleLabel.text = movie.displayTitle
        
        let yearText = "\(movie.year ?? 2020)"
        let subcatsText = movie.displaySubcategories.isEmpty ? "Телехикая" : movie.displaySubcategories
        let typeText = movie.movieType == "SERIES" ? "\(movie.seasonCount ?? 10) серия, 7 мин." : "Фильм"
        subTitleLabel.text = "\(yearText) • \(subcatsText) • \(typeText)"
        
        descriptionLabel.text = movie.description
        directorValueLabel.text = movie.director ?? "Бағдәулет Әлімбеков"
        producerValueLabel.text = movie.producer ?? "Сандуғаш Кенжебаева"
        episodesCountLabel.text = "\(movie.seasonCount ?? 10) серия"
        
        if let link = movie.poster?.link, let url = URL(string: link) {
            posterImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "posterPlaceholder"))
        }
        
        let isFav = movie.favorite ?? false
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        favoriteButton.setImage(UIImage(systemName: isFav ? "bookmark.fill" : "bookmark", withConfiguration: config), for: .normal)
        favoriteLabel.text = isFav ? "Тізімде" : "Тізімге қосу"
        
        let isSeries = movie.movieType == "SERIES"
        episodesRowView.isHidden = !isSeries
        dividerLine2.isHidden = !isSeries
        
        if !isSeries {
            screenshotsTitleLabel.snp.remakeConstraints { make in
                make.top.equalTo(producerTitleLabel.snp.bottom).offset(24)
                make.leading.trailing.equalToSuperview().inset(24)
            }
        }
    }
    
    // MARK: - Layout Setup
    
    private func setupUI() {
        view.backgroundColor = .appBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Hero Section Subviews
        contentView.addSubview(heroContainerView)
        heroContainerView.addSubview(posterImageView)
        heroContainerView.addSubview(gradientOverlay)
        heroContainerView.addSubview(backButton)
        heroContainerView.addSubview(favoriteButton)
        heroContainerView.addSubview(favoriteLabel)
        heroContainerView.addSubview(playButton)
        heroContainerView.addSubview(shareButton)
        heroContainerView.addSubview(shareLabel)
        
        // Card Sheet Subviews
        contentView.addSubview(cardContainerView)
        cardContainerView.addSubview(titleLabel)
        cardContainerView.addSubview(subTitleLabel)
        cardContainerView.addSubview(dividerLine1)
        cardContainerView.addSubview(descriptionLabel)
        cardContainerView.addSubview(readMoreButton)
        cardContainerView.addSubview(directorTitleLabel)
        cardContainerView.addSubview(directorValueLabel)
        cardContainerView.addSubview(producerTitleLabel)
        cardContainerView.addSubview(producerValueLabel)
        cardContainerView.addSubview(dividerLine2)
        
        cardContainerView.addSubview(episodesRowView)
        episodesRowView.addSubview(episodesTitleLabel)
        episodesRowView.addSubview(episodesCountLabel)
        episodesRowView.addSubview(episodesChevron)
        
        cardContainerView.addSubview(screenshotsTitleLabel)
        cardContainerView.addSubview(screenshotsCV)
        cardContainerView.addSubview(similarTitleLabel)
        cardContainerView.addSubview(similarAllButton)
        cardContainerView.addSubview(similarCV)
        
        // Constraints
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        heroContainerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(320)
        }
        
        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        gradientOverlay.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(36)
        }
        
        playButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(56)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalTo(playButton.snp.leading).offset(-36)
            make.centerY.equalTo(playButton).offset(-6)
            make.width.height.equalTo(32)
        }
        
        favoriteLabel.snp.makeConstraints { make in
            make.top.equalTo(favoriteButton.snp.bottom).offset(2)
            make.centerX.equalTo(favoriteButton)
        }
        
        shareButton.snp.makeConstraints { make in
            make.leading.equalTo(playButton.snp.trailing).offset(36)
            make.centerY.equalTo(playButton).offset(-6)
            make.width.height.equalTo(32)
        }
        
        shareLabel.snp.makeConstraints { make in
            make.top.equalTo(shareButton.snp.bottom).offset(2)
            make.centerX.equalTo(shareButton)
        }
        
        // Card Sheet Overlap Constraint
        cardContainerView.snp.makeConstraints { make in
            make.top.equalTo(heroContainerView.snp.bottom).offset(-28)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        dividerLine1.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(1)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(dividerLine1.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        readMoreButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(24)
        }
        
        directorTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(readMoreButton.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(24)
            make.width.equalTo(84)
        }
        
        directorValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(directorTitleLabel)
            make.leading.equalTo(directorTitleLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(24)
        }
        
        producerTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(directorTitleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(24)
            make.width.equalTo(84)
        }
        
        producerValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(producerTitleLabel)
            make.leading.equalTo(producerTitleLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(24)
        }
        
        dividerLine2.snp.makeConstraints { make in
            make.top.equalTo(producerTitleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(1)
        }
        
        // Episodes Row Constraints
        episodesRowView.snp.makeConstraints { make in
            make.top.equalTo(dividerLine2.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(24)
        }
        
        episodesTitleLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }
        
        episodesChevron.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.width.height.equalTo(14)
        }
        
        episodesCountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(episodesChevron.snp.leading).offset(-6)
            make.centerY.equalToSuperview()
        }
        
        // Screenshots Section Constraints
        screenshotsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(episodesRowView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        screenshotsCV.snp.makeConstraints { make in
            make.top.equalTo(screenshotsTitleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(112)
        }
        
        // Similar Section Constraints
        similarTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(screenshotsCV.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(24)
        }
        
        similarAllButton.snp.makeConstraints { make in
            make.centerY.equalTo(similarTitleLabel)
            make.trailing.equalToSuperview().inset(24)
        }
        
        similarCV.snp.makeConstraints { make in
            make.top.equalTo(similarTitleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(190)
            make.bottom.equalToSuperview().offset(-60)
        }
    }
    
    // MARK: - Actions
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func playTapped() {
        guard let videoUrlString = movie?.videoUrl, let url = URL(string: videoUrlString) else { return }
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        present(playerViewController, animated: true) {
            player.play()
        }
    }
    
    @objc private func favoriteTapped() {
        guard let movie = movie else { return }
        let token = Storage.sharedInstance.accessToken.isEmpty
            ? UserDefaults.standard.string(forKey: "accessToken") ?? ""
            : Storage.sharedInstance.accessToken
            
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        let isCurrentlyFav = movie.favorite ?? false
        let urlString = isCurrentlyFav ? URLs.DELETE_FAVORITES_URL : URLs.ADD_FAVORITES_URL
        let method: HTTPMethod = isCurrentlyFav ? .delete : .post
        let parameters: [String: Any] = ["movieId": movie.id]
        
        SVProgressHUD.show()
        
        AF.request(urlString, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .response { [weak self] response in
                SVProgressHUD.dismiss()
                if response.error == nil {
                    self?.movie?.favorite?.toggle()
                    let isFav = self?.movie?.favorite ?? false
                    let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
                    self?.favoriteButton.setImage(UIImage(systemName: isFav ? "bookmark.fill" : "bookmark", withConfiguration: config), for: .normal)
                    self?.favoriteLabel.text = isFav ? "Тізімде" : "Тізімге қосу"
                }
            }
    }
    
    @objc private func shareTapped() {
        guard let movie = movie else { return }
        let items: [Any] = [movie.displayTitle]
        let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(vc, animated: true)
    }
    
    @objc private func readMoreTapped() {
        isDescriptionExpanded.toggle()
        descriptionLabel.numberOfLines = isDescriptionExpanded ? 0 : 3
        readMoreButton.setTitle(isDescriptionExpanded ? "Жасыру" : "Толығырақ", for: .normal)
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func episodesTapped() {
        // Handled if SeasonsViewController is present
    }
}

// MARK: - CollectionView DataSource & Delegate

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ cv: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cv == screenshotsCV ? screenshots.count : similarMovies.count
    }
    
    func collectionView(_ cv: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if cv == screenshotsCV {
            guard let cell = cv.dequeueReusableCell(withReuseIdentifier: ScreenshotCell.identifier, for: indexPath) as? ScreenshotCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: screenshots[indexPath.item])
            return cell
        } else {
            guard let cell = cv.dequeueReusableCell(withReuseIdentifier: SimilarMovieCell.identifier, for: indexPath) as? SimilarMovieCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: similarMovies[indexPath.item])
            return cell
        }
    }
    
    func collectionView(_ cv: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if cv == similarCV {
            let selectedMovie = similarMovies[indexPath.item]
            let detailVC = DetailViewController()
            detailVC.movieID = selectedMovie.id
            detailVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
