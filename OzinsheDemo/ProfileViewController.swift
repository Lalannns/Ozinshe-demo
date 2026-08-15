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
        imageView.layer.cornerRadius = 52
        return imageView
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProDisplay-Bold", size: 24) ?? .boldSystemFont(ofSize: 24)
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
    private lazy var notificationsSwitch: ImageSwitch = {
        let toggle = ImageSwitch(isOn: true)
        toggle.onStateChanged = { [weak self] isOn in
            // Handle notifications toggle change
        }
        return toggle
    }()

    private lazy var modeLabel: UILabel = createMenuLabel()
    private lazy var modeSwitch: ImageSwitch = {
        let toggle = ImageSwitch(isOn: false)
        toggle.onStateChanged = { [weak self] isOn in
            // Handle dark mode toggle change
        }
        return toggle
    }()
    
    // Background extending to screen bottom
    private lazy var grayBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "F9FAFB") ?? .systemGroupedBackground
        return view
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            userInfoButton,
            passwordChangeButton,
            languageChangeButton,
            rulesPageButton,
            notificationsContainerView,
            modeContainerView
        ])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 0
        return stack
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupNavigationBar()
        setupUI()
        updateLocalizedTexts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Navigation Bar Setup
    
    private func setupNavigationBar() {
        navigationItem.title = "profile_title".localized()
        
        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = UIColor.systemGray5
        
        appearance.titleTextAttributes = [
            .font: UIFont(name: "SFProDisplay-Bold", size: 16) ?? .systemFont(ofSize: 16, weight: .bold),
            .foregroundColor: UIColor.black
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // Back / Left Button
        if let backImage = UIImage(named: "Chevron-Back-Navigation")?.withRenderingMode(.alwaysOriginal) {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: backImage,
                style: .plain,
                target: self,
                action: #selector(backButtonTapped)
            )
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "chevron.left"),
                style: .plain,
                target: self,
                action: #selector(backButtonTapped)
            )
        }
    
        // Logout / Right Button
        if let logoutImage = UIImage(named: "Logout")?.withRenderingMode(.alwaysOriginal) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: logoutImage,
                style: .plain,
                target: self,
                action: #selector(didTapLogout)
            )
        } else {
            let logoutItem = UIBarButtonItem(
                image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
                style: .plain,
                target: self,
                action: #selector(didTapLogout)
            )
            logoutItem.tintColor = UIColor(red: 1.0, green: 0.23, blue: 0.19, alpha: 1.0)
            navigationItem.rightBarButtonItem = logoutItem
        }
    }

    // MARK: - UI Setup & Constraints
    
    private func setupUI() {
        avatarImageView.layer.cornerRadius = 52

        [avatarImageView, userNameLabel, userMailLabel, grayBackgroundView, contentStackView].forEach {
            view.addSubview($0)
        }

        userInfoButton.addSubview(userInfoDetailLabel)
        languageChangeButton.addSubview(languageDetailLabel)
        
        // Button actions
        userInfoButton.addTarget(self, action: #selector(userInfoButtonTapped), for: .touchUpInside)
        passwordChangeButton.addTarget(self, action: #selector(passwordChangeButtonTapped), for: .touchUpInside)
        languageChangeButton.addTarget(self, action: #selector(languageChangeButtonTapped), for: .touchUpInside)
        rulesPageButton.addTarget(self, action: #selector(rulesPageButtonTapped), for: .touchUpInside)

        notificationsContainerView.addSubview(notificationsLabel)
        notificationsContainerView.addSubview(notificationsSwitch)

        modeContainerView.addSubview(modeLabel)
        modeContainerView.addSubview(modeSwitch)
        modeContainerView.subviews.first(where: { $0.backgroundColor == UIColor.systemGray5 })?.isHidden = true

        [userInfoButton, passwordChangeButton, languageChangeButton, rulesPageButton].forEach {
            addChevron(to: $0)
        }

        // --- SnapKit Constraints ---
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(104)
        }

        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }

        userMailLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }

        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(userMailLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
        }

        // Set row heights explicitly for stack elements
        [userInfoButton, passwordChangeButton, languageChangeButton, rulesPageButton, notificationsContainerView, modeContainerView].forEach { row in
            row.snp.makeConstraints { make in
                make.height.equalTo(68)
            }
        }

        grayBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(contentStackView.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }

        // Inner Row Constraints (positioned clear of the chevron)
        userInfoDetailLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(48)
        }

        languageDetailLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(48)
        }

        notificationsLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }

        notificationsSwitch.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
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
        button.backgroundColor = (UIColor(named: "F9FAFB") ?? .gray)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
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
        let chevron = UIImageView(image: UIImage(named: "chevron.right") ?? UIImage(systemName: "chevron.right"))
        chevron.tintColor = .systemGray3
        chevron.contentMode = .scaleAspectFit
        button.addSubview(chevron)
        chevron.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(16)
            make.height.equalTo(16)
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
    
    @objc private func userInfoButtonTapped() {
        // Navigate to Personal Info screen
    }

    @objc private func passwordChangeButtonTapped() {
        // Navigate to Change Password screen
    }

    @objc private func rulesPageButtonTapped() {
        // Navigate to Terms & Conditions screen
    }

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
    
    
    
    // change later to a full screen instead of alert pop-up
    
    @objc private func didTapLogout() {
        let alert = UIAlertController(
            title: "logout".localized(),
            message: "alert".localized(),
            preferredStyle: .actionSheet
        )
        
        let logoutAction = UIAlertAction(title: "yes".localized(), style: .destructive) { [weak self] _ in
            self?.performLogout()
        }
        
        let cancelAction = UIAlertAction(title: "no".localized(), style: .cancel)
        
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    

    private func performLogout() {
        // Clear token & stored user data
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        Storage.sharedInstance.accessToken = ""

        // Navigate back to Onboarding/Login root
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = windowScene.delegate as? SceneDelegate,
              let window = delegate.window else { return }

        let onboardingVC = UINavigationController(rootViewController: OnboardingViewController())

        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
            window.rootViewController = onboardingVC
        }
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

// MARK: - Custom Image Switch Control

class ImageSwitch: UIButton {
    
    var onStateChanged: ((Bool) -> Void)?
    
    var isOn: Bool = false {
        didSet {
            updateImage()
            onStateChanged?(isOn)
        }
    }
    
    init(isOn: Bool = false) {
        self.isOn = isOn
        super.init(frame: .zero)
        setupButton()
        updateImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        addTarget(self, action: #selector(toggleTapped), for: .touchUpInside)
    }
    
    private func updateImage() {
        let imageName = isOn ? "switch-on" : "switch-off"
        setImage(UIImage(named: imageName), for: .normal)
    }
    
    @objc private func toggleTapped() {
        isOn.toggle()
    }
}
