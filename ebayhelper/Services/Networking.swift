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

    static func updateUPSStatus(for order: Order, completion: @escaping (Order?) -> Void) {
        // Override point for customization after application launch.
        
        //test the url
        let url = URL(string: "https://wwwcie.ups.com/rest/Track")!
        var request = URLRequest(url: url)
        
        
        let itemName = order.itemName
        let note = order.note
        let trackNumber = order.trackNumber
        let cell = [itemName, note, trackNumber]
            print("\(cell) is the cell")
        
        let httpBody = UPSBodyModel(trackingNumber: trackNumber, username: "Arau123", password: "$#09yaldrooldim")
        let httpBodyData = try! JSONEncoder().encode(httpBody)
        request.httpBody = httpBodyData
        request.httpMethod = "POST"
        
        
        let session = URLSession.shared
        
//        let task = session.dataTask(with: request, completionHandler: completionHandler)
        let task = session.dataTask(with: request) { (data, response, error) in
            
            
            guard error == nil else {
                print(error!)
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            guard let responseData = data else {
                fatalError("something is missing in the data")
            }
            
            guard let responseDataJSON = try? JSON(data: responseData)
                else {
                    print("cannot convert response data into dictionary")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
            }
            
            
            // MARK: SwiftyJSON Shipper Address Information
            let shipperAddressLine = responseDataJSON["TrackResponse"]["Shipment"]["ShipmentAddress"][0]["Address"]["AddressLine"].stringValue
            let shipment = responseDataJSON["TrackResponse"]["Shipment"]
            let shipmentAddressCity = shipment["ShipmentAddress"][0]["Address"]["City"].stringValue
            let shipmentAbbreviation = shipment["ShipmentAddress"][0]["Address"]["StateProvinceCode"].stringValue
            let shipperAddress = "\(shipperAddressLine), \(shipmentAddressCity), \(shipmentAbbreviation)"
            print("The package originated from \(shipperAddress)")
            
            // MARK: SwiftyJSON Receiver Address Information
            let receiverAddressCity = shipment["ShipmentAddress"][1]["Address"]["City"].stringValue
            let receiverAbbreviation = shipment["ShipmentAddress"][1]["Address"]["StateProvinceCode"].stringValue
            let receiverAddress = "\(receiverAddressCity), \(receiverAbbreviation)"
            print("The package is going to \(receiverAddress)")
            
            // MARK: SwiftyJSON Shipment Details
            let shipmentWeightNumber = responseDataJSON["TrackResponse"]["Shipment"]["ShipmentWeight"]["Weight"].stringValue
            let weightMeasurement = responseDataJSON["TrackResponse"]["Shipment"]["ShipmentWeight"]["UnitOfMeasurement"]["Code"].stringValue
            let shipperService = responseDataJSON["TrackResponse"]["Shipment"]["Service"]["Description"].stringValue
            
            print("The service is \(shipperService)")
            
            let shipmentWeight = "\(shipmentWeightNumber) \(weightMeasurement)"
            print("It weighs \(shipmentWeight)")
            
            let currentStatus = shipment["Package"]["Activity"][0]["Status"]["Description"].stringValue
            print("Its current status is \(currentStatus)")
            
            let currentAddyJSONer = shipment["Package"]["Activity"][0]["ActivityLocation"]["Address"]
            //              third thing is important - currentstatus doesnt exist wen i do this
            //            if currentStatus == "Order Processed: Ready for UPS" {
            //                let currentLocation = shipperAddress
            //                print(currentLocation)
            //            } else {
            let currentCity = currentAddyJSONer["City"].stringValue
            let currentState = currentAddyJSONer["StateProvinceCode"].stringValue
            let currentLocation = "\(currentCity), \(currentState)"
            print(currentLocation)
            //            }
            
            
            var newOrder = Order(note: order.note, trackNumber: order.trackNumber, itemName: order.itemName, status: currentStatus)
            
            let updatedExpandedInfo = ExpandedInfo(currentLocation: currentLocation, shipmentWeight: shipmentWeight, shipperService: shipperService, receiverAddress: receiverAddress, shipperAddress: shipperAddress)
            
            newOrder.upsInfo = updatedExpandedInfo
            
            DispatchQueue.main.async {
                completion(newOrder)
            }
        }
        
        task.resume()
        
    }


        
}

