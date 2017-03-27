//
//  PostBook_ViewController.swift
//  Booked
//
//  Created by Dominic Smith on 10/31/15.
//
//

import UIKit
import Parse
import CoreLocation

class PostBook_ViewController: UIViewController {
    
    //Variables
   // var pickerView: PopUpPickerView
    var bookConditionString: String!
    
    var valCoor: Bool!
    var valTitle : Bool!
    var valLocation : Bool!
    var eventLatitude : Double!
    var eventLongitude : Double!
    var point : PFGeoPoint!
    
    let picker = UIImagePickerController()
    
    //UIComponents
    @IBOutlet weak var bookDescription: UITextField!
    
    @IBOutlet weak var bookTitle: UITextField!
    
    @IBOutlet weak var bookISBN: UITextField!
    
    @IBOutlet weak var bookLocation: UITextField!
    
    @IBOutlet weak var myLocationSwitchOutlet: UISwitch!
    
    @IBOutlet weak var segmentPicked: UISegmentedControl!
    
    @IBOutlet weak var booPicImageview: UIImageView!
    
    @IBAction func uploadBookPic(sender: UIButton) {
        
        picker.allowsEditing = false
        picker.sourceType = .PhotoLibrary
        presentViewController(picker, animated: true, completion: nil)
    }
    
    //image process
    
    //Image picker functions
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            booPicImageview.contentMode = .ScaleAspectFit
        booPicImageview.image = chosenImage
        
        dismissViewControllerAnimated(true, completion: nil)
        
        //validation method to insure that the user uploaded pic.. come back to later
        //didUpload = true
        
       
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //Determine whether the book is used or new
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        switch segmentPicked.selectedSegmentIndex{
        case 0:
            bookConditionString = "USED";
            
        case 1:
            bookConditionString = "NEW";
            
        default:
            bookConditionString = "USED";
            break;
        }
    }
    
    //connect parse
    @IBAction func postBook(sender: UIButton) {
        let postBook = PFObject(className: "Books")
        
        //ACL Jaunt
        //let acl = PFACL()
        //acl.setWriteAccess(true, forUser: PFUser.currentUser()!)
        //acl.setReadAccess(true, forUser: PFUser.currentUser()!)
        //postBook.ACL = acl
        
       //let sample = PFFile(name: "sample.pmg", contentsAtPath: "book_sample.png") throw
        //BookImage Jaunt
        let profilePic = UIImagePNGRepresentation(booPicImageview.image!)
        let imageFile = PFFile(name: "booKPic_ios.jpeg", data: profilePic!)
        postBook["BookPic"] = imageFile
        
        //booTitle jaunt
        postBook["Title"] = bookTitle.text
        
        //bookISBN jaunt
        postBook["ISBN"] = bookISBN.text
        
        //bookLocation
       // postBook["Location"] = point
        
        //bookCondition
        postBook["Condition"] = bookConditionString
        
        //bookDescription
        postBook["Description"] = bookDescription.text
        
        //user jaunt
        postBook["user"] = PFUser.currentUser()
        postBook["userId"] = PFUser.currentUser()?.objectId
       
        
        let geoCoder = CLGeocoder()
        let addressString = bookLocation.text
        
        geoCoder.geocodeAddressString(addressString!) {(placemarks, error) -> Void in
            if let placemark = placemarks?[0]
            {
                self.eventLatitude =  placemark.location!.coordinate.latitude
                self.eventLongitude =   placemark.location!.coordinate.longitude
                
                self.point = PFGeoPoint(latitude: self.eventLatitude!, longitude: self.eventLongitude!)
                postBook["Location"] = self.point
                
                postBook.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        
                        self.performSegueWithIdentifier("home", sender: self)
                        // self.navigationItem.hidesBackButton =
                        
                    } else {
                        //self.showProblemAlert("Event Creation Failed.", message: "Check your internet connection, and try again.")
                        print("problem with upload")
                    }
                }
                
            } else{
                print("Address not found")
                //self.bookLocation.text = "Address not found."
                //self.bookLocation.textColor = UIColor.greenColor()
                self.valCoor = false
            }
        }
        
        
        /*postBook.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                
                self.performSegueWithIdentifier("home", sender: self)
                // self.navigationItem.hidesBackButton =
                
            } else {
                //self.showProblemAlert("Event Creation Failed.", message: "Check your internet connection, and try again.")
                print("problem with upload")
            }
        }*/
    }
    
    //Main stuff

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getLatLng()
    {
        let geoCoder = CLGeocoder()
        let addressString = bookLocation.text
        
        geoCoder.geocodeAddressString(addressString!) {(placemarks, error) -> Void in
            if let placemark = placemarks?[0]
            {
                self.eventLatitude =  placemark.location!.coordinate.latitude
                self.eventLongitude =   placemark.location!.coordinate.longitude
                self.valCoor = true
            } else{
                print("Address not found")
                //self.bookLocation.text = "Address not found."
                //self.bookLocation.textColor = UIColor.greenColor()
                self.valCoor = false
            }
        }
    }
    
    
    //validation tests 

    
}
