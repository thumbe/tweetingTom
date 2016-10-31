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
    TweetsTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    
    var tweetsArray = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        
        getTweets()
        
        self.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(TweetsViewController.getTweets), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl!, at: 0)
        
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
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let vc = segue.destination as! TweetDetailViewController
//        let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
//        
//        vc.tweet = tweetsArray[(indexPath?.row)!]
//        tableView.deselectRow(at: indexPath!, animated: true)
//    }
    
    func reply(tweet: Tweet?, cell: TweetsTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        print("Reply to \(tweetsArray[(indexPath?.row)!].text)")
     
        let vc = storyboard?.instantiateViewController(withIdentifier: "composeViewController.identifier") as! ComposeViewController!
        
        navigationController?.pushViewController(vc!, animated: true)
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
