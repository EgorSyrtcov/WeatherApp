//
//  FirestoreService.swift
//  WeatherApp
//
//  Created by Egor Syrtcov on 2/25/21.
//

import Foundation
import FirebaseFirestore

final class FirestoreService {
    
    private let db = Firestore.firestore()
    
    private enum Collection: String {
        case users
    }
    
    func createUser(id: String, email: String) {
        db.collection(Collection.users.rawValue)
            .document(id)
            .setData(["id": id,
                      "email": email,
                      "cities": []
            ], merge: true)
    }
    
    func fetchUser(by id: String, completion: @escaping(User?)->()) {
        let docRef = db.collection(Collection.users.rawValue).document(id)
        docRef.getDocument { (document, error) in
            guard let document = document, document.exists,
                  let data = document.data(),
                  let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []) else { return completion(nil) }
            let user = try? JSONDecoder().decode(User.self, from: jsonData)
            completion(user)
        }
    }
    
    func updateCities(id: String, cities: [String]) {
        db.collection(Collection.users.rawValue)
            .document(id)
            .setData(["id": id,
                      "cities": cities
            ], merge: true)
    }
}
