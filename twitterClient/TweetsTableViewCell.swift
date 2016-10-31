//
//  TweetsTableViewCell.swift
//  twitterClient
//
//  Created by Tushar Humbe on 10/30/16.
//  Copyright © 2016 Tushar Humbe. All rights reserved.
//

import UIKit

@objc protocol TweetsTableViewCellDelegate {
    @objc optional func reply(tweet: Tweet?, cell: TweetsTableViewCell)
}

class TweetsTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var twitterHandleLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var replyIcon: UIImageView!
    @IBOutlet weak var retweetIcon: UIImageView!
    @IBOutlet weak var likeIcon: UIImageView!
    
    weak var delegate: TweetsTableViewCellDelegate?
    
    
    var tweet: Tweet! {
        didSet {
            profileImageView.setImageWith((tweet.user?.profileURL)!)
            usernameLabel.text = tweet.user!.name
            twitterHandleLabel.text = "@\(tweet.user!.screenName!)"
            tweetLabel.text = tweet.text!
            
            if tweet.favorited{
                likeIcon.image = UIImage(named: "likeRed")
            } else {
                likeIcon.image = UIImage(named: "likeGrey")
            }
            if tweet.retweeted{
                retweetIcon.image = UIImage(named: "retweetGreen")
            }else{
                retweetIcon.image = UIImage(named: "retweetGrey")
            }
            
            let replyGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TweetsTableViewCell.replyTapped(sender:)))
            replyIcon.isUserInteractionEnabled = true
            replyIcon.addGestureRecognizer(replyGestureRecognizer)
        }
    }
    
    func replyTapped(sender: Any?){
        delegate?.reply!(tweet: tweet, cell: self)
        
//            let vc = storyboard?.instantiateViewControllerWithIdentifier("TweetComposeViewController") as! TweetComposeViewController!
//            navigationController?.pushViewController(vc, animated: true)
//            vc.tweetReplyId = tweet.id
//            vc.tweetReplyUsername = tweet.user!.screenName
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
