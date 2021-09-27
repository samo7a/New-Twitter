//
//  TweetViewController.swift
//  Twitter
//
//  Created by Ahmed  Elshetany  on 9/27/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    @IBOutlet weak var tweetText: UITextView!
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func tweet(_ sender: Any) {
        if !tweetText.text.isEmpty {
            TwitterAPICaller.client?.postTeeet(tweetString: tweetText.text, success: {(_) in
                self.dismiss(animated: true, completion: nil)
            }, failure: {(error) in
                print("error posting tweets: \(error)")
                self.showToast(message: "Error Posting Tweet", font: .systemFont(ofSize: 12.0))
                self.dismiss(animated: true, completion: nil)
            })
        } else {
            self.showToast(message: "Empty Text", font: .systemFont(ofSize: 12.0))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
