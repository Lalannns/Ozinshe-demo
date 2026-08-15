//
//  SignInViewController.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 06.08.2026.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class SignInViewController: UIViewController {
    
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
    
    private lazy var registerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "signup_title".localized()
        label.font = UIFont(name: "SFProDisplay-Bold", size: 24) ?? .boldSystemFont(ofSize: 24)
        label.textColor = UIColor(named: "111827") ?? .black
        return label
    }()
    
    private lazy var registerSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "signup_subtitle".localized()
        label.font = UIFont(name: "SFProDisplay-Regular", size: 16) ?? .systemFont(ofSize: 14)
        label.textColor = UIColor(named: "6B7280") ?? .gray
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "email".localized()
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
    
    private lazy var confirmPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "confirm_password".localized()
        label.font = UIFont(name: "SFProDisplay-Bold", size: 14) ?? .boldSystemFont(ofSize: 14)
        label.textColor = UIColor(named: "111827") ?? .black
        return label
    }()

    private lazy var confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "confirm_password_placeholder".localized()
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
        eyeButton.addTarget(self, action: #selector(toggleConfirmPasswordVisibility), for: .touchUpInside)
        
        rightContainer.addSubview(eyeButton)
        textField.rightView = rightContainer
        textField.rightViewMode = .always
        
        return textField
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("signup_link".localized(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Bold", size: 16) ?? .boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor(named: "7C3AED") ?? UIColor(red: 124/255, green: 58/255, blue: 237/255, alpha: 1.0)
        button.layer.cornerRadius = 12
        button.layer.shadowColor = (UIColor(named: "7C3AED") ?? UIColor.purple).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.25
        button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("login_link".localized(), for: .normal)
        button.setTitleColor(UIColor(named: "B376F7") ?? UIColor.systemPurple, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Bold", size: 14) ?? .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var signInPromptStackView: UIStackView = {
        let label = UILabel()
        label.text = "already_have_account".localized()
        label.font = UIFont(name: "SFProDisplay-Regular", size: 14) ?? .systemFont(ofSize: 14)
        label.textColor = UIColor(named: "6B7280") ?? .gray
        
        let stack = UIStackView(arrangedSubviews: [label, signInButton])
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar so only the custom back button shows
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Re-enable navigation bar for subsequent screens if needed
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Layout Setup
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(backButton)
        contentView.addSubview(registerTitleLabel)
        contentView.addSubview(registerSubtitleLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordLabel)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(confirmPasswordLabel)
        contentView.addSubview(confirmPasswordTextField)
        contentView.addSubview(registerButton)
        contentView.addSubview(signInPromptStackView)
        
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
        
        registerTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        registerSubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(registerTitleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(registerSubtitleLabel.snp.bottom).offset(32)
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
        
        confirmPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        confirmPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(52)
        }
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(52)
        }
        
        signInPromptStackView.snp.makeConstraints { make in
            make.top.equalTo(registerButton.snp.bottom).offset(24)
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
    
    @objc private func toggleConfirmPasswordVisibility(_ sender: UIButton) {
        confirmPasswordTextField.isSecureTextEntry.toggle()
        let imageName = confirmPasswordTextField.isSecureTextEntry ? "ic_eye" : "ic_eye_slash"
        sender.setImage(UIImage(named: imageName) ?? UIImage(systemName: confirmPasswordTextField.isSecureTextEntry ? "eye" : "eye.slash"), for: .normal)
    }
    
    @objc private func signInTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func registerButtonTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            SVProgressHUD.showError(withStatus: "Fill in all fields")
            return
        }
        
        guard password == confirmPassword else {
            SVProgressHUD.showError(withStatus: "Passwords do not match")
            return
        }
        
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        SVProgressHUD.show()
        
        AF.request(URLs.SIGN_UP_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData { [weak self] response in
            SVProgressHUD.dismiss()
            
            guard let self = self else { return }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                if let token = json["accessToken"].string {
                    UserDefaults.standard.set(token, forKey: "accessToken")
                    Storage.sharedInstance.accessToken = token
                    
                    // Transition root view controller safely
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                          let delegate = windowScene.delegate as? SceneDelegate,
                          let window = delegate.window else { return }
                    
                    let mainTabBar = TabBarViewController()
                    UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
                        window.rootViewController = mainTabBar
                    }
                }
            } else {
                SVProgressHUD.showError(withStatus: "CONECTION_ERROR".localized())
            }
        }
    }




    //Must: handle password matching logic and error calls 
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
