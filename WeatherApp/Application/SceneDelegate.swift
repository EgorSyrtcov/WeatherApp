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

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        initializeFirebase()
        
        if UserService.shared.isLogged {
            print("Show spinner")
            UserService.shared.login(email: "test2@inbox.ru", password: "12345678") { user in
                guard let _ = user else {
                    print("Show login screen")
                    return
                }
                print("Show main screen")
            }
        } else {
            print("Show login screen")
        }
        
//        UserService.shared.login(email: "test2@inbox.ru", password: "12345678") { user in
//            print(user)
//        }
        
                
        
//        print(UserService.shared.isLogged)
        
//        let navVC = UINavigationController(rootViewController: Login())
//
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.windowScene = windowScene
//
//        window?.rootViewController = navVC
//        window?.makeKeyAndVisible()
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
        UserDefaults.standard.synchronize()
    }

}

private extension SceneDelegate {
    func initializeFirebase() {
        FirebaseApp.configure()
    }
}
