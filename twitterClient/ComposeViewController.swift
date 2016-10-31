//
//  ComposeViewController.swift
//  twitterClient
//
//  Created by Tushar Humbe on 10/30/16.
//  Copyright © 2016 Tushar Humbe. All rights reserved.
//

import UIKit

@objc protocol ComposeViewControllerDelegate {
     @objc optional func onNewTweet(tweet: Tweet?, viewController: ComposeViewController)
}

class ComposeViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var twitterHandleLabel: UILabel!
    @IBOutlet weak var textArea: UITextView!
    
    var replyTo : String?
    var replyToId : Int?
    
    weak var delegate: ComposeViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.barTintColor = UIColor.init(colorLiteralRed: <#T##Float#>, green: <#T##Float#>, blue: <#T##Float#>, alpha: <#T##Float#>);
        
        if let currentUser = User.currentUser {
            profileImage.setImageWith(currentUser.profileURL!)
            
            usernameLabel.text = currentUser.name
            twitterHandleLabel.text = currentUser.screenName
        }
        if replyTo != nil {
            textArea.text = "@\(replyTo!)"
        }
        textArea.becomeFirstResponder();
        
        // Do any additional setup after loading the view.
    }

    @IBAction func sendTweetAction(_ sender: AnyObject) {
        let params: NSMutableDictionary = (dictionary: ["status": textArea.text])
        if let replyToId = replyToId {
            params.setValue(replyToId, forKey: "in_reply_to_status_id")
        }
        
        TwitterClient.sInstance.createTweet(params: params
            , success: { (tweet:Tweet?) in
                self.delegate?.onNewTweet?(tweet: tweet!, viewController: self)
                self.navigationController?.popViewController(animated: true)
        
        }) { (error: Error?) in
                print(error?.localizedDescription)
        }
        
        
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
