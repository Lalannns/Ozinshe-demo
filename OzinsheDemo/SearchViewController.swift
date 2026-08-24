//
//  SearchViewController.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 12.07.2026.
//

import UIKit
import SnapKit

// MARK: - Category Selection Delegate
protocol SearchViewControllerDelegate: AnyObject {
    func didSelectCategoryTag(_ categoryKey: String, isSelected: Bool)
}

class SearchViewController: UIViewController {

    weak var delegate: SearchViewControllerDelegate?

    // Localization keys corresponding to categories
    private let categoryKeys: [String] = [
        "category_tv_series",
        "category_sitcom",
        "category_movie",
        "category_cartoon",
        "category_animated_series",
        "category_anime",
        "category_tv_shows",
        "category_documentary",
        "category_music",
        "category_foreign_movies"
    ]

    // Track currently selected filter tags
    private var selectedCategoryKeys: Set<String> = []

    // MARK: - UI Components
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "SFProDisplay-Regular", size: 16) ?? .systemFont(ofSize: 16)
        textField.textColor = UIColor(red: 17/255, green: 24/255, blue: 39/255, alpha: 1.0)
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = (UIColor(named: "E5E7EB") ?? UIColor.systemGray5).cgColor
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 48))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()

    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        let image = UIImage(systemName: "magnifyingglass", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(red: 17/255, green: 24/255, blue: 39/255, alpha: 1.0)
        button.backgroundColor = UIColor(red: 243/255, green: 244/255, blue: 246/255, alpha: 1.0)
        button.layer.cornerRadius = 12
        return button
    }()

    private let categoriesTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProDisplay-Bold", size: 24) ?? .boldSystemFont(ofSize: 24)
        label.textColor = UIColor(red: 17/255, green: 24/255, blue: 39/255, alpha: 1.0)
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 10
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.register(CategoryChipCell.self, forCellWithReuseIdentifier: CategoryChipCell.identifier)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureLanguageStrings()
    }

    // MARK: - UI Setup
    private func setupUI() {
        // Hide title from Tab Bar Item and center icon
        tabBarItem.title = ""
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        view.backgroundColor = .systemBackground

        view.addSubview(searchTextField)
        view.addSubview(searchButton)
        view.addSubview(categoriesTitleLabel)
        view.addSubview(collectionView)

        // SnapKit Constraints
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(48)
        }

        searchButton.snp.makeConstraints { make in
            make.leading.equalTo(searchTextField.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(searchTextField)
            make.size.equalTo(48)
        }

        categoriesTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(categoriesTitleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
    }

    // MARK: - Dynamic Language Updates
    private func configureLanguageStrings() {
        navigationItem.title = "search".localized()
        searchTextField.placeholder = "search".localized()
        categoriesTitleLabel.text = "categories_title".localized()
        collectionView.reloadData()
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryKeys.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryChipCell.identifier, for: indexPath) as? CategoryChipCell else {
            return UICollectionViewCell()
        }
        let key = categoryKeys[indexPath.item]
        let isSelected = selectedCategoryKeys.contains(key)
        cell.configure(title: key.localized(), isSelected: isSelected)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let key = categoryKeys[indexPath.item]
        
        if selectedCategoryKeys.contains(key) {
            selectedCategoryKeys.remove(key)
        } else {
            selectedCategoryKeys.insert(key)
        }
        
        collectionView.reloadItems(at: [indexPath])
        delegate?.didSelectCategoryTag(key, isSelected: selectedCategoryKeys.contains(key))
    }
}

// MARK: - Custom Category Chip Cell
class CategoryChipCell: UICollectionViewCell {
    static let identifier = "CategoryChipCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProDisplay-Medium", size: 14) ?? .systemFont(ofSize: 14, weight: .medium)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 10
        contentView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, isSelected: Bool) {
        titleLabel.text = title
        
        if isSelected {
            contentView.backgroundColor = UIColor(red: 124/255, green: 58/255, blue: 237/255, alpha: 1.0)
            titleLabel.textColor = .white
        } else {
            contentView.backgroundColor = UIColor(red: 243/255, green: 244/255, blue: 246/255, alpha: 1.0)
            titleLabel.textColor = UIColor(red: 17/255, green: 24/255, blue: 39/255, alpha: 1.0)
        }
    }
}

// MARK: - Left Aligned Flow Layout
class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0

        attributes?.forEach { layoutAttribute in
            if layoutAttribute.representedElementCategory == .cell {
                if layoutAttribute.frame.origin.y >= maxY {
                    leftMargin = sectionInset.left
                }
                layoutAttribute.frame.origin.x = leftMargin
                leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
                maxY = max(layoutAttribute.frame.maxY, maxY)
            }
        }
        return attributes
    }
}
