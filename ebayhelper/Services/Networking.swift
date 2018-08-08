//
//  Networking.swift
//  ebayhelper
//
//  Created by Arun Rau on 7/24/18.
//  Copyright © 2018 Arun Rau. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


class Networking: NSObject, URLSessionDelegate, URLSessionTaskDelegate {

    static func doNetworkRequest(orderInfo: Order, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        // Override point for customization after application launch.
        
        //test the url
        let url = URL(string: "https://wwwcie.ups.com/rest/Track")!
        var request = URLRequest(url: url)
        
        
        let itemName = orderInfo.itemName
        let note = orderInfo.note
        let trackNumber = orderInfo.trackNumber
        let cell = [itemName, note, trackNumber]
            print("\(cell) is the cell")
        
        let httpBody = UPSBodyModel(trackingNumber: trackNumber, username: "Arau123", password: "$#09yaldrooldim")
        let httpBodyData = try! JSONEncoder().encode(httpBody)
        request.httpBody = httpBodyData
        request.httpMethod = "POST"
        
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: completionHandler)
        task.resume()
        
    }


        
    }

