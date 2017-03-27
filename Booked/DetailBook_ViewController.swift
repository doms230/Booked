//
//  DetailBook_ViewController.swift
//  Booked
//
//  Created by Dominic Smith on 10/31/15.
//
//

import UIKit
import Parse

class DetailBook_ViewController: UIViewController {

    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookDescription: UITextView!
    @IBOutlet weak var bookDate: UILabel!
    @IBOutlet weak var bookLocation: UILabel!
    @IBOutlet weak var bookISBN: UILabel!
    @IBOutlet weak var bookCondition: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    
    @IBOutlet weak var requestStatus: UIButton!
    
    var bookInfo: String?
    
    var ownerId: String?
    var owner: PFUser?
    
    var getObjects = [String] ()
    
    @IBAction func requestBook(sender: UIButton) {
        
        let postRequest = PFObject(className: "Requests")
        
        //booTitle jaunt
        postRequest["bookId"] = bookTitle.text
        postRequest["requesteeId"] = PFUser.currentUser()?.objectId
        postRequest["reuestee"] = PFUser.currentUser()
        postRequest["ownerid"] = owner
        postRequest["ISBN"] = bookISBN.text
        postRequest["Title"] = bookTitle.text
        postRequest["Status"] = "pending"
        
        let profilePic = UIImagePNGRepresentation(bookImage.image!)
        let imageFile = PFFile(name: "booKPic_ios.jpeg", data: profilePic!)
        postRequest["BookPic"] = imageFile
        
        postRequest.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("request created")
                
                self.requestStatus.enabled = false
                self.requestStatus.setTitle("PENDING", forState: .Normal)
                self.requestStatus.backgroundColor = UIColor.grayColor()
                //self.performSegueWithIdentifier("home", sender: self)
                // self.navigationItem.hidesBackButton =
                
            } else {
                //self.showProblemAlert("Event Creation Failed.", message: "Check your internet connection, and try again.")
                print("problem with upload")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkRequest()
        
        loadUserData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadUserData()
    {
        let favQuery = PFQuery(className: "Books")
        favQuery.whereKey("Title", equalTo: self.bookInfo!)
        favQuery.findObjectsInBackgroundWithBlock
            {
                (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil
                {
                    
                    if let objects = objects as [PFObject]?
                    {
                        for object in objects
                        {
                            
                            //Name
                            //let stringName = object["DisplayName"] as? String
                           
                            self.bookTitle.text = object["Title"] as? String
                            self.bookDate.text = object["createdAt"] as? String
                            self.bookCondition.text = object["Condition"] as? String
                            self.bookISBN.text = object["ISBN"] as? String
                            self.bookDescription.text = object["Description"] as? String
                            self.ownerId = object["userId"] as? String
                            self.owner = object["user"] as? PFUser
                            
                            let bulletinPic =  object["BookPic"] as! PFFile
                            bulletinPic.getDataInBackgroundWithBlock
                                {
                                    (imageData: NSData?, error: NSError?) -> Void in
                                    if error == nil
                                    {
                                        if let imageData = imageData
                                        {
                                            //self.bulletinImage1 = UIImage(data: imageData)
                                            
                                            self.bookImage.image = UIImage(data: imageData)
                                            
                                        }
                                    }
                            }
                        }
                        
                        //println(self.bulletinImage.count)
                    } else
                        
                    {
                        print("Error: \(error!) \(error!.userInfo)")
                    }
                    
                }
        }
    }
    
    func checkRequest(){
        let favQuery = PFQuery(className: "Requests")
        favQuery.whereKey("requesteeId", equalTo: (PFUser.currentUser()?.objectId)!)
        favQuery.whereKey("Title", equalTo: self.bookInfo!)
        favQuery.findObjectsInBackgroundWithBlock
            {
                (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil
                {
                    
                    if let objects = objects as [PFObject]?
                    {
                        for object in objects
                        {
                            
                            //Name
                            //let stringName = object["DisplayName"] as? String
                            
                            let requestStatus = object["Status"] as? String
                            
                           if requestStatus == "pending"{
                            self.requestStatus.enabled = false
                            self.requestStatus.setTitle("PENDING", forState: .Normal)
                            self.requestStatus.backgroundColor = UIColor.grayColor()
                            }
                        }
                        
                        //println(self.bulletinImage.count)
                    } else
                        
                    {
                        print("Error: \(error!) \(error!.userInfo)")
                    }
                    
                }
        }
        
        
    }
}
