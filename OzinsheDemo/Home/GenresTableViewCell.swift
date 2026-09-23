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

    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Жанрлар"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(named: "111827") ?? .label
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.register(CategoryChipCell.self, forCellWithReuseIdentifier: CategoryChipCell.identifier)
        return cv
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Setup UI
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(titleLabel)
        contentView.addSubview(collectionView)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview()
        }
    }

    func configure(with genres: [Genre]) {
        self.genres = genres
        self.collectionView.reloadData()
    }
}

// MARK: - CollectionView Extension
extension GenresTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryChipCell.identifier, for: indexPath) as? CategoryChipCell else {
            return UICollectionViewCell()
        }
        cell.configure(title: genres[indexPath.item].name)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectGenre(genres[indexPath.item])
    }
}
