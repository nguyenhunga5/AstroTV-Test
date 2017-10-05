//
//  GoogleProvider.swift
//  AstroTV
//
//  Created by Hung Nguyen Thanh on 10/5/17.
//  Copyright © 2017 Hung Nguyen Thanh. All rights reserved.
//

import UIKit
import AWSCognito
import GoogleSignIn

class GoogleProvider: AWSCognitoCredentialsProviderHelper {

    override func logins() -> AWSTask<NSDictionary> {
        
        if let currentUser = GIDSignIn.sharedInstance().currentUser, let token = currentUser.authentication.idToken {
            
            return AWSTask(result: [AWSIdentityProviderGoogle:token])
        }
        return AWSTask(error:NSError(domain: "Google Login", code: -1 , userInfo: ["Google" : "No current Google access token"]))
    }
}
