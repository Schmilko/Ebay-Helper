//
//  ExpandedItemViewController.swift
//  ebayhelper
//
//  Created by Arun Rau on 8/6/18.
//  Copyright © 2018 Arun Rau. All rights reserved.
//

import UIKit

class ExpandedItemViewController: UIViewController {
    
    @IBOutlet weak var shipperAddress: UILabel!
    
    @IBOutlet weak var receiverAddress: UILabel!
    
    @IBOutlet weak var currentLocation: UILabel!
    
    @IBOutlet weak var shipmentWeight: UILabel!
    
    @IBOutlet weak var shipperService: UILabel!
    
    @IBOutlet weak var itemTitle: UILabel!
    
    var order : Order!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func updateUI(failedToUpdateUPSInfo: Bool = false) {
        itemTitle.text = order.itemName
        
        if failedToUpdateUPSInfo {
            shipperAddress.text = "Unavailable"
            receiverAddress.text = "Unavailable"
            currentLocation.text = "Unavailable"
            shipmentWeight.text = "Unavailable"
            shipperService.text = "Unavailable"
            return
        }
        
        if let upsInfo = order.upsInfo {
            shipperAddress.text = upsInfo.shipperAddress
            receiverAddress.text = upsInfo.receiverAddress
            currentLocation.text = upsInfo.currentLocation
            shipmentWeight.text = upsInfo.shipmentWeight
            shipperService.text = upsInfo.shipperService
        } else {
            
            //error, try  only one more time to update the ups info
            Networking.updateUPSStatus(for: order) { (updatedOrder) in
                if let updatedOrder = updatedOrder {
                    self.order = updatedOrder
                    self.updateUI()
                } else {
                    self.updateUI(failedToUpdateUPSInfo: true)
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
