//
//  SceneDelegate.swift
//  BigMoviesAppProgrammatic
//
//  Created by Fatih Özen on 19.03.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let tabBarController = UITabBarController()
        
//        let item1 = UITabBarItem(tabBarSystemItem: .mostViewed, tag: 0)
//        let item2 = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 1)
//        let item3 = UITabBarItem(tabBarSystemItem: .search, tag: 2)
//        let item4 = UITabBarItem(tabBarSystemItem: .favorites, tag: 3)
        
        let vc1 = UINavigationController(rootViewController: HomeScreen(ApiControl: "movie"))
        let vc2 = UINavigationController(rootViewController: HomeScreen(ApiControl: "tv"))
        let vc3 = UINavigationController(rootViewController: SearchScreen())
        let vc4 = UINavigationController(rootViewController: FavoriteScreen())
        
//        firstVC.tabBarItem = item1
//        secondVC.tabBarItem = item2
//        thirdVC.tabBarItem = item3
//        fourthVC.tabBarItem = item4
        vc1.tabBarItem.image = UIImage(systemName: "film")
        vc1.tabBarItem.selectedImage = UIImage(systemName: "film.fill")
        
        vc2.tabBarItem.image = UIImage(systemName: "tv")
        vc2.tabBarItem.selectedImage = UIImage(systemName: "tv.fill")
        
        vc3.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        vc4.tabBarItem.image = UIImage(systemName: "star")
        vc4.tabBarItem.selectedImage = UIImage(systemName: "star.fill")
        
        tabBarController.viewControllers = [vc1,vc2,vc3,vc4]
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
    }
}

