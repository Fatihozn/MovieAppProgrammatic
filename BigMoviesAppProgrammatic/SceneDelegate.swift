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
        
        let item1 = UITabBarItem(tabBarSystemItem: .mostViewed, tag: 0)
        let item2 = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 1)
        let item3 = UITabBarItem(tabBarSystemItem: .search, tag: 2)
        let item4 = UITabBarItem(tabBarSystemItem: .favorites, tag: 3)
        
        let firstVC = UINavigationController(rootViewController: HomeScreen(ApiControl: "movie"))
        let secondVC = UINavigationController(rootViewController: HomeScreen(ApiControl: "tv"))
        let thirdVC = UINavigationController(rootViewController: SearchScreen())
        let fourthVC = UINavigationController(rootViewController: FavoriteScreen())
        
        firstVC.tabBarItem = item1
        secondVC.tabBarItem = item2
        thirdVC.tabBarItem = item3
        fourthVC.tabBarItem = item4
        
        tabBarController.viewControllers = [firstVC,secondVC,thirdVC,fourthVC]
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
    }
}

