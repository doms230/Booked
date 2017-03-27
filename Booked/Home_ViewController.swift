//
//  Home_ViewController.swift
//  Booked
//
//  Created by Dominic Smith on 10/31/15.
//
//

import UIKit
import Parse

class Home_ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,
UISearchBarDelegate {
    
    var searchActive: Bool = false
    
    var hello = [String]()
    
    var getBookTitle = [String] ()
    var filteredBookTitle = [String] ()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let searchBar: UISearchBar = UISearchBar(frame: CGRectMake(0,0,300,20))
        searchBar.placeholder = "Search Books"
        let leftNavButton = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = leftNavButton
        
        searchBar.delegate = self
        
        loadData()
        
    }
    
    //the prepare segue will be used to go to the expanded book title jaunt
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if segue.identifier == "detailBookInfo"
    {
    if let indexPath = self.tableView.indexPathForSelectedRow
    {
    let row = Int(indexPath.row)
    //let nav = segue.destinationViewController as! UINavigationController
    //let detailBookController = nav.topViewController as! DetailBook_ViewController
        
    let detailBookController = segue.destinationViewController as! DetailBook_ViewController
    //flyerScene.parseUsername = filteredUsername[row]
    detailBookController.bookInfo = self.hello[row]
    }
    }
    }

    func searchBarTextDidBeginEditing(searchBar: UISearchBar)
    {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar)
    {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchActive = false
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        //username search
        filteredBookTitle = getBookTitle.filter({(text) -> Bool in
            
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        
        if(filteredBookTitle.count == 0)
        {
            searchActive = false
            self.tableView.hidden = true
        } else
        {
            searchActive = true
            self.tableView.hidden = false
        }
        self.tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.getBookTitle.count
        
        /*if(searchActive)
        {
            return filteredBookTitle.count
            
        }*/
        //add method that says no results found
        return hello.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("homeSearch") as! HomeSearch_TableViewCell
        
        let bulletinQuery = PFQuery(className: "Books")
        bulletinQuery.whereKey("Title", equalTo: self.hello[indexPath.row])
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
                                            cell.bookView.image =  UIImage(data: imageData)!
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
        let subBullQuery = PFQuery(className: "Books")
       // subBullQuery.whereKey("userId", equalTo: PFUser.currentUser()!.objectId!)
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
