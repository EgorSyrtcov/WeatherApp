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
    
    private let splashViewController = SplashViewController.loadFromNib()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        initializeFirebase()
        initializeWindow(windowScene)
        handleApplicationFlow { state in
            switch state {
            case .login: self.showAuthFlow()
            case .main: self.showMainFlow()
            }
        }
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
        let navController = UINavigationController(rootViewController: SplashViewController.loadFromNib())
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
    
    func handleApplicationFlow(completion: @escaping(AppState)->()) {
        UserService.shared.autoLogin { user in
            completion(user == nil ? .login : .main)
        }
    }
}

private extension SceneDelegate {
    func showAuthFlow() {
        let navController = UINavigationController(rootViewController: LoginViewController())
        navController.modalPresentationStyle = .overFullScreen
        splashViewController.present(navController, animated: true)
    }
    
    func showMainFlow() {
        let navController = UINavigationController(rootViewController: MainViewController.loadFromNib())
        navController.modalPresentationStyle = .overFullScreen
        splashViewController.present(navController, animated: true)
    }
}
