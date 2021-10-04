//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by Ahmed  Elshetany  on 9/24/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class TweetCellTableViewCell: UITableViewCell {
    
	var favorited: Bool = false
	var retweeted: Bool = false
	var tweetId: Int = -1
	func setFavorite (_ isFavorited:Bool){
		favorited = isFavorited
		if (favorited){
			favButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
		} else {
			favButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
		}
	}
	
	func setRetweet (_ isRetweeted:Bool){
		retweeted = isRetweeted
		if (retweeted){
			retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
			retweetButton.isEnabled = false
		} else {
			retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
			retweetButton.isEnabled = true
		}
	}
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
	
	@IBOutlet weak var retweetButton: UIButton!
	@IBOutlet weak var favButton: UIButton!
	@IBAction func favTweet(_ sender: Any) {
		let tobeFavorited = !favorited
		if (tobeFavorited) {
			TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
				self.setFavorite(true)
			}, failure: {(error) in
				print("Error: Favoriting tweets: \(error)");
		}
			)
		} else {
			TwitterAPICaller.client?.unFavoriteTweet(tweetId: tweetId, success: {
				self.setFavorite(false)
			}, failure: {(error) in
				print("Error: Un Favoriting tweets: \(error)");
			}
			)
		}
	}
	@IBAction func retweet(_ sender: Any) {
		TwitterAPICaller.client?.retweet(tweetId: tweetId, success: {
			self.setRetweet(true)
		}, failure: {(error) in
			print("Error: retweeting: \(error)")
		})
	}
	
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width/2
        self.profilePic.clipsToBounds = true
    }

}
