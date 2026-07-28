//
//  LanguageViewController.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 25.07.2026.
//

import UIKit
import SnapKit



protocol LanguageViewControllerDelegate: AnyObject {
    func didSelectLanguage(_ language: String)
}

class LanguageViewController: UIViewController {
    // MARK: - Properties
    
    weak var delegate: LanguageViewControllerDelegate?
    
    private var selectedIndex: Int = 1
    private var rowButtons: [UIButton] = []

    // MARK: - UI Components
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "language".localized()
        label.font = UIFont(name: "SFProDisplay-Semibold", size: 24) ?? .boldSystemFont(ofSize: 24)
        label.textColor = UIColor(named: "1C2431") ?? .black
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.distribution = .fillEqually
        return stack
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.preferredContentSize = CGSize(width: view.bounds.width, height: 100)

        loadSavedSelection()
        setupUI()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(stackView)

        let englishRow = createLanguageRow(title: "English", tag: 0)
        let kazakhRow = createLanguageRow(title: "Қазақша", tag: 1)
        let russianRow = createLanguageRow(title: "Русский", tag: 2)
        
        rowButtons = [englishRow, kazakhRow, russianRow]

        rowButtons.forEach { button in
            stackView.addArrangedSubview(button)
            button.addTarget(self, action: #selector(languageRowTapped(_:)), for: .touchUpInside)
            
            button.snp.makeConstraints { make in
                make.height.equalTo(60)
            }
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.equalToSuperview().offset(24)
        }

        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        updateCheckmarks()
    }
    
    // MARK: - Helper UI Builders
    
    private func createLanguageRow(title: String, tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.tag = tag
        
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: "SFProDisplay-Semibold", size: 16) ?? .systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(named: "1C2431") ?? .black
        button.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        let checkmark = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        checkmark.tintColor = UIColor(red: 0.59, green: 0.33, blue: 0.94, alpha: 1.0)
        checkmark.tag = 999
        checkmark.isHidden = true
        button.addSubview(checkmark)
        
        checkmark.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        let separator = UIView()
        separator.backgroundColor = UIColor.systemGray5
        button.addSubview(separator)
        
        separator.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        return button
    }
    
    // MARK: - Actions & Persistence
    
    @objc private func languageRowTapped(_ sender: UIButton) {
        selectedIndex = sender.tag
        updateCheckmarks()
        
        let selectedLanguage: String
        switch sender.tag {
        case 0: selectedLanguage = "English"
        case 2: selectedLanguage = "Русский"
        default: selectedLanguage = "Қазақша"
        }
        
        
        UserDefaults.standard.set(selectedLanguage, forKey: "selectedLanguage")
        
        
        delegate?.didSelectLanguage(selectedLanguage)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    private func updateCheckmarks() {
        for button in rowButtons {
            let checkmark = button.viewWithTag(999) as? UIImageView
            checkmark?.isHidden = (button.tag != selectedIndex)
        }
    }
    
    private func loadSavedSelection() {
        if let saved = UserDefaults.standard.string(forKey: "selectedLanguage") {
            switch saved {
            case "English": selectedIndex = 0
            case "Русский": selectedIndex = 2
            default: selectedIndex = 1
            }
        }
    }
}



