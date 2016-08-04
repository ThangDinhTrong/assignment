//
//  MenuTableViewController.swift
//  CollectionViewDemo
//
//  Created by dinh trong thang on 8/4/16.
//  Copyright © 2016 dinh trong thang. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 64
        imageView.clipsToBounds = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */



    


   

 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
            case "musicVideo":
                let viewController = segue.destinationViewController.childViewControllers[0] as! ViewController
                viewController.currentCellIndexRow = 0
            case "movie":
                let viewController = segue.destinationViewController.childViewControllers[0] as! ViewController
                viewController.currentCellIndexRow = 1
            case "ebook":
                let viewController = segue.destinationViewController.childViewControllers[0] as! ViewController
                viewController.currentCellIndexRow = 2
            case "audiobook":
                let viewController = segue.destinationViewController.childViewControllers[0] as! ViewController
                viewController.currentCellIndexRow = 3
            case "podcast":
                let viewController = segue.destinationViewController.childViewControllers[0] as! ViewController
                viewController.currentCellIndexRow = 4
        default:
            print("ko")
        }
    }

}
