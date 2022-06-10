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
        
        let navContry = generateNav(vc: CountriesViewController(), title: "Countries", image: UIImage(named: "countries")!, selectedImage: UIImage(named: "countries")!)
        let navLocate = generateNav(vc: LocateCitiesViewController(), title: "My Country", image: UIImage(named: "location")!, selectedImage: UIImage(named: "location")!)
       // let navItems = generateNav(vc: ItemsListViewController(), title: "Items", image: UIImage(named: "courage")!, selectedImage: UIImage(named: "courage4")!)
        let navFavorite = generateNav(vc: FavoriteViewController(), title: "Favorite", image: UIImage(named: "touch")!, selectedImage: UIImage(named: "touch")!)
        viewControllers = [navContry, navLocate, navFavorite]
        
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



