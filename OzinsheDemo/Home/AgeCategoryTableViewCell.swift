//
//  AgeCategoryTableViewCell.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 23.09.2026.
//

import UIKit
import SnapKit

protocol AgeCategoryTableViewCellDelegate: AnyObject {
    func didSelectAgeCategory(_ ageCategory: AgeCategory)
}

class AgeCategoryTableViewCell: UITableViewCell {
    
    static let identifier = "AgeCategoryTableViewCell"
    weak var delegate: AgeCategoryTableViewCellDelegate?
    
    private var ageCategories: [AgeCategory] = []
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Жасына сәйкес"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(named: "111827") ?? .label
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 184, height: 112)
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(AgeCategoryCollectionViewCell.self, forCellWithReuseIdentifier: AgeCategoryCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(collectionView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(112)
        }
    }
    
    func configure(with ages: [AgeCategory]) {
        self.ageCategories = ages
        self.collectionView.reloadData()
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension AgeCategoryTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ageCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AgeCategoryCollectionViewCell.identifier, for: indexPath) as? AgeCategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: ageCategories[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectAgeCategory(ageCategories[indexPath.item])
    }
}
