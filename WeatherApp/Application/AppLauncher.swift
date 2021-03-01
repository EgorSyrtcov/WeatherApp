//
//  AppLauncher.swift
//  WeatherApp
//
//  Created by Egor Syrtcov on 2/27/21.
//

import UIKit

final class AppLauncher {
    
    private let rootViewController = SplashViewController.loadFromNib()

    private lazy var loginNavController: UINavigationController = {
        guard let navController = _loginNavController else {
            _loginNavController = UINavigationController(rootViewController: _loginViewController)
            _loginNavController!.modalPresentationStyle = .overFullScreen
            _loginViewController.delegate = self
            return _loginNavController!
        }
        return navController
    }()

    private lazy var mainNavController: UINavigationController = {
        guard let navController = _mainNavController else {
            _mainNavController = UINavigationController(rootViewController: _mainViewController)
            _mainNavController!.modalPresentationStyle = .overFullScreen
          _mainViewController.delegate = self
            return _mainNavController!
        }
        return navController
    }()

    private var _loginNavController: UINavigationController? = nil
    private let _loginViewController = LoginViewController.loadFromNib()

    private var _mainNavController: UINavigationController? = nil
    private let _mainViewController = MainViewController.loadFromNib()
}

extension AppLauncher {
    func start(from window: UIWindow?) {
        window?.rootViewController = rootViewController
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.startApplicationFlow()
        }
        window?.makeKeyAndVisible()
    }
}

private extension AppLauncher {
    func startApplicationFlow() {
        Dependencies.services.userService.autoLogin { user in
            guard let _ = user else {
                self.startLoginFlow()
                return
            }
            self.startMainFlow()
        }
    }
    
    func startLoginFlow() {
        rootViewController.present(loginNavController, animated: true)
    }
    
    func startMainFlow() {
        rootViewController.present(mainNavController, animated: true)
    }
}

extension AppLauncher: AuthDelegate {
    func didSuccess() {
        rootViewController.present(mainNavController, animated: true)
    }
}

extension AppLauncher: MainViewControllerDelegate {
    func didLogout() {
        rootViewController.present(loginNavController, animated: true)
    }
}
