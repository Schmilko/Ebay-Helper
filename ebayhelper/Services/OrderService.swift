//
//  OrderService.swift
//  ebayhelper
//
//  Created by Arun Rau on 8/5/18.
//  Copyright © 2018 Arun Rau. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDatabase
import FirebaseAuth.FIRUser
import FirebaseDatabase

class OrderService {
    
    static var ref: DatabaseReference?

    //MARK: READ
    static func show(completion: @escaping ([Order]) -> Void) {
        let ref = Database.database().reference().child("users").child(User.current.uid).child("orders")
        self.ref = ref
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let arrayOfOrders = snapshot.children.allObjects as? [DataSnapshot] else {
                fatalError("snapshot was not an array of orders from firebase, check the ref")
            }
            var orders = [Order]()
            for aOrderSnapshot in arrayOfOrders {
                let orderFromSnapshot = Order(snapshot: aOrderSnapshot)
                orders.append(orderFromSnapshot)
            }
            
            completion(orders.reversed())
        })
    }
    // update and relod for ups call show, thecall ocmpletion when have orders, second function, networking
    
    //pull the firebase user's orders, which decodes the order object, then performs networking for each order in viewdidload, then sends them back to firebase. but I already send them back to firebase so all i need to do right now. is  call the show, with a completion that ends when the orders are all appended and it is a dictionary. is it a dictionary of my object?  i dont know.I EGJRWHIFEJODKFL;WDALFSJDKSDAL;PSFSJLKDALSFSJLKNADLFSNKFSGFEGFEGFJEGKLNFEJG
    
    //MARK: CREATE
    static func create(_ order: Order, completion: @escaping (Order?) -> Void) {
        let ref = Database.database().reference().child("users").child(User.current.uid).child("orders").childByAutoId()
        ref.setValue(order.toAnyObject()) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let order = Order(snapshot: snapshot)
                completion(order)
            })
        }
        print("saved to Firebase")
    }
    
    //MARK: DELETE
//    static func sdelete(_ order: Order, completion: @escaping (Order?) -> Void) {
//        print("deleted from firebase")
//        let ref = Database.database().reference().child("users").child(User.current.uid).child("orders").childByAutoId()
//        ref.removeValue()
//    }
//
    static func delete(ref: DatabaseReference) {
        self.ref?.removeValue()
        print("deleted from firebase")
        
        
    }
    
}

