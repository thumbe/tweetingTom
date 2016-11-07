//
//  MenuViewController.swift
//  twitterClient
//
//  Created by Tushar Humbe on 11/6/16.
//  Copyright © 2016 Tushar Humbe. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let menuOptions = ["Profile", "Home Timeline", "Mentions"]
    var hamburgerViewController: HamburgerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self;
        tableView.dataSource = self;
        
        let tweetsNavController = storyboard?.instantiateViewController(withIdentifier:"tweetsNavigationController.identifier") as! UINavigationController
        
        
        hamburgerViewController.contentViewController = tweetsNavController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuTableViewCell.identifier")
        cell?.textLabel?.text = menuOptions[indexPath.row]
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.row == 0) {
            // profile image
            let profileViewController = storyboard?.instantiateViewController(withIdentifier: "profileViewController.identifier") as! ProfileViewController
            profileViewController.user = User.currentUser;
            let profileNavController = UINavigationController(rootViewController: profileViewController)
            hamburgerViewController.contentViewController = profileNavController
        } else if (indexPath.row == 1) {
            let tweetsViewController = storyboard?.instantiateViewController(withIdentifier:"tweetsViewController.identifier") as! TweetsViewController
            tweetsViewController.isMentions = false;
            let tweetsNavController = UINavigationController(rootViewController: tweetsViewController)
            hamburgerViewController.contentViewController = tweetsNavController
        } else if (indexPath.row == 2) {
            let tweetsViewController = storyboard?.instantiateViewController(withIdentifier:"tweetsViewController.identifier") as! TweetsViewController
            tweetsViewController.isMentions = true;
            let tweetsNavController = UINavigationController(rootViewController: tweetsViewController)
            hamburgerViewController.contentViewController = tweetsNavController
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
