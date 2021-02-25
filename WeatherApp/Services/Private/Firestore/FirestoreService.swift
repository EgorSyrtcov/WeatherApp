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
    
    func createUser(id: String, email: String?) {
        db.collection("users")
            .document(id)
            .setData(["id": id,
                      "email": email ?? "unknown_email",
                      "cities": []
            ], merge: true)
    }
    
    func fetchUser(by id: String, completion: @escaping(User?)->()) {
        let docRef = db.collection("users").document(id)
        docRef.getDocument { (document, error) in
            guard let document = document, document.exists,
                  let data = document.data(),
                  let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []) else { return completion(nil) }
            let user = try? JSONDecoder().decode(User.self, from: jsonData)
            completion(user)
        }
    }
    
}
