//
//  AuthManager.swift
//  TwitterLite
//
//  Created by Al-Amin on 7/12/22.
//

import Firebase
import UIKit

struct AuthCredentials {
    let email: String
    let password: String
    let username: String
    let fullname: String
    let profileImage: UIImage
}

struct AuthManager {
    
    static let shared = AuthManager()
    
    func registerUser(with Credentials: AuthCredentials, completion: @escaping(Error?, DatabaseReference) -> Void) {
        let email = Credentials.email
        let password = Credentials.password
        let username = Credentials.username
        let fullname = Credentials.fullname
        
        guard let imageData = Credentials.profileImage.jpegData(compressionQuality: 0.3) else { return }
        let fileName = NSUUID().uuidString
        let storageRef = REF_STORAGE_PROFILE_IMAGES.child(fileName)
        
        storageRef.putData(imageData, metadata: nil) { (meta, errorMsg) in
            storageRef.downloadURL { (url, errorMsg) in
                guard let profileImageUrl = url?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: email, password: password) { (result, errorMsg) in
                    if let errorMsg = errorMsg {
                        print("DEBUG:: \(errorMsg.localizedDescription)")
                        completion(errorMsg, DatabaseReference())
                        return
                    }
                    
                    guard let uid = Auth.auth().currentUser?.uid else { return }
                    let values = ["email": email,
                                  "username": username,
                                  "fullname": fullname,
                                  "profileImageUrl": profileImageUrl]
                    REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
                }
            }
        }
    }
    
    func loginUserWith(email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
}
