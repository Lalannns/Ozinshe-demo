//
//  ProfileViewController.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 12.07.2026.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {

    // MARK: - UI Components
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Avatar")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProDisplay-Bold", size: 20) ?? .boldSystemFont(ofSize: 20)
        label.textColor = UIColor(named: "1C2431") ?? .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var userMailLabel: UILabel = {
        let label = UILabel()
        label.text = "ali@gmail.com"
        label.font = UIFont(name: "SFProDisplay-Regular", size: 14) ?? .systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Menu Buttons & Action Rows
    private lazy var userInfoButton: UIButton = createMenuButton()
    private lazy var passwordChangeButton: UIButton = createMenuButton()
    private lazy var languageChangeButton: UIButton = createMenuButton()
    private lazy var rulesPageButton: UIButton = createMenuButton()
    
    private lazy var userInfoDetailLabel: UILabel = createDetailLabel()
    private lazy var languageDetailLabel: UILabel = createDetailLabel()
    
    // MARK: - Toggle Switches & Labels
    private lazy var notificationsLabel: UILabel = createMenuLabel()
    private lazy var notificationsSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = UIColor(red: 0.59, green: 0.33, blue: 0.94, alpha: 1.0)
        return toggle
    }()
    
    private lazy var modeLabel: UILabel = createMenuLabel()
    private lazy var modeSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = UIColor(red: 0.59, green: 0.33, blue: 0.94, alpha: 1.0)
        return toggle
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.99, alpha: 1.0)
        
        setupNavigationBar()
        setupUI()
        updateLocalizedTexts()
    }
    
    // MARK: - Navigation Bar Setup
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
        
        let logoutButton = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .plain, target: self, action: #selector(logoutButtonTapped))
        logoutButton.tintColor = .systemRed
        navigationItem.rightBarButtonItem = logoutButton
    }

    // MARK: - UI Setup & Constraints
    private func setupUI() {
        view.addSubview(avatarImageView)
        view.addSubview(userNameLabel)
        view.addSubview(userMailLabel)
        
        view.addSubview(userInfoButton)
        view.addSubview(passwordChangeButton)
        view.addSubview(languageChangeButton)
        view.addSubview(rulesPageButton)
        
        userInfoButton.addSubview(userInfoDetailLabel)
        languageChangeButton.addSubview(languageDetailLabel)
        
        addChevron(to: userInfoButton)
        addChevron(to: passwordChangeButton)
        addChevron(to: languageChangeButton)
        addChevron(to: rulesPageButton)
        
        view.addSubview(notificationsLabel)
        view.addSubview(notificationsSwitch)
        
        view.addSubview(modeLabel)
        view.addSubview(modeSwitch)
        
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(104)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        
        userMailLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        userInfoButton.snp.makeConstraints { make in
            make.top.equalTo(userMailLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(54)
        }
        
        userInfoDetailLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(28)
        }
        
        passwordChangeButton.snp.makeConstraints { make in
            make.top.equalTo(userInfoButton.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(54)
        }
        
        languageChangeButton.snp.makeConstraints { make in
            make.top.equalTo(passwordChangeButton.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(54)
        }
        
        languageChangeButton.addTarget(self, action: #selector(languageChangeButtonTapped), for: .touchUpInside)
        
        languageDetailLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(28)
        }
        
        rulesPageButton.snp.makeConstraints { make in
            make.top.equalTo(languageChangeButton.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(54)
        }
        
        notificationsLabel.snp.makeConstraints { make in
            make.top.equalTo(rulesPageButton.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
        }
        
        notificationsSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(notificationsLabel)
            make.trailing.equalToSuperview().inset(16)
        }
        
        modeLabel.snp.makeConstraints { make in
            make.top.equalTo(notificationsLabel.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(16)
        }
        
        modeSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(modeLabel)
            make.trailing.equalToSuperview().inset(16)
        }
    }

    // MARK: - Update Localized Strings
    func updateLocalizedTexts() {
        navigationItem.title = "profile_title".localized()
        userNameLabel.text = "my_profile".localized()
        
        userInfoButton.setTitle("personal_data".localized(), for: .normal)
        passwordChangeButton.setTitle("change_password".localized(), for: .normal)
        languageChangeButton.setTitle("language".localized(), for: .normal)
        rulesPageButton.setTitle("terms_and_conditions".localized(), for: .normal)
        
        notificationsLabel.text = "notifications".localized()
        modeLabel.text = "dark_mode".localized()
        userInfoDetailLabel.text = "edit".localized()
        
        // Update language label display
        let currentLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "Қазақша"
        languageDetailLabel.text = currentLanguage
    }

    // MARK: - Helper UI Builders
    private func createMenuButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitleColor(UIColor(named: "1C2431") ?? .black, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 16) ?? .systemFont(ofSize: 16, weight: .medium)
        button.contentHorizontalAlignment = .left
        
        let line = UIView()
        line.backgroundColor = UIColor.systemGray5
        button.addSubview(line)
        line.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        return button
    }
    
    private func createMenuLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: "SFProDisplay-Medium", size: 16) ?? .systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(named: "1C2431") ?? .black
        return label
    }
    
    private func createDetailLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: "SFProDisplay-Regular", size: 14) ?? .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }
    
    private func addChevron(to button: UIButton) {
        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevron.tintColor = UIColor(red: 0.59, green: 0.33, blue: 0.94, alpha: 1.0)
        chevron.contentMode = .scaleAspectFit
        button.addSubview(chevron)
        chevron.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.height.equalTo(16)
        }
    }

    // MARK: - Actions
    
    @objc private func languageChangeButtonTapped() {
        let languageVC = LanguageViewController()
        languageVC.delegate = self
        
        if let sheet = languageVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24
        }
        
        present(languageVC, animated: true)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func logoutButtonTapped() {
        // Handle logout logic
    }
}

// MARK: - Delegate Conformance

extension ProfileViewController: LanguageViewControllerDelegate {
    func didSelectLanguage(_ language: String) {
        updateLocalizedTexts()
    }
}

