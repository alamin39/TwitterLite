//
//  UserService.swift
//  TwitterLite
//
//  Created by Al-Amin on 2022/12/16.
//

import Firebase

struct UserService {
    
    static let shared = UserService()
    
    func fetchUser(completion: @escaping(TwitterUser) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let user = TwitterUser(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
}
