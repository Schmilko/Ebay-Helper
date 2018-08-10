
//
//  TestViewController.swift
//  ebayhelper
//
//  Created by Arun Rau on 7/24/18.
//  Copyright © 2018 Arun Rau. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import FirebaseDatabase

class TestViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    
    var order : Order?
    
    var newOrder : Order?
    
    var newInfo : ExpandedInfo?
    
    var orders = [Order]() // this is the array that is used show data in your tableview
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.logOut(_:)))
    }
    
 
    @objc func logOut(_ sender: Any) {
        User.logoutUser()
     
        // need to make it modal again for this to work
        if self.presentingViewController != nil {
            self.performSegue(withIdentifier: "unwindToLogin", sender: nil)
        } else {
            self.performSegue(withIdentifier: "showLogin", sender: nil)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        OrderService.show { (orders) in
            var updatedOrders: [Order] = []
            
            let dg = DispatchGroup()
            
            for order in orders {
                dg.enter()
                Networking.updateUPSStatus(for: order, completion: { (updatedOrder) in
                    if let updatedOrder = updatedOrder {
                        updatedOrders.append(updatedOrder)
                    }
                    dg.leave()
                })
            }
            
            dg.notify(queue: DispatchQueue.main, execute: {
                self.orders = updatedOrders
                self.tableView.reloadData()
            })
        }
    }
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
        print("unwinded")
    }
    
    // transferring data to the add button and the expanded cell
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier
            else {return}
        switch identifier {
        case "soSmart":
            let destination = segue.destination as! TabernaViewController
            destination.newOrder = newOrder
            destination.delegate = self as TabernaDelegate
//            destination.orders = orders
            
            
        case "displayItem":
            let destination = segue.destination as! ExpandedItemViewController
            
            guard
                let cell = sender as? UITableViewCell,
                let indexPath = tableView.indexPath(for: cell) else {
                    fatalError("displayItem segue was not prefored by a cell, check sender: \(String(describing: sender))")
            }
            
            
            destination.order = self.orders[indexPath.row]
            
            
        default:
            print("no idea")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // pan
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackingCell", for: indexPath) as! TrackTableCell
        let orderCell = orders[indexPath.row]
        print("this is test's order array: \(orders)")
        cell.itemLabel.text = orderCell.itemName
        cell.notesLabel.text = orderCell.note
        cell.trackLabel.text = orderCell.trackNumber
        cell.statusLabel.text = orderCell.status
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            orders.remove(at: indexPath.row)
            guard let ref = OrderService.ref else {return}
            OrderService.delete(ref: ref)
            print("deleted from firebase")
            
        }
    }
}

extension TestViewController: TabernaDelegate {
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func tabernaViewController(_ viewController: TabernaViewController, didFinishCreatingNew order: Order) {
        self.orders.insert(order, at: 0)
        self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    func performNetworking(order: Order, completion: @escaping (Order?)->Void) {
//        Networking.doNetworkRequest(orderInfo: order) { (data, response, error) in
//
//            guard error == nil else {
//                print(error!)
//                return completion(nil)
//            }
//
//            guard let responseData = data else {
//                fatalError("something is missing in the data")
//            }
//
//            guard let responseDataJSON = try? JSON(data: responseData)
//                else {
//                    print("cannot convert response data into dictionary")
//                    return completion(nil)
//            }
//
//
//            // MARK: SwiftyJSON Shipper Address Information
//            let shipperAddressLine = responseDataJSON["TrackResponse"]["Shipment"]["ShipmentAddress"][0]["Address"]["AddressLine"].stringValue
//            let shipment = responseDataJSON["TrackResponse"]["Shipment"]
//            let shipmentAddressCity = shipment["ShipmentAddress"][0]["Address"]["City"].stringValue
//            let shipmentAbbreviation = shipment["ShipmentAddress"][0]["Address"]["StateProvinceCode"].stringValue
//            let shipperAddress = "\(shipperAddressLine), \(shipmentAddressCity), \(shipmentAbbreviation)"
//            print("The package originated from \(shipperAddress)")
//
//            // MARK: SwiftyJSON Receiver Address Information
//            let receiverAddressCity = shipment["ShipmentAddress"][1]["Address"]["City"].stringValue
//            let receiverAbbreviation = shipment["ShipmentAddress"][1]["Address"]["StateProvinceCode"].stringValue
//            let receiverAddress = "\(receiverAddressCity), \(receiverAbbreviation)"
//            print("The package is going to \(receiverAddress)")
//
//            // MARK: SwiftyJSON Shipment Details
//            let shipmentWeightNumber = responseDataJSON["TrackResponse"]["Shipment"]["ShipmentWeight"]["Weight"].stringValue
//            let weightMeasurement = responseDataJSON["TrackResponse"]["Shipment"]["ShipmentWeight"]["UnitOfMeasurement"]["Code"].stringValue
//            let shipperService = responseDataJSON["TrackResponse"]["Shipment"]["Service"]["Description"].stringValue
//
//            print("The service is \(shipperService)")
//
//            let shipmentWeight = "\(shipmentWeightNumber) \(weightMeasurement)"
//            print("It weighs \(shipmentWeight)")
//
//            let currentStatus = shipment["Package"]["Activity"][0]["Status"]["Description"].stringValue
//            print("Its current status is \(currentStatus)")
//
//            let currentAddyJSONer = shipment["Package"]["Activity"][0]["ActivityLocation"]["Address"]
//            //              third thing is important - currentstatus doesnt exist wen i do this
//            //            if currentStatus == "Order Processed: Ready for UPS" {
//            //                let currentLocation = shipperAddress
//            //                print(currentLocation)
//            //            } else {
//            let currentCity = currentAddyJSONer["City"].stringValue
//            let currentState = currentAddyJSONer["StateProvinceCode"].stringValue
//            let currentLocation = "\(currentCity), \(currentState)"
//            print(currentLocation)
//            //            }
//
//
//            let newOrder = Order(note: order.note, trackNumber: order.trackNumber, itemName: order.itemName, status: currentStatus)
//            self.newOrder = newOrder
//
//
//
//            let upsInfo = ExpandedInfo(currentLocation: currentLocation, shipmentWeight: shipmentWeight, shipperService: shipperService, receiverAddress: receiverAddress, shipperAddress: shipperAddress)
//
//            self.newInfo = moreInfo
//
//            return completion(newOrder)
//
//        }
    }
}




