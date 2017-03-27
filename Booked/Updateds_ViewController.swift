//
//  Updateds_ViewController.swift
//  Booked
//
//  Created by Dominic Smith on 11/1/15.
//
//

import UIKit
import Parse

class Updateds_ViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate {
    
    var hello = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
    
        
    }
    
    //the prepare segue will be used to go to the expanded book title jaunt
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showDetail"
        {
            if let indexPath = self.tableView.indexPathForSelectedRow
            {
                let row = Int(indexPath.row)
                //let nav = segue.destinationViewController as! UINavigationController
                //let detailBookController = nav.topViewController as! DetailBook_ViewController
                
                let detailBookController = segue.destinationViewController as! DetailBook_ViewController

            
                detailBookController.bookInfo = self.hello[row]
            }
        }
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return hello.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("updateReuse") as! Updates_TableViewCell
        
        let bulletinQuery = PFQuery(className: "Requests")
        bulletinQuery.whereKey("Title", equalTo: self.hello[indexPath.row])
       // bulletinQuery.whereKey("requesteeId", equalTo: PFUser.currentUser()!.objectId!)
        bulletinQuery.findObjectsInBackgroundWithBlock
            {
                (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil
                {
                    
                    if let objects = objects as [PFObject]?
                    {
                        
                        //retrieve the objects from the database
                        for object in objects
                        {
                            
                            cell.bookISBN.text = object["ISBN"] as! String?
                            cell.bookTitle.text = object["Title"] as! String?
                            cell.action.text = object["Status"] as! String?
                            
                            cell.bookTitle.text = object["Title"] as! String?
                            cell.bookISBN.text = object["ISBN"] as! String?
                            //retrieve images///////////////////
                            let bulletinPic =  object["BookPic"] as! PFFile
                            bulletinPic.getDataInBackgroundWithBlock
                                {
                                    (imageData: NSData?, error: NSError?) -> Void in
                                    if error == nil
                                    {
                                        if let imageData = imageData
                                        {
                                            cell.bookImage.image =  UIImage(data: imageData)!
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
        
        return cell
    }
    
    func loadData()
    {
        let subBullQuery = PFQuery(className: "Requests")
         subBullQuery.whereKey("requesteeId", equalTo: PFUser.currentUser()!.objectId!)
        subBullQuery.findObjectsInBackgroundWithBlock
            {
                (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil
                {
                    
                    if let objects = objects as [PFObject]?
                    {
                        for object in objects
                        {
                            
                            //get the bulletins that the current user is subscribed to
                            
                            self.hello.append((object["Title"] as? String)!)
                            
                        } 
                        
                        self.tableView.reloadData()
                        //println(self.bulletinImage.count)
                    } else
                        
                    {
                        //0println("Error: \(error!) \(error!.userInfo!)")
                    }
                }
        }
    }
}
