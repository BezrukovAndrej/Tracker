//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Andrey Bezrukov on 21.06.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        if !UserDefaults.standard.bool(forKey: "hasShownOnboarding") {
            UserDefaults.standard.set(true, forKey: "hasShownOnboarding")
            let onboardingViewController = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
            window.rootViewController = onboardingViewController
        } else {
            window.rootViewController = TabBarController()
        }
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
