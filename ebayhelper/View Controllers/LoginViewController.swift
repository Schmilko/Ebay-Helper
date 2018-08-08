//
//  LoginViewController.swift
//  ebayhelper
//
//  Created by Arun Rau on 8/2/18.
//  Copyright © 2018 Arun Rau. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBAction func loginTapped(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (result, error) in
            if error == nil && (Auth.auth().currentUser?.isEmailVerified)! == true {
                guard let user = result?.user else {
                    return
                }
                
                UserService.create(user, username: "true", completion: { (user) in
                    if let user = user {
                        User.setCurrent(user, writeToUserDefaults: true)

                        let defaults = UserDefaults.standard
                        defaults.set(true, forKey: Constants.UserDefaults.currentUser)
                        print("user's login saved")
                        defaults.synchronize()
                        self.performSegue(withIdentifier: "loginToHome", sender: self)
                    } else {
                        
                    }
                })
        
            }
            else if Auth.auth().currentUser?.isEmailVerified == false {
                 let alertController = UIAlertController(title: "Error", message: "Your e-mail is not verified.", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
            else{
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                print(error?.localizedDescription)
            }
        }
        
    }
    
//    fileprivate func isLoggedIn() -> Bool {
//        return UserDefaults.standard.bool(forKey: "isLoggedIn")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.password?.delegate = self
        self.email?.delegate = self
        hideKeyboardWhenTappedAround()
        dismissKeyboard()
        
        email.text = "k@grr.la"
        password.text = "poop123"
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
