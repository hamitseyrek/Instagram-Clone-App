//
//  ViewController.swift
//  Instagram Clone App
//
//  Created by Hamit Seyrek on 19.02.2022.
//

import UIKit
import Parse

class SigninVC: UIViewController {
    
    var signUpModeActive = true
    @IBOutlet weak var signUpOrLogInButton: UIButton!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var switchLoginMode: UIButton!
    @IBOutlet weak var userNameText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signUpOrLogInClick(_ sender: Any) {
        if userNameText.text != "" && passwordText.text != "" {
            if signUpModeActive {
                let user = PFUser()
                user.username = userNameText.text
                user.password = passwordText.text
                
                user.signUpInBackground { success, error in
                    if error != nil {
                        self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                    }
                }
            } else {
                PFUser.logInWithUsername(inBackground: userNameText.text!, password: passwordText.text!) { responseUser, error in
                    if error == nil {
                        self.performSegue(withIdentifier: "toTabBarVCS", sender: nil)
                    } else {
                        self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                    }
                }
            }
        } else {
            makeAlert(title: "Error!!!", message: "Username / Password can't be null")
        }
    }
    @IBAction func switchLoginMode(_ sender: Any) {
        if signUpModeActive {
            signUpModeActive = false
            signUpOrLogInButton.setTitle("Log In", for: [])
            switchLoginMode.setTitle("Sign Up", for: [])
        } else {
            signUpModeActive = true
            switchLoginMode.setTitle("Log In", for: [])
            signUpOrLogInButton.setTitle("Sign Up", for: [])
        }
    }
    
    func makeAlert(title:String,message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let button = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(button)
        self.present(alert, animated: true, completion: nil)
    }
}

