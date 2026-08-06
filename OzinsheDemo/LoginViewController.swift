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
        var welcomeTitle = UILabel()
        welcomeTitle.text = "login_hello".localized()
        welcomeTitle.font = UIFont(name: "SFProDisplay-Bold", size: 14)
        welcomeTitle.textColor = UIColor(named: "111827")
        
        return welcomeTitle
    }()
    
    lazy var welcomeSubtitle = {
        var welcomeSubtitle = UILabel()
        welcomeSubtitle.text = "login_instruction".localized()
        welcomeSubtitle.font = UIFont(name: "SFProDisplay-Bold", size: 14)
        welcomeSubtitle.textColor = UIColor(named: "111827")
        
        return welcomeSubtitle
    }()
    
    lazy var emailLabel = {
        let emailLabel = UILabel()
        
        emailLabel.text = "Email"
        emailLabel.font = UIFont(name: "SFProDisplay-Bold", size: 14)
        emailLabel.textColor = UIColor(named: "111827")
        
        return emailLabel
    }()
    
    
    lazy var emailTextField = {
        let emailTextField = UITextField()
        
        return emailTextField
    }()
    
    lazy var passwordLabel = {
        var passwordLabel = UILabel()
        
        passwordLabel.text = "password".localized()
        passwordLabel.font = UIFont(name: "SFProDisplay-Bold", size: 14)
        passwordLabel.textColor = UIColor(named: "111827")
        
        return passwordLabel
    }()
    
    
    lazy var passwordTextField = {
        let passwordTextField = UITextField()
        
        return passwordTextField
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
