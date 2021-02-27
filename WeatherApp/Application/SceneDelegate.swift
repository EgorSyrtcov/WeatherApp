//
//  SceneDelegate.swift
//  WeatherApp
//
//  Created by Egor Syrtcov on 2/25/21.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private let appLauncher = AppLauncher()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        initializeFirebase()
        initializeWindow(windowScene)
        appLauncher.start(from: window)
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

private extension SceneDelegate {
    func initializeFirebase() {
        FirebaseApp.configure()
    }
    
    func initializeWindow(_ scene: UIWindowScene) {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = scene
    }
}
