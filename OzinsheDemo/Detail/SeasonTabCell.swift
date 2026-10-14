//
//  SeasonTabCell.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 14.10.2026.
//

import UIKit
import SnapKit

class SeasonTabCell: UICollectionViewCell {
    static let identifier = "SeasonTabCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(seasonNumber: Int, isSelected: Bool) {
        titleLabel.text = "\(seasonNumber) сезон"
        
        let primaryPurple = UIColor(red: 120/255, green: 69/255, blue: 228/255, alpha: 1.0)
        let unselectedBg = UIColor { trait in
            return trait.userInterfaceStyle == .dark
                ? UIColor(red: 31/255, green: 41/255, blue: 55/255, alpha: 1.0)
                : UIColor(red: 243/255, green: 244/255, blue: 246/255, alpha: 1.0)
        }
        
        contentView.backgroundColor = isSelected ? primaryPurple : unselectedBg
        titleLabel.textColor = isSelected ? .white : UIColor(red: 156/255, green: 163/255, blue: 175/255, alpha: 1.0)
    }
}
