//
//  FacebookProvider.swift
//  AstroTV
//
//  Created by Hung Nguyen Thanh on 10/5/17.
//  Copyright © 2017 Hung Nguyen Thanh. All rights reserved.
//

import UIKit
import AWSCognito
import FBSDKCoreKit

class FacebookProvider: AWSCognitoCredentialsProviderHelper {

    override func logins() -> AWSTask<NSDictionary> {
        if let loggedToken = FBSDKAccessToken.current(), let token = loggedToken.tokenString {
            return AWSTask(result: [AWSIdentityProviderFacebook:token])
        }
        return AWSTask(error:NSError(domain: "Facebook Login", code: -1 , userInfo: ["Facebook" : "No current Facebook access token"]))
    }
    
}
