//
//  CategoryChipCell.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 04.09.2026.
//

import UIKit
import SnapKit

class CategoryChipCell: UICollectionViewCell {
    static let identifier = "CategoryChipCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProDisplay-Semibold", size: 12) ?? .systemFont(ofSize: 12, weight: .semibold)
        label.textAlignment = .center
        label.lineBreakMode = .byClipping
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(8)
        }
        
        updateAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateAppearance()
        }
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
    private func updateAppearance() {
        if isSelected {
            // Active / Selected State (Brand Purple with white text)
            contentView.backgroundColor = UIColor(named: "9753F0") ?? UIColor(red: 151/255, green: 83/255, blue: 240/255, alpha: 1.0)
            titleLabel.textColor = .white
        } else {
            // Unselected State
            contentView.backgroundColor = UIColor { trait in
                return trait.userInterfaceStyle == .dark
                    ? (UIColor(named: "1C2431") ?? UIColor(red: 55/255, green: 65/255, blue: 81/255, alpha: 1.0))
                    : UIColor(red: 243/255, green: 244/255, blue: 246/255, alpha: 1.0)
            }
            
            titleLabel.textColor = UIColor { trait in
                return trait.userInterfaceStyle == .dark
                    ? .white
                    : UIColor(red: 17/255, green: 24/255, blue: 39/255, alpha: 1.0)
            }
        }
    }
}
