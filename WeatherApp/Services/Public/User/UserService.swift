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
    private let firestoreService = FirestoreService()
    private let sessionService = SessionService()
    private(set) var user: User? = nil
}

extension UserService {
    
    func autoLogin(completion: @escaping(User?)->()) {
        guard let credential = sessionService.readCredential() else {
            return completion(nil)
        }
        login(credential: credential) { user in
            completion(user)
        }
    }
    
    func login(credential: Credential, completion: @escaping(User?)->()) {
        Auth.auth().signIn(withEmail: credential.email,
                           password: credential.password) { (result, error) in
            guard error == nil, let result = result else {
                return completion(nil)
            }
            self.firestoreService.fetchUser(by: result.user.uid) { user in
                self.user = user
                self.sessionService.save(credential: credential)
                completion(user)
            }
        }
    }
    
    func singup(credential: Credential, completion: @escaping(User?)->()) {
        Auth.auth().createUser(withEmail: credential.email,
                               password: credential.password) { (result, error) in
            guard error == nil,
                  let result = result else {
                return completion(nil)
            }
            self.firestoreService.createUser(id: result.user.uid, email: credential.email)
            self.user = User(id: result.user.uid,
                             email: credential.email,
                             cities: [])
            self.sessionService.save(credential: credential)
            completion(self.user)
        }
    }
    
    func logout(completion: @escaping(Bool)->()) {
        do {
            try Auth.auth().signOut()
            user = nil
            self.sessionService.clearCredential()
            completion(true)
        } catch { completion(false) }
    }
}


extension UserService {
    func addCity(_ city: String) {
        guard let user = user else { return }
        guard !user.cities.map({ $0 }).contains(city) else { return }
        user.addCity(city)
        firestoreService.updateCities(id: user.id, cities: user.cities)
    }
    
    func removeCity(_ city: String) {
        guard let user = user else { return }
        guard user.cities.map({ $0 }).contains(city) else { return }
        user.removeCity(city)
        firestoreService.updateCities(id: user.id, cities: user.cities)
    }
}
