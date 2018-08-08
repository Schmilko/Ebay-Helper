//
//  UPSBodyModel.swift
//  ebayhelper
//
//  Created by Arun Rau on 7/25/18.
//  Copyright © 2018 Arun Rau. All rights reserved.
//

import Foundation

struct UPSBodyModel: Encodable {
    struct _UPSSecurity: Encodable {
        struct _UsernameToken: Encodable {
            let Username: String
            let Password: String
        }
        let UsernameToken: _UsernameToken
        
        struct _ServiceAccessToken: Encodable {
            let AccessLicenseNumber: String = "ED4AEB537EFCFEA8"
        }
        let ServiceAccessToken: _ServiceAccessToken = _ServiceAccessToken()
    }
    let UPSSecurity: _UPSSecurity
    
    struct _TrackRequest: Encodable {
        struct _Request: Encodable {
            let RequestOption: String = "1"
            
            struct _TransactionReference: Encodable {
                let CustomerContext: String = "Your Test Case Summary Description"
            }
            let TransactionReference: _TransactionReference = _TransactionReference()
        }
        let Request: _Request = _Request()
        let InquiryNumber: String
    }
    let TrackRequest: _TrackRequest
    
    init(trackingNumber: String, username: String, password: String) {
        
        let usernameToken = _UPSSecurity._UsernameToken(Username: username, Password: password)
        self.UPSSecurity = _UPSSecurity(UsernameToken: usernameToken)
        
        self.TrackRequest = _TrackRequest(InquiryNumber: trackingNumber)
    }
}

