//
//  UserService.swift
//  WeatherApp
//
//  Created by Egor Syrtcov on 2/25/21.
//

import Foundation
import Firebase
import FirebaseAuth

final class UserService {
    static let shared = UserService()
    
    var isLogged: Bool {
        return userDefauls.bool(forKey: UserDefaults.Key.existing.rawValue)
    }
    
    private let firestoreService = FirestoreService()
    private let userDefauls = UserDefaults.standard
    
    private(set) var user: User? = nil
    
    init() {
        let defaults: [String: Any] = [
            UserDefaults.Key.existing.rawValue: false
        ]
        userDefauls.register(defaults: defaults)
    }
}

extension UserService {
    
    func login(email: String, password: String, completion: @escaping(User?)->()) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            guard error == nil,
                  let result = result else {
                self.logout()
                return completion(nil)
            }
            self.firestoreService.fetchUser(by: result.user.uid) { user in
                self.user = user
                self.login()
                completion(user)
            }
        }
    }
    
    func singup(email: String, password: String, completion: @escaping(User?)->()) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            guard error == nil,
                  let result = result else {
                self.logout()
                return completion(nil)
            }
            self.firestoreService.createUser(id: result.user.uid, email: result.user.email)
            self.user = User(id: result.user.uid,
                             email: result.user.email,
                             cities: [])
            self.login()
            completion(self.user)
        }
    }
    
    func logout(completion: @escaping(Bool)->()) {
        do {
            try Auth.auth().signOut()
            user = nil
            logout()
            completion(true)
        } catch { completion(false) }
    }
}

private extension UserService {
    func login() {
        userDefauls.setValue(true, forKey: UserDefaults.Key.existing.rawValue)
    }

    func logout() {
        userDefauls.setValue(false, forKey: UserDefaults.Key.existing.rawValue)
    }
}

private extension UserDefaults {
    enum Key: String {
        case existing
    }
}
