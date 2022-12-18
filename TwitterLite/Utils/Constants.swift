//
//  Constants.swift
//  TwitterLite
//
//  Created by Al-Amin on 16/12/22.
//

import Firebase


let REF_STORAGE = Storage.storage().reference()
let REF_STORAGE_PROFILE_IMAGES = REF_STORAGE.child("profile_image")

let REF_DB = Database.database().reference()
let REF_USERS = REF_DB.child("users")
let REF_TWEETS = REF_DB.child("tweets")
