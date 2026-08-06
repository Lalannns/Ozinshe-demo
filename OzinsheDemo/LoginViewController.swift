//
//  LoginViewController.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 04.08.2026.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    lazy var welcomeTitle = {
        let label = UILabel()
        label.text = "login_hello".localized()
        label.font = UIFont(name: "SFProDisplay-Bold", size: 14)
        label.textColor = UIColor(named: "111827")
        
        return label
    }()
    
    lazy var welcomeSubtitle = {
        var label = UILabel()
        label.text = "login_instruction".localized()
        label.font = UIFont(name: "SFProDisplay-Bold", size: 14)
        label.textColor = UIColor(named: "111827")
        
        return label
    }()
    
    lazy var emailLabel = {
        let label = UILabel()
        
        label.text = "Email"
        label.font = UIFont(name: "SFProDisplay-Bold", size: 14)
        label.textColor = UIColor(named: "111827")
        
        return label
    }()
    
    
    lazy var emailTextField = {
        let emailTextField = UITextField()
        
        return emailTextField
    }()
    
    lazy var passwordLabel = {
        var label = UILabel()
        
        label.text = "password".localized()
        label.font = UIFont(name: "SFProDisplay-Bold", size: 14)
        label.textColor = UIColor(named: "111827")
        
        return label
    }()
    
    
    lazy var passwordTextField = {
        let textField = UITextField()
        
        textField.isSecureTextEntry = true
                textField.layer.cornerRadius = 12
                textField.layer.borderWidth = 1
                textField.layer.borderColor = UIColor.systemGray5.cgColor
                textField.translatesAutoresizingMaskIntoConstraints = false
                
                // Left Icon (Key)
                let iconView = UIImageView(image: UIImage(named: "password"))
                textField.leftView = iconView
                textField.leftViewMode = .always
                
                // Right Icon (Eye toggle)
                let eyeButton = UIButton(type: .custom)
                eyeButton.setImage(UIImage(named: "show"), for: .normal)
                eyeButton.tintColor = .gray
                eyeButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
                textField.rightView = eyeButton
                textField.rightViewMode = .always
                return textField
    }()
    
    
    lazy var passwordForgotButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "password_forgot".localized()
        
        
        config.baseForegroundColor = UIColor(named: "") ?? UIColor.purple
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont(name: "SFProDisplay-Bold", size: 14) ?? UIFont.systemFont(ofSize: 16, weight: .bold)
            
            return outgoing
        }
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
