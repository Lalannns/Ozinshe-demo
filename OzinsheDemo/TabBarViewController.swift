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
    
    func setupTabs() {
        let HomeVC = HomeViewController()
        let SearchVC = SearchViewController()
        let FavoriteVC = FavoritesViewController()
        let ProfileVC = ProfileViewController()
        
        
        HomeVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Home"), selectedImage: UIImage(named: "Home"))
        SearchVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Search"), selectedImage: UIImage(named: "Search"))
        FavoriteVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Favorites"), selectedImage: UIImage(named: "Favorites"))
        ProfileVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Profile"), selectedImage: UIImage(named: "Profile"))
        
        setViewControllers([HomeVC,SearchVC,FavoriteVC,ProfileVC], animated: false)
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
