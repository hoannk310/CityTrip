//
//  TabbarControllerViewController.swift
//  SearchRepositories+Mvvm
//
//  Created by Apple on 3/2/21.
//

import UIKit
import RealmSwift
class TabbarControllerViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let navRepo = generateNav(vc: MainViewController(), title: "Hero", image: UIImage(named: "courage2")!, selectedImage: UIImage(named: "courage3")!)
//        let navUser = generateNav(vc: SearchUserViewController(), title: "Player", image: UIImage(named: "athlete")!, selectedImage: UIImage(named: "athlete2")!)
//        let navItems = generateNav(vc: ItemsListViewController(), title: "Items", image: UIImage(named: "courage")!, selectedImage: UIImage(named: "courage4")!)
//        let navFavorite = generateNav(vc: FavoriteViewController(), title: "Favorite Hero", image: UIImage(named: "touch")!, selectedImage: UIImage(named: "touch2")!)
//        viewControllers = [navRepo, navUser, navItems, navFavorite]
        
        let real = try! Realm()
        print(real.configuration.fileURL!.path)
    }
    
    fileprivate func generateNav(vc: UIViewController, title: String, image: UIImage, selectedImage: UIImage) -> UINavigationController {
        vc.navigationItem.title = title
        let navController = UINavigationController(rootViewController: vc)
        navController.title = title
        navController.tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        return navController
    }
}



