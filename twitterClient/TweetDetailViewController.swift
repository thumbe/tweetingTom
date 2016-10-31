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
    
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
