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
//    var tableView: UITableView {get set}
    func performNetworking(order: Order, completion: @escaping (Order?)->Void)
    func tabernaViewController(_ viewController: TabernaViewController, didFinishCreatingNew order: Order)
}

class TabernaViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var trackingTextField: UITextField!
    
    @IBOutlet weak var itemTextField: UITextField!
    
    @IBOutlet weak var notesTextField: UITextField!
    
    var newOrder: Order?
    var delegate: TabernaDelegate?
//    var orders = [Order]()
    var status: String = ""

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let maxLength = 15
//        let currentString: NSString = itemTextField.text! as NSString
//        let newString: NSString =
//            currentString.replacingCharacters(in: range, with: string) as NSString
//        return newString.length <= maxLength
//    }
//
////        func textField(_ textField: UITextField) {
////        if textField.text!.count < 10 {
////
////                let alertController = UIAlertController(title: "Error", message: "Input too short.", preferredStyle: .alert)
////                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
////
////                alertController.addAction(defaultAction)
////                self.present(alertController, animated: true, completion: nil)
////        }
////
////    }
//
//    func newTextField(_ notesTextField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let maxLength = 15
//        let currentString: NSString = itemTextField.text! as NSString
//        let newString: NSString =
//            currentString.replacingCharacters(in: range, with: string) as NSString
//        return newString.length <= maxLength
//    }
    
    // when tableivew loads, networking is called for every order. when the person adds a new order, it writes to firebase & appends to orders array. should i have split this up even further and made the first an order
    
    //second issue: nil when creating first order and crashes
    
    @IBAction func closePopup(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        guard let note = notesTextField.text,
            let trackNumber = trackingTextField.text,
            let itemName = itemTextField.text 
            else {return}
        
        let order = Order(note: note, trackNumber: trackNumber, itemName: itemName, status: status)
        
        OrderService.create(order, completion: { (newOrder) in
            if let newOrder = newOrder {
                Networking.updateUPSStatus(for: newOrder, completion: { (updatedOrder) in
                    if let updatedOrder = updatedOrder {
                        self.delegate?.tabernaViewController(self, didFinishCreatingNew: updatedOrder)
                    } else {
                        self.promptUserOfFailedOrderAdded()
                    }
                })

            } else {
                self.promptUserOfFailedOrderAdded()
            }
//            self.delegate?.tableView.reloadData()
        })
        
        

    }

    func promptUserOfFailedOrderAdded() {
        //TODO: UIALertController
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
//        trackingTextField.text = "1Z09217F0301556366"
        
        self.hideKeyboardWhenTappedAround()
        
        //MARK: REMOVE LATER
        
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



