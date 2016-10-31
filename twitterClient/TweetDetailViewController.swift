//
//  TweetDetailViewController.swift
//  twitterClient
//
//  Created by Tushar Humbe on 10/30/16.
//  Copyright © 2016 Tushar Humbe. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var twitterHandleLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    
    @IBOutlet weak var retweetIcon: UIImageView!
    @IBOutlet weak var likeIcon: UIImageView!
    @IBOutlet weak var replyIcon: UIImageView!
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.barTintColor = UIColor.blue;

        profileImage.setImageWith((self.tweet!.user?.profileURL)!)
        usernameLabel.text = tweet!.user!.name
        twitterHandleLabel.text = "@\(tweet!.user!.screenName!)"
        tweetLabel.text = tweet?.text!
        createdAtLabel.text = tweet!.createdAtString;
        retweetCountLabel.text = "\(tweet!.retweetCount)"
        favoriteCount.text = "\(tweet!.favCount)"
        
        
        if (tweet!.favorited){
            likeIcon.image = UIImage(named: "likeRed")
        } else {
            likeIcon.image = UIImage(named: "likeGrey")
        }
        if (tweet!.retweeted){
            retweetIcon.image = UIImage(named: "retweetGreen")
        }else{
            retweetIcon.image = UIImage(named: "retweetGrey")
        }
        
        let replyGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TweetDetailViewController.replyTapped(sender:)))
        replyIcon.isUserInteractionEnabled = true
        replyIcon.addGestureRecognizer(replyGestureRecognizer)
        
        let likeGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TweetDetailViewController.likeTapped(sender:)))
        likeIcon.isUserInteractionEnabled = true
        likeIcon.addGestureRecognizer(likeGestureRecognizer)
        
        let retweetGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TweetDetailViewController.retweetTapped(sender:)))
        retweetIcon.isUserInteractionEnabled = true
        retweetIcon.addGestureRecognizer(retweetGestureRecognizer)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func replyTapped(sender: Any?) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "composeViewController.identifier") as! ComposeViewController!
        vc?.replyTo = tweet?.user?.screenName
        vc?.replyToId = tweet?.id
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func likeTapped(sender: Any?) {
        TwitterClient.sInstance.handleLike(like: !(tweet?.favorited)!, id: (tweet?.id!)!, success: { (tweet: Tweet?) in
            if (self.tweet?.favorited)! {
                self.likeIcon.image = UIImage(named: "likeGrey")
            } else {
                self.likeIcon.image = UIImage(named: "likeRed")
            }
            self.favoriteCount.text = "\(tweet!.favCount)"
            
        }) { (error: Error?) in
            print(error?.localizedDescription)
        }
    }
    
    func retweetTapped(sender: Any?) {
        TwitterClient.sInstance.handleRetweet(retweet: !(tweet?.retweeted)!, id: (tweet?.id!)!, success: { (tweet: Tweet?) in
            if (self.tweet?.retweeted)! {
                self.retweetIcon.image = UIImage(named: "retweetGrey")
            } else {
                self.retweetIcon.image = UIImage(named: "retweetGreen")
            }
            self.retweetCountLabel.text = "\(tweet!.retweetCount)"
            
        }) { (error: Error?) in
                print(error?.localizedDescription)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
