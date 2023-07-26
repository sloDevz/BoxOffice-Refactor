//
//  SceneDelegate.swift
//  BoxOffice
//
//  Created by kjs on 13/01/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    private enum Constants {
        static let applicationBackColorName: String = "backgroundColor"
        static let defaultTextColorName: String = "DefaultTextColor"
    }

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        let rootViewController = DailyBoxOfficeViewController()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        let appearnace = UINavigationBarAppearance()
        appearnace.configureWithOpaqueBackground()
        appearnace.backgroundColor = UIColor(named: Constants.applicationBackColorName)
        appearnace.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: Constants.defaultTextColorName) ?? .lightGray]
        navigationController.navigationBar.standardAppearance = appearnace
        navigationController.navigationBar.scrollEdgeAppearance = appearnace

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}

