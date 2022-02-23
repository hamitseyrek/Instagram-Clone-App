//
//  FeedVC.swift
//  Instagram Clone App
//
//  Created by Hamit Seyrek on 19.02.2022.
//

import UIKit
import Parse
import OneSignal

class FeedVC: UIViewController, UIWindowSceneDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var window:UIWindow?
    var ownerArray = [String]()
    var uuidArray = [String]()
    var commentArray = [String]()
    var imageArray = [PFFileObject]()
    var playerID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromParse()
        
        if let deviceState = OneSignal.getDeviceState() {
            let userId = deviceState.userId
            
            /*
            print("OneSignal Push Player ID: ", userId ?? "called too early, not set yet")
            let subscribed = deviceState.isSubscribed
            print("Device is subscribed: ", subscribed)
            let hasNotificationPermission = deviceState.hasNotificationPermission
            print("Device has notification permissions enabled: ", hasNotificationPermission)
            let notificationPermissionStatus = deviceState.notificationPermissionStatus
            print("Device's notification permission status: ", notificationPermissionStatus.rawValue)
            let pushToken = deviceState.pushToken
            print("Device Push Token Identifier: ", pushToken ?? "no push token, not subscribed")
            */
        
            if let userId = userId {
                let user = PFUser.current()
                let object = PFObject(className: "playerId")
                object["player_id"] = userId
                object["user_name"] = user?.username
                object.saveInBackground { result, error in
                    if error != nil {
                        print("something went wrong")
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getDataFromParse), name: NSNotification.Name("newPost"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ownerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.userNameLabel.text = ownerArray[indexPath.row]
        cell.commentLabel.text = commentArray[indexPath.row]
        cell.uuidLabel.text = uuidArray[indexPath.row]
        
        imageArray[indexPath.row].getDataInBackground { data, error in
            if error == nil {
                cell.postImage.image = UIImage(data: data!)
            }
        }
        
        return cell
    }
    
    @objc func getDataFromParse() {
        let query = PFQuery(className: "posts")
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackground { objects, error in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Something webt wrong!!", preferredStyle: UIAlertController.Style.alert)
                let button = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(button)
                self.present(alert, animated: true, completion: nil)
            } else {
                if let objects = objects {
                    self.ownerArray.removeAll()
                    self.uuidArray.removeAll()
                    self.commentArray.removeAll()
                    self.imageArray.removeAll()
                    for object in objects {
                        self.ownerArray.append(object.object(forKey: "owner") as! String)
                        self.commentArray.append(object.object(forKey: "comment") as! String)
                        self.uuidArray.append(object.object(forKey: "postId") as! String)
                        self.imageArray.append(object.object(forKey: "image") as! PFFileObject)
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func logOutClick(_ sender: Any) {
        PFUser.logOutInBackground { error in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Something webt wrong!!", preferredStyle: UIAlertController.Style.alert)
                let button = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(button)
                self.present(alert, animated: true, completion: nil)
            } else {
                self.performSegue(withIdentifier: "toSignInVCS", sender: nil)
            }
            
        }
    }
    
}
