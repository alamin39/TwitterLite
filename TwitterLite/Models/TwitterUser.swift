//
//  TwitterUser.swift
//  TwitterLite
//
//  Created by Al-Amin on 2022/12/16.
//

import Foundation

struct TwitterUser {
    let uid: String
    let email: String
    var fullname: String
    var username: String = ""
    var profileImageUrl: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}
