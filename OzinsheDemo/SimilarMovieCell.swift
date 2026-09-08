//
//  SimilarMovieCell.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 08.09.2026.
//

import UIKit
import SnapKit
import SDWebImage

class SimilarMovieCell: UICollectionViewCell {
    static let identifier = "SimilarMovieCell"
    
    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.backgroundColor = .systemGray6
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12, weight: .bold)
        l.textColor = .label
        l.numberOfLines = 1
        return l
    }()
    
    private let subTitleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 10, weight: .regular)
        l.textColor = .tertiaryLabel
        l.numberOfLines = 1
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        
        posterImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(140)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.displayTitle
        subTitleLabel.text = movie.displaySubcategories.isEmpty ? "Телехикая" : movie.displaySubcategories
        
        if let link = movie.poster?.link, let url = URL(string: link) {
            posterImageView.sd_setImage(with: url)
        }
    }
}
