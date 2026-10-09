//
//  MovieCollectionViewCell.swift
//  Pods
//
//  Created by Allan Auezkhan on 23.09.2026.
//

import UIKit
import SnapKit
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .systemGray6 
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = UIColor(named: "111827") ?? .label
        label.numberOfLines = 1
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(red: 0.61, green: 0.64, blue: 0.69, alpha: 1.0)
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupUI() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(categoryLabel)
        
        posterImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(164)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.name
        
        if let link = movie.poster?.link {
            // Replace legacy server host with the working API domain
            let correctedLink = link.replacingOccurrences(
                of: "api.ozinshe.com",
                with: "apiozinshe.mobydev.kz"
            )
            
            if let encodedString = correctedLink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
               let url = URL(string: encodedString) {
                posterImageView.sd_setImage(
                    with: url,
                    placeholderImage: UIImage(named: "placeholder"),
                    options: [.retryFailed, .highPriority]
                )
                return
            }
        }
        
        posterImageView.image = UIImage(named: "placeholder")
    }
}
