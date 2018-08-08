//
//  Order.swift
//  ebayhelper
//
//  Created by Arun Rau on 7/29/18.
//  Copyright © 2018 Arun Rau. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Order {
    var note: String 
    var trackNumber: String
    var itemName: String
    var status: String
   
    //TODO:
    //1. get the snapshot key (done)
    //2. create the firebase database tree (done)
    //3. CR: create user, read user
    
    init(note: String, trackNumber: String, itemName: String, status: String) {
        self.note = note
        self.trackNumber = trackNumber
        self.itemName = itemName
        self.status = status
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        let snapshotKey = snapshot.key
        
        note = snapshotValue["note"] as! String
        trackNumber = snapshotValue["trackNumber"] as! String
        itemName = snapshotValue["itemName"] as! String
        status = snapshotValue["status"] as! String
        
    }

    // function for saving data
    func toAnyObject() -> Any {
        return [
            "note": note,
            "trackNumber": trackNumber,
            "itemName": itemName,
            "status": status
        ]
    }
    


}
