//
//  User.swift
//  twitterClient
//
//  Created by Tushar Humbe on 10/30/16.
//  Copyright © 2016 Tushar Humbe. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: String?
    var screenName: String?
    var userDescription: String?
    var profileURL: URL?
    var followers: Int?
    var following: Int?
    var tweets: Int?
    var id: Int?
    var tweetCount: String?
    var profileURLString: String?
    var jsonValue: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.jsonValue = dictionary
        id = dictionary["id"] as? Int
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        userDescription = dictionary["description"] as? String
        followers = dictionary["followers_count"] as? Int
        following = dictionary["following"] as? Int
        profileURLString = dictionary["profile_image_url_https"] as? String
        if let profileURLString = profileURLString {
            profileURL = URL(string: profileURLString)
        }
        if let status_count = dictionary["statuses_count"]{
            tweetCount = "\(status_count)"
        }
        
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if (_currentUser == nil) {
                if let userData = UserDefaults.standard.object(forKey: "currentUserKey") as? Data {
                
                    let data = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: data)
                    
                }
            }
            
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {

                let data = try! JSONSerialization.data(withJSONObject: user?.jsonValue, options: []) as NSData
                
                UserDefaults.standard.set(data, forKey: "currentUserKey")
            } else {
                UserDefaults.standard.set(nil, forKey: "currentUserKey")
            }
            UserDefaults.standard.synchronize()
        }
    }

}
