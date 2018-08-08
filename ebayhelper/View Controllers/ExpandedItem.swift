//
//  ExpandedItem.swift
//  ebayhelper
//
//  Created by Arun Rau on 8/6/18.
//  Copyright © 2018 Arun Rau. All rights reserved.
//

import UIKit

class ExpandedItem: UIViewController {
   
    @IBOutlet weak var shipperAddress: UILabel!
    
    @IBOutlet weak var receiverAddress: UILabel!
    
    @IBOutlet weak var currentLocation: UILabel!
    
    @IBOutlet weak var shipmentWeight: UILabel!
    
    @IBOutlet weak var shipperService: UILabel!
    
    @IBOutlet weak var itemTitle: UILabel!
    
    var newInfo : ExpandedInfo?
    
    var order : Order?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shipperAddress.text = newInfo?.shipperAddress
        receiverAddress.text = newInfo?.receiverAddress
        currentLocation.text = newInfo?.currentLocation
        shipmentWeight.text = newInfo?.shipmentWeight
        shipperService.text = newInfo?.shipperService
        itemTitle.text = order?.itemName
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
