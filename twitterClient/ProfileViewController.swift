//
//  ProfileViewController.swift
//  twitterClient
//
//  Created by Tushar Humbe on 11/6/16.
//  Copyright © 2016 Tushar Humbe. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var user: User?
    var tweetsArray: [Tweet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        getUserTweets()
        populateHeader()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateHeader() {
        if user!.profileBackgroundImageURL != nil {
            backgroundImage.setImageWith(user!.profileBackgroundImageURL!)
        }
        profileImage.setImageWith(user!.profileURL!)

        
        usernameLabel.text = "\(user!.name!)"
        twitterHandleLabel.text = "@\(user!.screenName!)"
        tweetsCount.text = "\(user!.tweetCount!)"
        followingCount.text = "\(user!.following!)"
        followersCount.text = "\(user!.followers!)"
    }
    
    func getUserTweets() {
        TwitterClient.sInstance.getUserTimeline(user: user, success: { (tweets: [Tweet]?) in
            
            self.tweetsArray = tweets!;
            self.tableView.reloadData()
            
        }) { (error: Error?) in
            print(error?.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileTableViewCell.identifier", for: indexPath) as! ProfileTableViewCell
        
        cell.tweet = tweetsArray[indexPath.row]
        //cell.delegate = self;
        
        return cell;
    }
    
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var tweetsCount: UILabel!
    @IBOutlet weak var twitterHandleLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
