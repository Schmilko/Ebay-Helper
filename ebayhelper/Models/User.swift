//
//  User.swift
//  Makestagram
//
//  Created by Arun Rau on 7/11/18.
//  Copyright © 2018 Arun Rau. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDatabase
import FirebaseAuth

class User: Codable {
    let uid: String
//    let orders: [Order]
    

    //1.Create a private static variable to hold our current user. This method is private so it can't be access outside of this class.
    private static var _current: User?
    
    //2.Create a computed variable that only has a getter that can access the private _current variable.
    static var current: User{
        //3.Check that _current that is of type User? isn't nil. If _current is nil, and current is being read, the guard statement will crash with fatalError().
        guard let currentUser = _current else{
            fatalError("Error: current user doesn't exist")
        }
        //4.If _current isn't nil, it will be returned to the user.
        return currentUser
    }
    
    
    //5.Create a custom setter method to set the current user
    static func setCurrent(_ user: User, writeToUserDefaults: Bool = false){
        if writeToUserDefaults {
            // 3
            if let data = try? JSONEncoder().encode(user) {
                UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
                print("AQSWDEFGH45678O")
            }
        }
        _current = user
    }
    
    static func logoutUser() {
        try! Auth.auth().signOut()
        UserDefaults.standard.set(nil, forKey: Constants.UserDefaults.currentUser)
    }
    
//    static func unsetCurrent(_ user: User, writeToUserDefaults: Bool = false){
//        if writeToUserDefaults {
//            if let data = try? JSONEncoder().encode(user) {
//            UserDefaults.standard.set(true, forKey: "isLoggedIn")
//
//            }
//        }
//    }
    
    init(uid:String) {
        self.uid = uid
        
//        self.orders = orders
    }
    // if a user doesn't have a UID or a username, I fail the initialization and return nil.
    init?(snapshot: DataSnapshot){
//        guard let dict = snapshot.value as? [String: AnyObject?],
//            let uid = dict["uid"] as? String,
//            let orders = dict["orders"] 
//            else {return nil}
        
        self.uid = snapshot.key
//        self.orders = snapshot.value as! [Order]
        
    }
}


