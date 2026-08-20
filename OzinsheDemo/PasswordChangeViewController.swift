//
//  PasswordChangeViewController.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 17.08.2026.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class PasswordChangeViewController: UIViewController {

    // MARK: - UI Components
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.font = UIFont(name: "SFProDisplay-Bold", size: 14) ?? .boldSystemFont(ofSize: 14)
        label.textColor = UIColor(named: "111827") ?? .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var passwordTextField: UITextField = {
        return createCustomTextField(placeholder: "Сіздің құпия сөзіңіз", isConfirmField: false)
    }()

    private let confirmPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Құпия сөзді қайталаңыз"
        label.font = UIFont(name: "SFProDisplay-Bold", size: 14) ?? .boldSystemFont(ofSize: 14)
        label.textColor = UIColor(named: "111827") ?? .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var confirmPasswordTextField: UITextField = {
        return createCustomTextField(placeholder: "Сіздің құпия сөзіңіз", isConfirmField: true)
    }()

    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Өзгерістерді сақтау", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Bold", size: 16) ?? .boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor(red: 124/255, green: 58/255, blue: 237/255, alpha: 1.0)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - UI Setup
    private func setupUI() {
        title = "Құпия сөзді өзгерту"
        view.backgroundColor = .systemBackground

        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordLabel)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(saveButton)

        NSLayoutConstraint.activate([
            // Password Label
            passwordLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            passwordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            // Password TextField
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 8),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 52),

            // Confirm Password Label
            confirmPasswordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            confirmPasswordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            confirmPasswordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            // Confirm Password TextField
            confirmPasswordTextField.topAnchor.constraint(equalTo: confirmPasswordLabel.bottomAnchor, constant: 8),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 52),

            // Save Button
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    // MARK: - Helper Methods
    private func createCustomTextField(placeholder: String, isConfirmField: Bool) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.font = UIFont(name: "SFProDisplay-Regular", size: 15) ?? .systemFont(ofSize: 15)
        textField.isSecureTextEntry = true
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = (UIColor(named: "E5E7EB") ?? UIColor.systemGray5).cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false

        // Left Key Icon
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 52))
        let keyIcon = UIImageView(image: UIImage(named: "Password") ?? UIImage(systemName: "key"))
        keyIcon.tintColor = .systemGray3
        keyIcon.contentMode = .scaleAspectFit
        keyIcon.frame = CGRect(x: 16, y: 16, width: 20, height: 20)
        leftPaddingView.addSubview(keyIcon)
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always

        // Right Eye Icon
        let rightContainer = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 52))
        let eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
        eyeButton.tintColor = .systemGray3
        eyeButton.frame = CGRect(x: 8, y: 16, width: 20, height: 20)
        eyeButton.tag = isConfirmField ? 1 : 0
        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)

        rightContainer.addSubview(eyeButton)
        textField.rightView = rightContainer
        textField.rightViewMode = .always

        return textField
    }

    // MARK: - Actions
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        let targetTextField = (sender.tag == 0) ? passwordTextField : confirmPasswordTextField
        targetTextField.isSecureTextEntry.toggle()

        let imageName = targetTextField.isSecureTextEntry ? "eye" : "eye.slash"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }

    @objc private func saveButtonTapped() {
        guard let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            SVProgressHUD.showError(withStatus: "Барлық өрістерді толтырыңыз")
            return
        }

        guard password == confirmPassword else {
            SVProgressHUD.showError(withStatus: "Құпия сөздер сәйкес келмейді")
            return
        }

        let parameters: [String: Any] = [
            "password": password
        ]

        // Pass stored access token in headers if authorized request is required
        var headers: HTTPHeaders = []
        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            headers.add(.authorization(bearerToken: token))
        }

        SVProgressHUD.show()

        AF.request("https://api.example.com/change-password", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { [weak self] response in
            SVProgressHUD.dismiss()

            guard let self = self else { return }

            if response.response?.statusCode == 200 {
                SVProgressHUD.showSuccess(withStatus: "Құпия сөз сәтті өзгертілді")
                self.navigationController?.popViewController(animated: true)
            } else {
                SVProgressHUD.showError(withStatus: "Қате орын алды")
            }
        }
    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
