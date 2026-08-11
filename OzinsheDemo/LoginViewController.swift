//
//  LoginViewController.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 04.08.2026.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .onDrag
        return scrollView
    }()
    
    private let contentView = UIView()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "chevron.left")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
        )
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(named: "111827") ?? .black
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var welcomeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "login_hello".localized()
        label.font = UIFont(name: "SFProDisplay-Bold", size: 24) ?? .boldSystemFont(ofSize: 24)
        label.textColor = UIColor(named: "111827") ?? .black
        return label
    }()
    
    private lazy var welcomeSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "login_instruction".localized()
        label.font = UIFont(name: "SFProDisplay-Regular", size: 16) ?? .systemFont(ofSize: 14)
        label.textColor = UIColor(named: "6B7280") ?? .gray
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.font = UIFont(name: "SFProDisplay-Bold", size: 14) ?? .boldSystemFont(ofSize: 14)
        label.textColor = UIColor(named: "111827") ?? .black
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "email_placeholder".localized()
        textField.font = UIFont(name: "SFProDisplay-Regular", size: 16) ?? .systemFont(ofSize: 16)
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = (UIColor(named: "E5E7EB") ?? UIColor.systemGray5).cgColor
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        
        let iconView = UIImageView(image: UIImage(named: "Message") ?? UIImage(systemName: "envelope"))
        iconView.tintColor = .systemGray
        iconView.contentMode = .scaleAspectFit
        
        let paddingContainer = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 48))
        iconView.frame = CGRect(x: 16, y: 14, width: 20, height: 20)
        paddingContainer.addSubview(iconView)
        
        textField.leftView = paddingContainer
        textField.leftViewMode = .always
        return textField
    }()
    
    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "password".localized()
        label.font = UIFont(name: "SFProDisplay-Bold", size: 14) ?? .boldSystemFont(ofSize: 14)
        label.textColor = UIColor(named: "111827") ?? .black
        return label
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "password_placeholder".localized()
        textField.font = UIFont(name: "SFProDisplay-Regular", size: 16) ?? .systemFont(ofSize: 16)
        textField.isSecureTextEntry = true
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = (UIColor(named: "E5E7EB") ?? UIColor.systemGray5).cgColor
        
        let keyIcon = UIImageView(image: UIImage(named: "Password") ?? UIImage(systemName: "key"))
        keyIcon.tintColor = .systemGray
        keyIcon.contentMode = .scaleAspectFit
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 48))
        keyIcon.frame = CGRect(x: 16, y: 14, width: 20, height: 20)
        leftPaddingView.addSubview(keyIcon)
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        
        let rightContainer = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        let eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(named: "Show"), for: .normal)
        eyeButton.tintColor = .gray
        eyeButton.frame = CGRect(x: 12, y: 14, width: 20, height: 20)
        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        rightContainer.addSubview(eyeButton)
        textField.rightView = rightContainer
        textField.rightViewMode = .always
        
        return textField
    }()
    
    private lazy var passwordForgotButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("password_forgot".localized(), for: .normal)
        button.setTitleColor(UIColor(named: "B376F7") ?? UIColor.systemPurple, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 14) ?? .systemFont(ofSize: 14, weight: .semibold)
        button.contentHorizontalAlignment = .right
        button.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("login_button".localized(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Bold", size: 16) ?? .boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor(named: "7C3AED") ?? UIColor(red: 124/255, green: 58/255, blue: 237/255, alpha: 1.0)
        button.layer.cornerRadius = 12
        button.layer.shadowColor = (UIColor(named: "7C3AED") ?? UIColor.purple).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.25
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("signup_link".localized(), for: .normal)
        button.setTitleColor(UIColor(named: "B376F7") ?? UIColor.systemPurple, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Bold", size: 14) ?? .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var signUpPromptStackView: UIStackView = {
        let label = UILabel()
        label.text = "no_account_prompt".localized()
        label.font = UIFont(name: "SFProDisplay-Regular", size: 14) ?? .systemFont(ofSize: 14)
        label.textColor = UIColor(named: "6B7280") ?? .gray
        
        let stack = UIStackView(arrangedSubviews: [label, signUpButton])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    // MARK: - Layout Setup
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(backButton)
        contentView.addSubview(welcomeTitleLabel)
        contentView.addSubview(welcomeSubtitleLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordLabel)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(passwordForgotButton)
        contentView.addSubview(loginButton)
        contentView.addSubview(signUpPromptStackView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(24)
            make.size.equalTo(24)
        }
        
        welcomeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        welcomeSubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeTitleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeSubtitleLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(52)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(52)
        }
        
        passwordForgotButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(12)
            make.trailing.equalToSuperview().inset(24)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordForgotButton.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(52)
        }
        
        signUpPromptStackView.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-24)
        }
    }
    
    // MARK: - Actions
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        let imageName = passwordTextField.isSecureTextEntry ? "ic_eye" : "ic_eye_slash"
        sender.setImage(UIImage(named: imageName) ?? UIImage(systemName: passwordTextField.isSecureTextEntry ? "eye" : "eye.slash"), for: .normal)
    }
    
    @objc private func forgotPasswordTapped() {
        // Navigate to Forgot Password screen
    }
    
    @objc private func loginButtonTapped() {
        // Execute login
    }
    
    @objc private func signUpTapped() {
        let signInVC = SignInViewController()
        navigationController?.pushViewController(signInVC, animated: true)
    }
}
