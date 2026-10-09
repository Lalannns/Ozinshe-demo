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

    // MARK: - UI Elements
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
        label.textColor = UIColor { trait in
            return trait.userInterfaceStyle == .dark
                ? .white
                : UIColor(red: 17/255, green: 24/255, blue: 39/255, alpha: 1.0) // #111827
        }
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.numberOfLines = 2
        return label
    }()

    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor { trait in
            return trait.userInterfaceStyle == .dark
                ? UIColor(red: 156/255, green: 163/255, blue: 175/255, alpha: 1.0) // #9CA3AF
                : UIColor(red: 107/255, green: 114/255, blue: 128/255, alpha: 1.0) // #6B7280 for readable contrast in light mode
        }
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 1
        return label
    }()

    private lazy var playButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Қарау"
        config.image = UIImage(systemName: "play.fill")
        config.imagePadding = 6
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 9, weight: .bold)
        
        // Primary Purple Text & Icon
        let purpleColor = UIColor(red: 151/255, green: 83/255, blue: 224/255, alpha: 1.0) // #9753E0
        config.baseForegroundColor = purpleColor
        
        // Proper Configuration Background (Fixes Pink Blending Glitch)
        config.background.backgroundColor = UIColor(red: 243/255, green: 232/255, blue: 255/255, alpha: 1.0) // #F3E8FF
        config.background.cornerRadius = 8
        
        config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12)
        
        let button = UIButton(configuration: config)
        button.isUserInteractionEnabled = false
        return button
    }()

    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor { trait in
            return trait.userInterfaceStyle == .dark
                ? UIColor(red: 31/255, green: 41/255, blue: 55/255, alpha: 1.0) // #1F2937
                : UIColor(red: 229/255, green: 231/255, blue: 235/255, alpha: 1.0) // #E5E7EB
        }
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

    // MARK: - Layout Setup
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear

        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(playButton)
        contentView.addSubview(lineView)

        // Poster 71x104
        posterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(24)
            make.width.equalTo(71)
            make.height.equalTo(104)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.top)
            make.left.equalTo(posterImageView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-24)
        }

        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalTo(titleLabel.snp.right)
        }

        playButton.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(8)
            make.left.equalTo(titleLabel.snp.left)
            make.height.equalTo(26)
        }

        // Separator line inset by 24pt
        lineView.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }

    // MARK: - Configure
    func configure(with movie: Movie) {
        titleLabel.text = movie.displayTitle
        
        let yearString = movie.year != nil ? "\(movie.year!)" : ""
        let categoryName = movie.displaySubcategories.isEmpty
            ? (movie.categories?.first?.name ?? "")
            : movie.displaySubcategories
            
        subTitleLabel.text = [yearString, categoryName].filter { !$0.isEmpty }.joined(separator: " • ")

        if let link = movie.poster?.link ?? movie.cover?.link, let url = link.fixedURL {
            posterImageView.sd_setImage(
                with: url,
                placeholderImage: UIImage(named: "posterPlaceholder"),
                options: [.retryFailed, .highPriority]
            )
        } else {
            posterImageView.image = UIImage(named: "posterPlaceholder")
        }
    }
}
