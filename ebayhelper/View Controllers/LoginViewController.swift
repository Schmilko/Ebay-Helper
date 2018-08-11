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
    
    @IBOutlet weak var loginButton: UIButton!
    
    var keyboard: CGRect?
    // the first time it's deleted, it doesnt delete. the second time it deletes but theres nothimg in the row
    @IBAction func loginTapped(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (result, error) in
            if error == nil && (Auth.auth().currentUser?.isEmailVerified)! == true {
                guard let user = result?.user else {
                    return
                }
                
                UserService.create(user, username: "true", completion: { (user) in
                    if let user = user {
                        User.setCurrent(user, writeToUserDefaults: true)

                        if let presentingVc = self.navigationController?.presentingViewController {
                            presentingVc.dismiss(animated: true)
                        } else {
                            self.performSegue(withIdentifier: "showHome", sender: self)
                        }
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
    override func viewDidLayoutSubviews() {
        email.setBottomBorder()
        password.setBottomBorder()
    }
//    fileprivate func isLoggedIn() -> Bool {
//        return UserDefaults.standard.bool(forKey: "isLoggedIn")
//    }
    override func viewWillAppear(_ animated: Bool) {
        email.becomeFirstResponder()
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
    }
    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if var keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            let keyboardHeight = keyboardSize.height
//            print(keyboardHeight)
//
//            keyboardSize = keyboard!
//
//
//        }
//    }
//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.password?.delegate = self
        self.email?.delegate = self
        
        hideKeyboardWhenTappedAround()
        dismissKeyboard()
        
    
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == email { // Switch focus to other text field
            email.resignFirstResponder()
            password.becomeFirstResponder()
        } else if textField == password {
            loginTapped(loginButton)
        }
        return true
    }


}
//extension UITextField {
//    func setBottomBorder() {
//        self.borderStyle = .line
//        self.layer.masksToBounds = false
//        self.layer.shadowColor = newSwiftColor.cgColor
//        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
//        self.layer.shadowOpacity = 1.0
//        self.layer.shadowRadius = 0.0
//    }
//}
//
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255

        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}

extension UITextField
{
    func setBottomBorder()
    {
        self.borderStyle = UITextBorderStyle.none
        self.backgroundColor = UIColor.clear
        let width: CGFloat = 1.0
        let newSwiftColor = UIColor(red: 7, green: 160, blue: 195)
        let borderLine = UIView(frame: CGRect(x: 0, y: self.frame.height - width, width: self.frame.width, height: width))
        borderLine.backgroundColor = newSwiftColor
        self.addSubview(borderLine)
    }
}
