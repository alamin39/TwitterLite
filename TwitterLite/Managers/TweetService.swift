//
//  TweetService.swift
//  TwitterLite
//
//  Created by Al-Amin on 2022/12/15.
//

import Firebase
import UIKit

struct TweetService {
    
    static let shared = TweetService()
    
    func uploadTweet(caption: String?, image: UIImage?, completion: @escaping(Error?, DatabaseReference) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let imageData = image?.jpegData(compressionQuality: 0.3) ?? Data()
        let fileName = NSUUID().uuidString
        let storageRef = REF_STORAGE.child("tweetImages").child(fileName)
        
        storageRef.putData(imageData, metadata: nil) { (meta, error) in
            storageRef.downloadURL { (url, error) in
                let imageUrl = url?.absoluteString
                
                let values = ["uid": uid,
                              "caption": caption as Any,
                              "imageUrl": imageUrl as Any] as [String : Any]
                
                REF_TWEETS.child(uid).childByAutoId().updateChildValues(values, withCompletionBlock: completion)
            }
        }
    }
    
    func fetchTweets(completion: @escaping([TweetInfo]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var tweets = [TweetInfo]()
        
        REF_TWEETS.child(uid).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let tweetID = snapshot.key
            let tweet = TweetInfo(id: tweetID, captionText: dictionary["caption"] as? String, tweetImageUrl: dictionary["imageUrl"] as? String)
            tweets.append(tweet)
            completion(tweets)
        }
        
        REF_TWEETS.child(uid).observe(.childRemoved, with: { snapshot in
            if let index = tweets.firstIndex(where: {$0.id == snapshot.key}) {
                tweets.remove(at: index)
                completion(tweets)
            }
        })
    }
    
    func deleteTweet(tweetID: String?, url: String?) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let tweetID = tweetID, let url = url else { return }
        
        REF_TWEETS.child(uid).child(tweetID).removeValue()
        let storageRef = Storage.storage().reference(forURL: url)
        storageRef.delete()
    }
}
