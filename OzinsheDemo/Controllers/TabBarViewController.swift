//
//  TabBarViewController.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 12.07.2026.
//

import UIKit

 class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupTabs()
    }

    private func setupTabs() {
        let HomeVC = UINavigationController(rootViewController: HomeViewController())
        HomeVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Home"), selectedImage: UIImage(named: "Home"))

        let SearchVC = UINavigationController(rootViewController: SearchViewController())
        SearchVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Search"), selectedImage: UIImage(named: "Search"))

        let FavoritesVC = UINavigationController(rootViewController: FavoritesViewController())
        FavoritesVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Favorites"), selectedImage: UIImage(named: "Favorites"))

        let ProfileVC = UINavigationController(rootViewController: ProfileViewController())
        ProfileVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Profile"), selectedImage: UIImage(named: "Profile"))

        setViewControllers([HomeVC, SearchVC, FavoritesVC, ProfileVC], animated: false)
    }

     private func finishOnboarding() {
         guard let window = view.window else { return }
         
         // Embed LoginVC in a NavigationController if you need navigation bar back/forward support later
         let loginVC = UINavigationController(rootViewController: LoginViewController())
         
         UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
             window.rootViewController = loginVC
         })
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
