//
//  Signin_ViewController.swift
//  Booked
//
//  Created by Dominic Smith on 10/31/15.
//
//

import UIKit
import FBSDKCoreKit
import ParseFacebookUtilsV4


class Signin_ViewController: UIViewController {
    
    var signin: Bool?
    
    @IBAction func sign(sender: UIButton) {
        
        /*let facebookRequest: FBSDKGraphRequest! = FBSDKGraphRequest(graphPath: "/me/permissions", parameters: nil, HTTPMethod: "DELETE")
        
        facebookRequest.startWithCompletionHandler { (connection: FBSDKGraphRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            
            if(error == nil && result != nil){
                print("Permission successfully revoked. This app will no longer post to Facebook on your behalf.")
                print("result = \(result)")
                
                //Sucess sho show login 
                let permissions = [String]()
                
                PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
                    (user: PFUser?, error: NSError?) -> Void in
                    if let user = user {
                        if user.isNew {
                            print("User signed up and logged in through Facebook!")
                        } else {
                            print("User logged in through Facebook!")
                        }
                    } else {
                        print("Uh oh. The user cancelled the Facebook login.")
                    }
                }
                
            } else {
                if let error: NSError = error {
                    if let errorString = error.userInfo["error"] as? String {
                        print("errorString variable equals: \(errorString)")
                    }
                } else {
                    print("No value for error key")
                }
            }
        }*/
        
        //
        
        let permissions = [String]()
        
        
        //wasn't working properly see segue.. in storyboard
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    print("User signed up and logged in through Facebook!")
                     self.performSegueWithIdentifier("showHome", sender: self)
                } else {
                    print("User logged in through Facebook!")
                     self.performSegueWithIdentifier("showHome", sender: self)
                }
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        PFUser.logOut()
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
