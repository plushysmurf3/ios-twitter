//
//  MenuViewController.swift
//  ios-twitter
//
//  Created by Savio Tsui on 11/6/16.
//  Copyright © 2016 Savio Tsui. All rights reserved.
//

import UIKit
import SwiftIconFont

class MenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var hamburgerViewController: HamburgerMenuViewController!
    
    var menuTitles: [String] = [String.fontAwesomeIcon("user")! + " Profile",
                                String.fontAwesomeIcon("home")! + " Timeline",
                                String.fontAwesomeIcon("comment")! + " Mentions",
                                String.fontAwesomeIcon("sign-out")! + " Log out"]
    var menuViewControllers: [UIViewController?] = []
    
    fileprivate var profileNavigationController: UIViewController!
    fileprivate var tweetsNavigationController: UIViewController!
    fileprivate var mentionTweetsNavigationController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        profileNavigationController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController")
        tweetsNavigationController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        mentionTweetsNavigationController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        ((mentionTweetsNavigationController as! UINavigationController).topViewController as! TweetsViewController).viewTweets = ViewTweets(shouldRefresh: true, timelineTitle: "Mentions")
        
        menuViewControllers.append(profileNavigationController)
        menuViewControllers.append(tweetsNavigationController)
        menuViewControllers.append(mentionTweetsNavigationController)
        menuViewControllers.append(nil)
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

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuViewControllers.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let activeViewController = self.menuViewControllers[indexPath.row]

        if (activeViewController == nil) {
            TwitterClient.instance.logout()
            return
        }
        else if (activeViewController is UINavigationController) {
            if (activeViewController as! UINavigationController).topViewController is ProfileViewController {
                let profileViewController = ((activeViewController as! UINavigationController).topViewController as! ProfileViewController)
                profileViewController.user = User.currentUser
                profileViewController.isUserFromHamburger = true
            }
        }
        
        hamburgerViewController.contentViewController = self.menuViewControllers[indexPath.row]
        
        UIView.animate(withDuration: 0.3, animations: {
            self.hamburgerViewController.leftMarginConstraint.constant = 0
            self.hamburgerViewController.view.layoutIfNeeded()
        })
    }
}

extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.ios-twitter.MenuCell", for: indexPath) as! MenuCell
        
        cell.menuLabel.font = UIFont.icon(from: .FontAwesome, ofSize: 18)
        cell.menuLabel.text = menuTitles[indexPath.row]
        return cell
    }
}
