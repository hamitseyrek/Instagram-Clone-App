//
//  UploadVC.swift
//  Instagram Clone App
//
//  Created by Hamit Seyrek on 19.02.2022.
//

import UIKit
import Parse

class UploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let keyboardRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(keyboardRecognizer)
        
        // Do any additional setup after loading the view.
        postImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        postImage.addGestureRecognizer(gestureRecognizer)
        
        postButton.isEnabled = false
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func selectImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
        
        postButton.isEnabled = true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        postImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postClick(_ sender: Any) {
        postButton.isEnabled = false
        
        guard let user = PFUser.current() else {
            return
        }
        
        guard let data = postImage.image?.jpegData(compressionQuality: 0.6) else { return }
        let pfImage = PFFileObject(name: "image", data: data)
        
        let object = PFObject(className: "posts")
        object["comment"] = commentText.text
        object["owner"] = user.username!
        object["image"] = pfImage
        object["postId"] = UUID().uuidString
        
        object.saveInBackground { result, error in
            if error != nil {
                self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Something went wrong !!!")
            } else {
                self.commentText.text = ""
                self.postImage.image = UIImage(named: "selectImage")
                self.postButton.isEnabled = true
                self.tabBarController?.selectedIndex = 0
            }
        }
        
    }
    
    func makeAlert(title:String,message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let button = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(button)
        self.present(alert, animated: true, completion: nil)
    }
    
    func pauseApp() {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
}
