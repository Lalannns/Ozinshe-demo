//
//  SearchViewController.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 12.07.2026.
//
import UIKit
import SnapKit
import Alamofire

class SearchViewController: UIViewController {

    // MARK: - Properties
    private var movies: [Movie] = []
    private var categories: [Movie.Category] = []
    private var searchTimer: Timer?

    // MARK: - UI Components
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "SFProDisplay-Regular", size: 16) ?? .systemFont(ofSize: 16)
        textField.textColor = .appTextColor
        textField.backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 28/255, green: 34/255, blue: 48/255, alpha: 1.0)
                : UIColor(red: 243/255, green: 244/255, blue: 246/255, alpha: 1.0)
        }
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 0
        
        textField.attributedPlaceholder = NSAttributedString(
            string: "search".localized(),
            attributes: [.foregroundColor: UIColor.systemGray]
        )
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 48))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        let clearButton = UIButton(type: .custom)
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)
        clearButton.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: config), for: .normal)
        clearButton.tintColor = .systemGray
        clearButton.frame = CGRect(x: 0, y: 0, width: 40, height: 48)
        clearButton.addTarget(self, action: #selector(clearSearchText), for: .touchUpInside)
        
        textField.rightView = clearButton
        textField.rightViewMode = .whileEditing
        return textField
    }()

    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        let image = UIImage(systemName: "magnifyingglass", withConfiguration: config)
        button.setImage(image, for: .normal)
        
        button.tintColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .white : UIColor(red: 17/255, green: 24/255, blue: 39/255, alpha: 1.0)
        }
        button.backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 28/255, green: 34/255, blue: 48/255, alpha: 1.0)
                : UIColor(red: 243/255, green: 244/255, blue: 246/255, alpha: 1.0)
        }
        button.layer.cornerRadius = 12
        return button
    }()

    private let categoriesHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "categories_title".localized()
        label.font = UIFont(name: "SFProDisplay-Bold", size: 24) ?? .boldSystemFont(ofSize: 24)
        label.textColor = .appTextColor
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.register(CategoryChipCell.self, forCellWithReuseIdentifier: CategoryChipCell.identifier)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()

    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.isHidden = true
        tv.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appBackground
        
        setupUI()
        setupActions()
        
        // Explicitly set initial view state
        collectionView.isHidden = false
        categoriesHeaderLabel.isHidden = false
        tableView.isHidden = true
        
        fetchCategories()
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(searchTextField)
        view.addSubview(searchButton)
        view.addSubview(categoriesHeaderLabel)
        view.addSubview(collectionView)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)

        searchButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(56)
        }

        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(searchButton)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(searchButton.snp.leading).offset(-12)
            make.height.equalTo(56)
        }

        categoriesHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(categoriesHeaderLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(tableView)
        }
    }

    private func setupActions() {
        searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    }

    // MARK: - Actions & Search Debounce
    @objc private func textFieldDidChange(_ textField: UITextField) {
        searchTimer?.invalidate()
        
        let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let isSearching = !text.isEmpty
        
        collectionView.isHidden = isSearching
        categoriesHeaderLabel.isHidden = isSearching
        tableView.isHidden = !isSearching

        guard isSearching else {
            movies.removeAll()
            tableView.reloadData()
            return
        }

        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
            self?.fetchSearchResults(query: text)
        }
    }

    @objc private func clearSearchText() {
        searchTextField.text = ""
        textFieldDidChange(searchTextField)
        searchTextField.resignFirstResponder()
    }

    @objc private func searchButtonTapped() {
        searchTextField.resignFirstResponder()
        if let query = searchTextField.text, !query.isEmpty {
            fetchSearchResults(query: query)
        }
    }

    // MARK: - API Calls
    private func fetchCategories() {
        // 1. Fetch token matching the key saved in SignInViewController / Storage
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? Storage.sharedInstance.accessToken
        
        guard !token.isEmpty else {
            print("⚠️ Token is empty. Log in again.")
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]

        AF.request(URLs.CATEGORIES_URL, method: .get, headers: headers)
            .responseData { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case .success(let data):
                    if response.response?.statusCode == 200 {
                        do {
                            let decoder = JSONDecoder()
                            let fetchedCategories = try decoder.decode([Movie.Category].self, from: data)
                            print("✅ Fetched \(fetchedCategories.count) categories")
                            
                            self.categories = fetchedCategories
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                            }
                        } catch {
                            print("❌ Decoding Error: \(error)")
                        }
                    } else {
                        print("🌐 Server Error: Status Code \(response.response?.statusCode ?? 0)")
                    }
                case .failure(let error):
                    print("❌ Request Error: \(error.localizedDescription)")
                }
            }
    }
    
    private func fetchSearchResults(query: String) {
        activityIndicator.startAnimating()
        
        let parameters: [String: Any] = ["search": query]
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "userToken") ?? "")"
        ]

        AF.request(URLs.SEARCH_MOVIES_URL, method: .get, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: [Movie].self) { [weak self] response in
                guard let self = self else { return }
                self.activityIndicator.stopAnimating()

                switch response.result {
                case .success(let fetchedMovies):
                    self.movies = fetchedMovies
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error searching movies: \(error.localizedDescription)")
                    self.movies.removeAll()
                    self.tableView.reloadData()
                }
            }
    }
}

// CollectionView DataSource & DelegateFlowLayout
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryChipCell.identifier, for: indexPath) as? CategoryChipCell else {
            return UICollectionViewCell()
        }
        let category = categories[indexPath.item]
        cell.configure(title: category.name.localized())
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let categoryName = categories[indexPath.item].name.localized()
        
        let font = UIFont(name: "SFProDisplay-Semibold", size: 12) ?? .systemFont(ofSize: 12, weight: .semibold)
        let textWidth = categoryName.size(withAttributes: [.font: font]).width
        
        return CGSize(width: max(textWidth + 32, 60), height: 34)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.item]
        
        let categoryVC = CategoryViewController()
        categoryVC.categoryName = selectedCategory.name.localized()
        categoryVC.categoryID = selectedCategory.id
        
        navigationController?.pushViewController(categoryVC, animated: true)
    }
}
// MARK: - TableView DataSource & Delegate
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: movies[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedMovie = movies[indexPath.row]
        
        let detailVC = DetailViewController()
        detailVC.movieID = selectedMovie.id
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

