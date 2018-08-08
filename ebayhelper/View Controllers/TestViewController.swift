
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
    
    var orders = [Order]() { // this is the array that is used show data in your tableview

        didSet {
            tableView.reloadData()
        }
    }
    
    //    var currentStatus: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self,)
        self.navItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.logOut(_:)))
    }
  
//    @IBAction func unwindToLogin(_ segue: UIStoryboardSegue) {
//        print("unwinded2login")
//    }
//
    @objc func logOut(_ sender: Any) {
        let user = User.current
        User.setCurrent(user, writeToUserDefaults: false)
        performSegue(withIdentifier: "changeToUnwind", sender: self)

//        let LoginVC = LoginViewController()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        OrderService.show { (orders) in
            self.orders = orders
        }
    }


    
    func performNetworking(order: Order) {
        Networking.doNetworkRequest(orderInfo: order) { (data, response, error) in
            
            guard error == nil else {
                print(error!)
                return
            }
            
            guard let responseData = data else {
                fatalError("something is missing in the data")
            }
            
            guard let responseDataJSON = try? JSON(data: responseData)
                else {
                    return print("cannot convert response data into dictionary")
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
//
//            if currentStatus == "Order Processed: Ready for UPS" {
//                let currentLocation = shipperAddress
//                print(currentLocation)
//            } else {
                let currentCity = currentAddyJSONer["City"].stringValue
                let currentState = currentAddyJSONer["StateProvinceCode"].stringValue
                let currentLocation = "\(currentCity), \(currentState)"
                print(currentLocation)
//            }
            
            let moreInfo = ExpandedInfo(currentLocation: currentLocation, shipmentWeight: shipmentWeight, shipperService: shipperService, receiverAddress: receiverAddress, shipperAddress: shipperAddress)
            
            self.newInfo = moreInfo
            
            let newOrder = Order(note: order.note, trackNumber: order.trackNumber, itemName: order.itemName, status: currentStatus)
            
            OrderService.create(newOrder, completion: { (newOrder) in
                if newOrder != nil {
                    print("order saved")
                } else {
                    print("something went wront")
                }
            })
            
            DispatchQueue.main.async {
                self.orders.append(newOrder)
            }
            
            print(self.orders)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
        print("unwinded")
    }
    
    
    // data transferß to other viewcontrrooôlłêrs

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier
            else {return}
        switch identifier {
        case "soSmart":
            let destination = segue.destination as! TabernaViewController
            destination.delegate = self as TabernaDelegate
            
        case "displayItem":
            let destination = segue.destination as! ExpandedItem
            destination.newInfo = newInfo
            destination.order = order
        
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
        // 3.
        // create label for status and update it with what is contained in the model
        
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
}



