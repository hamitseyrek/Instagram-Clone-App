//
//  FeedCell.swift
//  Instagram Clone App
//
//  Created by Hamit Seyrek on 21.02.2022.
//

import UIKit
import Parse
import OneSignal

class FeedCell: UITableViewCell {

    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var uuidLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var playerIDArray = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        uuidLabel.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likeClick(_ sender: Any) {
        let object = PFObject(className: "likes")
        object["from"] = PFUser.current()!.username
        object["to"] = uuidLabel.text
        
        object.saveInBackground { result, error in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Something went wrong!!", preferredStyle: UIAlertController.Style.alert)
                let button = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(button)
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            } else {
                let query = PFQuery(className: "playerId")
                query.whereKey("user_name", equalTo: self.userNameLabel.text!)
                query.findObjectsInBackground { objects, error in
                    if error == nil {
                        self.playerIDArray.removeAll(keepingCapacity: false)
                        for object in objects! {
                            self.playerIDArray.append(object.object(forKey: "player_id") as! String)
                            OneSignal.postNotification([
                                "contents" : ["en" : "new like"],
                                "include_player_ids" : ["\(self.playerIDArray.last!)"],
                                "ios_badgeType" : "Increase",
                                "ios_badgeCount" : "1"
                            ])
                        }
                    } else {
                        
                    }
                }
            }
        }
    }
    @IBAction func commentClick(_ sender: Any) {
        let object = PFObject(className: "comments")
        object["from"] = PFUser.current()!.username
        object["to"] = uuidLabel.text
        
        object.saveInBackground { result, error in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Something went wrong!!", preferredStyle: UIAlertController.Style.alert)
                let button = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(button)
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
    }
}
