//
//  ConfirmationVC.swift
//  ebayhelper
//
//  Created by Arun Rau on 8/3/18.
//  Copyright © 2018 Arun Rau. All rights reserved.
//

import UIKit
import FirebaseAuth

class ConfirmationVC: UIViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let WebVC = segue.destination as? WebViewController else {return}
        let identifier = segue.identifier
        if identifier == "gmail" {
            WebVC.urlString = "https://accounts.google.com/signin/v2/identifier?service=mail&passive=true&rm=false&continue=https%3A%2F%2Fmail.google.com%2Fmail%2F&ss=1&scc=1&ltmpl=default&ltmplcache=2&emr=1&osid=1&flowName=GlifWebSignIn&flowEntry=ServiceLogin"
        }
        else if identifier == "outlook" {
            WebVC.urlString = "https://login.live.com/login.srf?wa=wsignin1.0&rpsnv=13&ct=1533335010&rver=6.7.6640.0&wp=MBI_SSL&wreply=https%3a%2f%2foutlook.live.com%2fowa%2f%3fnlp%3d1%26RpsCsrfState%3d06baae4c-9387-f812-05f1-0788a23827fc&id=292841&CBCXT=out&lw=1&fl=dob%2cflname%2cwld&cobrandid=90015"
        }
        else if identifier == "yahoo" {
            WebVC.urlString = "https://login.yahoo.com/config/login?.src=fpctx&.intl=us&.lang=en-US&.done=https%3A%2F%2Fwww.yahoo.com"
        }
        else {
            print("what did u do")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
