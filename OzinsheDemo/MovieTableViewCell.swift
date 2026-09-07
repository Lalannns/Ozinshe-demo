//
//  MovieTableViewCell.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 12.07.2026.
//

import UIKit
import SnapKit
import SDWebImage

class MovieTableViewCell: UITableViewCell {
    
    static let identifier = "MovieTableViewCell"
    
    // MARK: - UI Components
    
    lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProDisplay-Bold", size: 14) ?? .boldSystemFont(ofSize: 14)
        label.textColor = UIColor(red: 17/255, green: 24/255, blue: 39/255, alpha: 1.0) // #111827
        label.numberOfLines = 1
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProDisplay-Regular", size: 12) ?? .systemFont(ofSize: 12)
        label.textColor = UIColor(red: 156/255, green: 163/255, blue: 175/255, alpha: 1.0) // #9CA3AF
        label.numberOfLines = 1
        return label
    }()
    
    lazy var playView: UIView = {
        let view = UIView()
        let imageView = UIImageView(image: UIImage(named: "Play-Filled"))
        let label = UILabel()
        
        view.backgroundColor = UIColor(red: 248/255, green: 238/255, blue: 255/255, alpha: 1.0) // #F8EEFF
        view.layer.cornerRadius = 8
        
        label.text = "Қарау"
        label.font = UIFont(name: "SFProDisplay-Bold", size: 12) ?? .boldSystemFont(ofSize: 12)
        label.textColor = UIColor(red: 151/255, green: 83/255, blue: 240/255, alpha: 1.0) // #9753F0
        
        view.addSubview(imageView)
        view.addSubview(label)
        
        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(16)
        }
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(imageView.snp.right).offset(4)
            make.right.equalToSuperview().inset(12)
        }
        
        return view
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 229/255, green: 231/255, blue: 235/255, alpha: 1.0) // #E5E7EB
        return view
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI & Constraints
    
    func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(playView)
        contentView.addSubview(bottomView)
        
        // 1. Poster ImageView
        posterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(24)
            make.width.equalTo(71)
            make.height.equalTo(104)
            make.bottom.lessThanOrEqualToSuperview().offset(-16)
        }
        
        // 2. Title Label
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.top)
            make.leading.equalTo(posterImageView.snp.trailing).offset(17)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        // 3. Subtitle Label
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(titleLabel.snp.trailing)
        }
        
        // 4. Play View
        playView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(12)
            make.height.equalTo(26)
        }
        
        // 5. Divider Line
        bottomView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Data Configuration
    
    func configure(with movie: Movie) {
        // 1. Title
        titleLabel.text = movie.displayTitle
        
        // 2. Subtitle (Year & Categories/Genres)
        let yearText = (movie.year != nil && movie.year != 0) ? "\(movie.year!)" : ""
        let subcategoriesText = movie.displaySubcategories
        
        if !yearText.isEmpty && !subcategoriesText.isEmpty {
            subtitleLabel.text = "\(yearText) • \(subcategoriesText)"
        } else if !subcategoriesText.isEmpty {
            subtitleLabel.text = subcategoriesText
        } else if !yearText.isEmpty {
            subtitleLabel.text = yearText
        } else {
            subtitleLabel.text = "Фильм"
        }
        
        // 3. Poster Image Loading
        posterImageView.image = nil
        posterImageView.backgroundColor = UIColor(red: 243/255, green: 244/255, blue: 246/255, alpha: 1.0)
        
        if let posterLink = movie.poster?.link, !posterLink.isEmpty {
            var fullPath = posterLink
            
            // Fix 1: Replace dead/unresolvable backend domain with active host
            if fullPath.contains("api.ozinshe.com") {
                fullPath = fullPath.replacingOccurrences(of: "api.ozinshe.com", with: "apiozinshe.mobydev.kz")
            }
            
            // Fix 2: Prepend base URL if it's a relative path
            if !fullPath.hasPrefix("http://") && !fullPath.hasPrefix("https://") {
                let formattedPath = fullPath.hasPrefix("/") ? fullPath : "/\(fullPath)"
                fullPath = "https://apiozinshe.mobydev.kz\(formattedPath)"
            }
            
            // Fix 3: Enforce HTTPS for ATS compliance
            if fullPath.hasPrefix("http://") {
                fullPath = fullPath.replacingOccurrences(of: "http://", with: "https://")
            }
            
            // Fix 4: Encode special characters/spaces
            if let encodedPath = fullPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
               let url = URL(string: encodedPath) {
                posterImageView.sd_setImage(
                    with: url,
                    placeholderImage: UIImage(named: "posterPlaceholder"),
                    options: [.retryFailed, .continueInBackground, .lowPriority]
                )
            } else {
                print("⚠️ Bad Image URL String: \(fullPath)")
            }
        }
    }
}
