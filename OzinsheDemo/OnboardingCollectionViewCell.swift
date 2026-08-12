//
//  OnboardingCollectionViewCell.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 07.08.2026.
//

import UIKit

class OnboardingSlideCell: UICollectionViewCell {
    
    static let identifier = "OnboardingSlideCell"
    
    // MARK: - UI Components
    
    // Background illustration covering the screen
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // Title Label ("ÖZINŞE-ге кош келдің!")
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Description / Subtitle Label
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(red: 156/255, green: 163/255, blue: 175/255, alpha: 1.0) // Gray subtitle text
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Layout
    
    private func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            // Background image stretches across the cell
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Subtitle constraints (positioned toward the bottom area above page control)
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -150),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            
            // Title constraints (positioned directly above the subtitle)
            titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: -12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])
    }
    
    // MARK: - Configuration Method
    
    /// Pass image name, title string, and subtitle description to display inside the cell
    func configure(imageName: String, title: String, subtitle: String) {
        imageView.image = UIImage(named: imageName)
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}
