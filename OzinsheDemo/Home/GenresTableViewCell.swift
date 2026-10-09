//
//  GenresTableViewCell.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 23.09.2026.
//

import UIKit
import SnapKit

protocol GenresTableViewCellDelegate: AnyObject {
    func didSelectGenre(_ genre: Genre)
}

class GenresTableViewCell: UITableViewCell {
    
    static let identifier = "GenresTableViewCell"
    weak var delegate: GenresTableViewCellDelegate?
    
    private var genres: [Genre] = []
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Жанрды таңдаңыз"
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
        collectionView.register(GenresCollectionViewCell.self, forCellWithReuseIdentifier: GenresCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
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
            make.left.right.equalToSuperview()
            make.height.equalTo(112)
        }
    }
    
    func configure(with genres: [Genre]) {
        self.genres = genres
        self.collectionView.reloadData()
    }
}

extension GenresTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenresCollectionViewCell.identifier, for: indexPath) as? GenresCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: genres[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectGenre(genres[indexPath.item])
    }
}
