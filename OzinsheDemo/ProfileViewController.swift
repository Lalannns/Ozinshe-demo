//
//  ProfileViewController.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 12.07.2026.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {

    // MARK: - Properties
    
    private var blurEffectView: UIVisualEffectView?

    // MARK: - UI Components
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Avatar")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 52 // 1. Perfect circular avatar mask
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
    
    // MARK: - Menu Buttons & Containers
    private lazy var userInfoButton: UIButton = createMenuButton()
    private lazy var passwordChangeButton: UIButton = createMenuButton()
    private lazy var languageChangeButton: UIButton = createMenuButton()
    private lazy var rulesPageButton: UIButton = createMenuButton()
    
    private lazy var userInfoDetailLabel: UILabel = createDetailLabel()
    private lazy var languageDetailLabel: UILabel = createDetailLabel()
    
    // MARK: - Switch Rows (Containers)
    private lazy var notificationsContainerView: UIView = createRowContainer()
    private lazy var modeContainerView: UIView = createRowContainer()
    
    private lazy var notificationsLabel: UILabel = createMenuLabel()
    private lazy var notificationsSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = UIColor(red: 0.59, green: 0.33, blue: 0.94, alpha: 1.0)
        toggle.isOn = true // 2. Set default state to ON per Figma design
        return toggle
    }()
    
    private lazy var modeLabel: UILabel = createMenuLabel()
    private lazy var modeSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = UIColor(red: 0.59, green: 0.33, blue: 0.94, alpha: 1.0)
        return toggle
    }()
    
    
    // Background extending to screen bottom
        private lazy var grayBackgroundView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(named: "F9FAFB") ?? .systemGroupedBackground
            return view
        }()
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 3. Off-white background for contrast against white card rows
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupUI()
        updateLocalizedTexts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 4. Ensure navigation bar stays visible when navigating here
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Navigation Bar Setup
    
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(
            image: UIImage(named: "Back")
        )
        navigationItem.leftBarButtonItem = backButton
        
        let logoutButton = UIBarButtonItem(
            image: UIImage(named: "Logout-button"),
            style: .plain,
            target: self,
            action: #selector(logoutButtonTapped)
        )
        navigationItem.rightBarButtonItem = logoutButton
    }

    // MARK: - UI Setup & Constraints
        private func setupUI() {
            avatarImageView.layer.cornerRadius = 52
            
            view.addSubview(avatarImageView)
            view.addSubview(userNameLabel)
            view.addSubview(userMailLabel)
            
            // 1. Add gray background container behind all menu rows
            view.addSubview(grayBackgroundView)
            
            // Button rows
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
            
            // Switch container rows
            view.addSubview(notificationsContainerView)
            notificationsContainerView.addSubview(notificationsLabel)
            notificationsContainerView.addSubview(notificationsSwitch)
            
            view.addSubview(modeContainerView)
            modeContainerView.addSubview(modeLabel)
            modeContainerView.addSubview(modeSwitch)
            
            // --- SnapKit Constraints ---
            
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
            
            // --- Rows (56pt height) ---
            
            userInfoButton.snp.makeConstraints { make in
                make.top.equalTo(userMailLabel.snp.bottom).offset(24)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(56)
            }
            
            // 2. Pin gray background from the top of the first item to the very bottom of the screen
            grayBackgroundView.snp.makeConstraints { make in
                make.top.equalTo(userInfoButton.snp.top)
                make.leading.trailing.bottom.equalToSuperview()
            }
            
            userInfoDetailLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().inset(36)
            }
            
            passwordChangeButton.snp.makeConstraints { make in
                make.top.equalTo(userInfoButton.snp.bottom)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(56)
            }
            
            languageChangeButton.snp.makeConstraints { make in
                make.top.equalTo(passwordChangeButton.snp.bottom)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(56)
            }
            languageChangeButton.addTarget(self, action: #selector(languageChangeButtonTapped), for: .touchUpInside)
            
            languageDetailLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().inset(36)
            }
            
            rulesPageButton.snp.makeConstraints { make in
                make.top.equalTo(languageChangeButton.snp.bottom)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(56)
            }
            
            // Notifications Container Row
            notificationsContainerView.snp.makeConstraints { make in
                make.top.equalTo(rulesPageButton.snp.bottom)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(56)
            }
            
            notificationsLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().offset(16)
            }
            
            notificationsSwitch.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().inset(16)
            }
            
            // Dark Mode Container Row
            modeContainerView.snp.makeConstraints { make in
                make.top.equalTo(notificationsContainerView.snp.bottom)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(56)
            }
            
            modeLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().offset(16)
            }
            
            modeSwitch.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
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
        
        let currentLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "Қазақша"
        languageDetailLabel.text = currentLanguage
    }

    // MARK: - Helper UI Builders
    
    private func createMenuButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitleColor(UIColor(named: "1C2431") ?? .black, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 16) ?? .systemFont(ofSize: 16, weight: .medium)
        button.contentHorizontalAlignment = .left
        
        // 5. White background color for clean contrast against the screen background
        button.backgroundColor = (UIColor(named: "F9FAFB") ?? .gray)
        
        // 6. Padding inside the button so text aligns with the 16pt margin
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        // 7. Inset bottom separator line matching Figma design
        let line = UIView()
        line.backgroundColor = UIColor.systemGray5
        button.addSubview(line)
        line.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        return button
    }
    
    private func createRowContainer() -> UIView {
        let container = UIView()
        container.backgroundColor = (UIColor(named: "F9FAFB") ?? .gray)
        
        let line = UIView()
        line.backgroundColor = UIColor.systemGray5
        container.addSubview(line)
        line.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        return container
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
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(8)
            make.height.equalTo(14)
        }
    }

    // MARK: - Blur Helpers
    
    private func addBackgroundBlur() {
        let blurEffect = UIBlurEffect(style: .systemThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.alpha = 0
        
        view.addSubview(blurView)
        self.blurEffectView = blurView
        
        UIView.animate(withDuration: 0.25) {
            blurView.alpha = 0.85
        }
    }

    private func removeBackgroundBlur() {
        UIView.animate(withDuration: 0.25, animations: {
            self.blurEffectView?.alpha = 0
        }) { _ in
            self.blurEffectView?.removeFromSuperview()
            self.blurEffectView = nil
        }
    }

    // MARK: - Actions
    
    @objc private func languageChangeButtonTapped() {
        let languageVC = LanguageViewController()
        languageVC.delegate = self
        languageVC.presentationController?.delegate = self
        
        if let sheet = languageVC.sheetPresentationController {
            if #available(iOS 16.0, *) {
                sheet.detents = [
                    .custom { _ in
                        return 300
                    }
                ]
            } else {
                sheet.detents = [.medium()]
            }
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 32
            sheet.largestUndimmedDetentIdentifier = .medium
        }
        
        addBackgroundBlur()
        present(languageVC, animated: true)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func logoutButtonTapped() {
        // Handle logout logic
    }
}

// MARK: - Language Delegate & Presentation Conformance

extension ProfileViewController: LanguageViewControllerDelegate {
    func didSelectLanguage(_ language: String) {
        removeBackgroundBlur()
        updateLocalizedTexts()
    }
}

extension ProfileViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        removeBackgroundBlur()
    }
}
