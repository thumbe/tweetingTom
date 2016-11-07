//
//  TwitterClient.swift
//  twitterClient
//
//  Created by Tushar Humbe on 10/30/16.
//  Copyright © 2016 Tushar Humbe. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error?)->())?
    
    static let sInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "xbLYbhwaCwETHeOHMz8fXSWst", consumerSecret: "7z7L4PMe6gDq7AIWUCtT5K1B3ExPoPtucLabnB9A0Axb4dbyAn")!
    
    func login(success: @escaping () -> (), failure: @escaping (Error?)->()) {
        loginSuccess = success
        loginFailure = failure
        requestSerializer.removeAccessToken()
        
        // fetch request token & redirect to authorization page
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterDemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            
            let token = requestToken!.token!;
            //print("got token: \(requestToken.token)")
            
            let oauthUrl  = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)")!
            
            UIApplication.shared.openURL(oauthUrl)
            
        }) { (error: Error?) -> Void in
            (self.loginFailure?(error))!
        }
    }
    
    func handleOpenUrl(url: URL) {
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "https://api.twitter.com/oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            
            print("got access token")
            TwitterClient.sInstance.requestSerializer.saveAccessToken(accessToken)
            self.getUserAccount()
            
            }, failure: { (error: Error?) in
                print(error?.localizedDescription)
                (self.loginFailure?(error))!
        })

    }
    
    func getUserAccount(){
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            print(response)
            let user = User(dictionary: response as! NSDictionary)
            User.currentUser = user
            
            self.loginSuccess?()
            
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                print(error.localizedDescription)
                (self.loginFailure?(error))!
        })
    }
    
    func getTweets(success: @escaping (_ tweets: [Tweet]?) -> (), failure: @escaping (Error?) -> ()) {
        
        get("/1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
                let tweets = Tweet.tweetsWithArray(array: response as! [NSDictionary])
                
                success(tweets)
            }, failure: { (task: URLSessionDataTask?, error) -> Void in
                failure(error)
        })
    }
    
    func getMentions(success: @escaping (_ tweets: [Tweet]?) -> (), failure: @escaping (Error?) -> ()) {
        
        get("/1.1/statuses/mentions_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let tweets = Tweet.tweetsWithArray(array: response as! [NSDictionary])
            
            success(tweets)
            }, failure: { (task: URLSessionDataTask?, error) -> Void in
                failure(error)
        })
    }
    
    func getUserTimeline(user: User?, success: @escaping (_ tweets: [Tweet]?) -> (), failure: @escaping (Error?) -> ()) {
        let params = ["user_id": user!.id!] as NSDictionary
        
        
        get("/1.1/statuses/user_timeline.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let tweets = Tweet.tweetsWithArray(array: response as! [NSDictionary])
            
            success(tweets)
            }, failure: { (task: URLSessionDataTask?, error) -> Void in
                failure(error)
        })
    }
    
    func createTweet(params: NSDictionary, success: @escaping (_ tweet: Tweet?) -> (), failure: @escaping (Error?) ->()) {
        post("1.1/statuses/update.json",
             parameters: params,
             progress: nil,
             success: { (task: URLSessionDataTask, response: Any?) -> Void in
                let tweet = Tweet(dictionary: response as! NSDictionary)
                success(tweet)
            },
             failure: { (operation: URLSessionDataTask?, error: Error!) -> Void in
                failure(error)
        })
    }
    
    func handleRetweet(retweet: Bool, id: Int, success: @escaping (_ tweet: Tweet?) -> (), failure: @escaping (Error?) ->()) {
        var url: String;
        if (retweet) {
            url = "1.1/statuses/retweet/\(id).json"
        } else {
            url = "1.1/statuses/unretweet/\(id).json"
        }
        post(url,
             parameters: nil,
             progress: nil,
             success: { (task: URLSessionDataTask, response: Any?) -> Void in
                let tweet = Tweet(dictionary: response as! NSDictionary)
                success(tweet)
            },
             failure: { (operation: URLSessionDataTask?, error: Error!) -> Void in
                failure(error)
        })
    }
    
    func handleLike(like: Bool, id: Int, success: @escaping (_ tweet: Tweet?) -> (), failure: @escaping (Error?) ->()) {
        var url: String;
        if (like) {
            url = "1.1/favorites/create.json"
        } else {
            url = "1.1/favorites/destroy.json"
        }
        post(url,
             parameters: NSDictionary(dictionary: ["id" : id]),
             progress: nil,
             success: { (task: URLSessionDataTask, response: Any?) -> Void in
                let tweet = Tweet(dictionary: response as! NSDictionary)
                success(tweet)
            },
             failure: { (operation: URLSessionDataTask?, error: Error!) -> Void in
                failure(error)
        })
    }

}
