//
//  TabernaViewController.swift
//  ebayhelper
//
//  Created by Arun Rau on 7/26/18.
//  Copyright © 2018 Arun Rau. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import SwiftyJSON

protocol TabernaDelegate {
    func performNetworking(order: Order)
}

class TabernaViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var trackingTextField: UITextField!
    
    @IBOutlet weak var itemTextField: UITextField!
    
    @IBOutlet weak var notesTextField: UITextField!
    
    var delegate: TabernaDelegate?
    var orders = [Order]()
    var status: String = ""
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(_ itemTextField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 15
        let currentString: NSString = itemTextField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    func newTextField(_ notesTextField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 15
        let currentString: NSString = itemTextField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    
    @IBAction func closePopup(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        guard let note = notesTextField.text,
            let trackNumber = trackingTextField.text,
            let itemName = itemTextField.text
            else {return}
        
        let order = Order(note: note, trackNumber: trackNumber, itemName: itemName, status: status)
        delegate?.performNetworking(order: order)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case "saveUnwind":
            print("save bar button item tapped")
        default:
            print("unexpected segue identifier")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackingTextField.delegate = self
        itemTextField.delegate = self
        notesTextField.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        
        //MARK: REMOVE LATER
        trackingTextField.text = "1Z09217F0301556366"
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ itemTextField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}



extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}



