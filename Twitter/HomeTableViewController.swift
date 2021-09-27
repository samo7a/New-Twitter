//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Ahmed  Elshetany  on 9/24/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    var TweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    let myRefreshControl = UIRefreshControl()
    
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        numberOfTweets = 20
        myRefreshControl.addTarget(self, action: #selector((loadTweets)), for: .valueChanged)
        self.tableView.refreshControl = myRefreshControl
        // Uncomment the following line to preserve selection between presentations
//         self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//         self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweets()
        print("reloading the tweets agian from viewDidappear")
    }
    
    @objc func loadTweets () {
        let url = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count" : numberOfTweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: url, parameters: myParams as [String : Any],
                                                        
        success: { (tweets: [NSDictionary]) in
            self.TweetArray.removeAll()
            for tweet in tweets {
                self.TweetArray.append(tweet)
            }
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
            
        }, failure: { Error in
            print(Error)
            self.showToast(message: "Error Loading Tweets", font: .systemFont(ofSize: 12.0))
        })
    }
    
    func loadMoreTweets() {
        numberOfTweets += 20
        let url = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numberOfTweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: url, parameters: myParams as [String : Any],
                                                        
        success: { (tweets: [NSDictionary]) in
            self.TweetArray.removeAll()
            for tweet in tweets {
                self.TweetArray.append(tweet)
            }
            self.tableView.reloadData()
            
        }, failure: { Error in
            print(Error)
            self.showToast(message: "Error Loading Tweets", font: .systemFont(ofSize: 12.0))
        })
    
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        let user = TweetArray[indexPath.row]["user"] as! NSDictionary
        cell.tweetContent.text = TweetArray[indexPath.row]["text"] as? String
        cell.userName.text = user["name"] as? String
        
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        if let imageData = data {
            cell.profilePic.image = UIImage(data: imageData)
        }
//        self.tableView.deselectRow(at: indexPath, animated: true)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        if indexPath.row + 1 == TweetArray.count {
            loadMoreTweets()
        }
    }
//     MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return TweetArray.count
    }

   
}

