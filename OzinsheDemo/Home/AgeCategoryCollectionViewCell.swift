//
//  AgeCategoryCollectionViewCell.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 09.10.2026.
//

import UIKit
import SnapKit
import SDWebImage

class AgeCategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AgeCategoryCollectionViewCell"
    
    // MARK: - UI Elements
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = UIColor(named: "9753E0") ?? .systemPurple
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(backgroundImageView)
        backgroundImageView.addSubview(nameLabel)
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
    }
    
    // MARK: - Configuration
    func configure(with ageCategory: AgeCategory) {
        nameLabel.text = ageCategory.name
        
        // Load image URL using fixedURL extension from URLs.swift
        if let link = ageCategory.link, let url = link.fixedURL {
            backgroundImageView.sd_setImage(
                with: url,
                placeholderImage: nil,
                options: [.retryFailed, .highPriority]
            )
        } else {
            backgroundImageView.image = nil
        }
    }
}
