//
//  TweetsViewController.swift
//  twitterClient
//
//  Created by Tushar Humbe on 10/30/16.
//  Copyright © 2016 Tushar Humbe. All rights reserved.
//

import UIKit
import AFNetworking

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,
    TweetsTableViewCellDelegate, ComposeViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    
    var tweetsArray = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.barTintColor = UIColor.blue;

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        
        getTweets()
        
        self.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(TweetsViewController.getTweets), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl!, at: 0)
        
    }

    @IBAction func newTweetAction(_ sender: AnyObject) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "composeViewController.identifier") as! ComposeViewController!
        vc?.delegate = self;
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func onNewTweet(tweet: Tweet?, viewController: ComposeViewController) {
        if tweet != nil {
            tweetsArray.insert(tweet!, at: 0)
            tableView.reloadData()
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTweets() {
        TwitterClient.sInstance.getTweets(success: { (tweets: [Tweet]?) in
            
            self.tweetsArray = tweets!;
            self.tableView.reloadData()
            
            if let refreshControl = self.refreshControl {
                refreshControl.endRefreshing()
            }
            
        }) { (error: Error?) in
            print(error?.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetTableView.identifier", for: indexPath) as! TweetsTableViewCell
        
        cell.tweet = tweetsArray[indexPath.row]
        cell.delegate = self;
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = self.storyboard!.instantiateViewController(withIdentifier: "tweetDetailViewController.identifier") as! TweetDetailViewController
        detailViewController.tweet = tweetsArray[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    
    func reply(tweet: Tweet?, cell: TweetsTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        print("Reply to \(tweetsArray[(indexPath?.row)!].text)")
     
        let vc = storyboard?.instantiateViewController(withIdentifier: "composeViewController.identifier") as! ComposeViewController!
        vc?.delegate = self
        vc?.replyTo = tweetsArray[(indexPath?.row)!].user?.screenName
        vc?.replyToId = tweetsArray[(indexPath?.row)!].id
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func like(tweet: Tweet?, cell: TweetsTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        let tweet = tweetsArray[(indexPath?.row)!];
        
        TwitterClient.sInstance.handleLike(like: !(tweet.favorited), id: tweet.id!, success: { (tweet: Tweet?) in
            
            self.tweetsArray[(indexPath?.row)!].favorited = tweet!.favorited
            self.tableView.reloadData();
        }) { (error: Error?) in
            print(error?.localizedDescription)
        }
    }
    
    func retweet(tweet: Tweet?, cell: TweetsTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        let tweet = tweetsArray[(indexPath?.row)!];
        
        TwitterClient.sInstance.handleRetweet(retweet: !(tweet.retweeted), id: tweet.id!, success: { (tweet: Tweet?) in
            
            self.tweetsArray[(indexPath?.row)!].retweeted = tweet!.retweeted;
            self.tableView.reloadData()
            
        }) { (error: Error?) in
            print(error?.localizedDescription)
        }
    }


}
