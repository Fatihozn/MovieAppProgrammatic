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
        let item3 = UITabBarItem(title: "SEARCH", image: .add, tag: 2)
        
        let navigationController = UINavigationController(rootViewController: HomeScreen())
        let secondVC = UINavigationController(rootViewController: HomeScreen())
        let thirdVC = SearchScreen()
        
       
        
        navigationController.tabBarItem = item1
        secondVC.tabBarItem = item2
        thirdVC.tabBarItem = item3
        
        tabBarController.viewControllers = [navigationController,secondVC,thirdVC]
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
    }


}

