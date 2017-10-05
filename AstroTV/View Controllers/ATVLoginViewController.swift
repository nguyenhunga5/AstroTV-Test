//
//  ATVLoginViewController.swift
//  AstroTV
//
//  Created by Hung Nguyen Thanh on 10/5/17.
//  Copyright © 2017 Hung Nguyen Thanh. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import AWSS3
import AWSCognito

class ATVLoginViewController: ATVBaseViewController {

    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.fbLoginButton.readPermissions = ["email"]
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if FBSDKAccessToken.current() != nil  {
            
            let credentialsProvider = AWSCognitoCredentialsProvider(regionType: AWSRegionType.APSoutheast1, identityPoolId: kIdentityPoolId, identityProviderManager: FacebookProvider())
            let configuration = AWSServiceConfiguration(region:.APSoutheast1, credentialsProvider:credentialsProvider)
            
            AWSServiceManager.default().defaultServiceConfiguration = configuration
            
            self.performSegue(withIdentifier: kShowListSegue, sender: self)
        }

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

extension ATVLoginViewController: GIDSignInUIDelegate {
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        
        self.present(viewController, animated: true, completion: nil)
    }
}

extension ATVLoginViewController: GIDSignInDelegate {
    
    // MARK - SSO
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let _ = user {
            
            let credentialsProvider = AWSCognitoCredentialsProvider(regionType: AWSRegionType.APSoutheast1, identityPoolId: kIdentityPoolId, identityProviderManager: GoogleProvider())
            let configuration = AWSServiceConfiguration(region:.APSoutheast1, credentialsProvider:credentialsProvider)
            
            AWSServiceManager.default().defaultServiceConfiguration = configuration
            self.performSegue(withIdentifier: kShowListSegue, sender: self)
        }
        
    }
}

extension ATVLoginViewController: FBSDKLoginButtonDelegate {
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if !result.isCancelled {
            
            let credentialsProvider = AWSCognitoCredentialsProvider(regionType: AWSRegionType.APSoutheast1, identityPoolId: kIdentityPoolId, identityProviderManager: FacebookProvider())
            let configuration = AWSServiceConfiguration(region:.APSoutheast1, credentialsProvider:credentialsProvider)
            let cognitoId = credentialsProvider.identityId
            
            AWSServiceManager.default().defaultServiceConfiguration = configuration
            
            self.performSegue(withIdentifier: kShowListSegue, sender: self)
        }
    }
}
