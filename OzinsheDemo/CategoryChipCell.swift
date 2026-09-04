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
        label.textColor = UIColor(red: 17/255, green: 24/255, blue: 39/255, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor(red: 243/255, green: 244/255, blue: 246/255, alpha: 1.0)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String) {
        titleLabel.text = title
    }
}
