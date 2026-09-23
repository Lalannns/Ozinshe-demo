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

    // MARK: - UI Elements
    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.backgroundColor = .systemGray5
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = UIColor(named: "111827") ?? .label
        label.numberOfLines = 1
        return label
    }()

    private let subcategoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.textColor = UIColor(named: "9CA3AF") ?? .secondaryLabel
        label.numberOfLines = 1
        return label
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup UI
    private func setupUI() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subcategoryLabel)

        posterImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(164)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
        }

        subcategoryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }

    // MARK: - Configure
    func configure(with movie: Movie) {
        titleLabel.text = movie.title ?? ""
        
        // Формирование названия подкатегории / жанра
        if let subcategories = movie.categories, !subcategories.isEmpty {
            subcategoryLabel.text = subcategories.compactMap { $0.name }.joined(separator: " • ")
        } else {
            subcategoryLabel.text = ""
        }

        // Загрузка постера
        if let link = movie.poster?.link, let url = URL(string: link) {
            posterImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "posterPlaceholder"))
        } else {
            posterImageView.image = UIImage(named: "posterPlaceholder")
        }
    }
}
