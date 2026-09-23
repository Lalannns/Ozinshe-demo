//
//  BannerCollectionViewCell.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 23.09.2026.
//

import UIKit
import SnapKit
import SDWebImage

class BannerCollectionViewCell: UICollectionViewCell {
    static let identifier = "BannerCollectionViewCell"

    // MARK: - UI Elements
    private let bannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
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

    private let gradientView: UIView = {
        let view = UIView()
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.8).cgColor
        ]
        gradient.locations = [0.0, 1.0]
        view.layer.addSublayer(gradient)
        return view
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let gradientLayer = gradientView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = gradientView.bounds
        }
    }

    // MARK: - Setup UI
    private func setupUI() {
        contentView.addSubview(bannerImageView)
        bannerImageView.addSubview(gradientView)
        bannerImageView.addSubview(categoryLabel)
        bannerImageView.addSubview(titleLabel)

        bannerImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        gradientView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(100)
        }

        categoryLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-12)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }

        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(categoryLabel.snp.top).offset(-4)
            make.left.right.equalTo(categoryLabel)
        }
    }

    // MARK: - Configure
    func configure(with banner: Banner) {
        if let link = banner.link, let url = URL(string: link) {
            bannerImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        } else if let movie = banner.movie, let posterUrl = movie.poster?.link, let url = URL(string: posterUrl) {
            bannerImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        }

        titleLabel.text = banner.movie?.name ?? banner.title
        
        if let categories = banner.movie?.categories, !categories.isEmpty {
            categoryLabel.text = categories.map { $0.name }.joined(separator: " • ")
        } else {
            categoryLabel.text = ""
        }
    }
}
