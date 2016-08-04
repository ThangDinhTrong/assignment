//
//  ViewController.swift
//  CollectionViewDemo
//
//  Created by dinh trong thang on 8/1/16.
//  Copyright © 2016 dinh trong thang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var indexCell:[Int] = [0,1,2,3,4]
    var mediaArray:[String] = ["musicVideo","movie","ebook","audiobook","podcast"]
    var currentCellIndexRow:Int = 0
    var lastCellIndexRow:Int = 0
    var audiobooks = [Audiobook]()
    var podcasts = [Podcast]()
    var musicvideos = [Musicvideo]()
    var movies = [Movie]()
    var ebooks = [Ebook]()
    var indexPaths = [NSIndexPath]()
    var tableViewIndexPaths = [NSIndexPath]()

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate=self
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        leftGesture.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(leftGesture)
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        rightGesture.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(rightGesture)
        for i in 0...4 {
            let index = NSIndexPath(forItem: i, inSection: 0)
            self.indexPaths.append(index)
        }
        
        
        
        
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        
        if self.revealViewController() != nil {
            self.menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            if currentCellIndexRow != 0 {
                self.revealViewController().panGestureRecognizer().enabled = false
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailSegue" {
            if let indexPathTableView = tableView.indexPathForSelectedRow {
                let destinationController = segue.destinationViewController as! DetailViewController
                destinationController.currentCellIndexRow = currentCellIndexRow
                switch currentCellIndexRow {
                case 0:
                    destinationController.musicVideoObj = musicvideos[indexPathTableView.row]
                case 1:
                    destinationController.movieObj = movies[indexPathTableView.row]
                case 2:
                    destinationController.ebookObj = ebooks[indexPathTableView.row]
                case 3:
                    destinationController.audibookObj = audiobooks[indexPathTableView.row]
                case 4:
                    destinationController.podcastObj = podcasts[indexPathTableView.row]
                default:
                    print("Error")
                }
                
            }
        }
    }
    func loadImageFromUrl(url: String, view: UIImageView){
        
        let url = NSURL(string: url)!
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (responseData, responseUrl, error) -> Void in
            if let data = responseData{
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    view.image = UIImage(data: data)
                })
            }
        }
        
        task.resume()
    }


}
//xu li gesture
extension ViewController {
    func swipeAction(swipe:UISwipeGestureRecognizer) {
        var searchTerm = mediaArray[currentCellIndexRow]
        switch swipe.direction {
        case UISwipeGestureRecognizerDirection.Right:
            if currentCellIndexRow == 0 {
                
                return
            }
            
            lastCellIndexRow=currentCellIndexRow
            currentCellIndexRow = currentCellIndexRow - 1
            searchTerm = mediaArray[currentCellIndexRow]
            print(searchTerm)

        case UISwipeGestureRecognizerDirection.Left:
            if currentCellIndexRow == 4 {
                return
            }
            
            lastCellIndexRow=currentCellIndexRow
            currentCellIndexRow = currentCellIndexRow + 1
            searchTerm = mediaArray[currentCellIndexRow]
            print(searchTerm)

        default:
            print("unknown")
        }
        if currentCellIndexRow != 0 && self.revealViewController() != nil{
            self.revealViewController().panGestureRecognizer().enabled = false
        }
        else if currentCellIndexRow==0 && self.revealViewController() != nil{
            self.revealViewController().panGestureRecognizer().enabled = true
        }
        let index = NSIndexPath(forItem: currentCellIndexRow, inSection: 0)
        self.collectionView.scrollToItemAtIndexPath(index, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
//        self.collectionView.scrollToItemAtIndexPath(ViewController.indexPaths[self.currentCellIndexRow], atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
        for index in self.indexPaths {
            self.collectionView.cellForItemAtIndexPath(index)?.backgroundColor = UIColor(red: 255, green: 175, blue: 50, alpha: 0)
        }
        self.collectionView.cellForItemAtIndexPath(self.indexPaths[currentCellIndexRow])?.backgroundColor=UIColor(red: 255, green: 90, blue: 50, alpha: 0.25)
        UIView.transitionWithView(tableView,duration: 0.35,options: .TransitionCrossDissolve,animations:{ () -> Void in},completion: nil)
        if !((searchBar.text?.isEmpty)!) {
            self.searchBarSearchButtonClicked(self.searchBar)
        }
        
    }
    
}
extension ViewController:UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CollectionViewCell
        switch indexPath.row {
        case 0:
            cell.label.text = "musicVideo"
        case 1:
            cell.label.text = "movie"
        case 2:
            cell.label.text = "ebook"
        case 3:
            cell.label.text = "audiobook"
        case 4:
            cell.label.text = "podcast"
        default:
            cell.label.text = ""
        }
        cell.backgroundColor = UIColor(red: 255, green: 175, blue: 50, alpha: 0)
        if indexPath.row==currentCellIndexRow {
            cell.backgroundColor = UIColor(red: 255, green: 90, blue: 50, alpha: 0.25)
        }
//        self.indexPaths.append(indexPath)
        return cell
    }
    
}
extension ViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
    }
    
}

extension ViewController:UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch mediaArray[currentCellIndexRow] {
            case "musicVideo":
                print(musicvideos.count)
                return musicvideos.count
            case "movie":
                print(movies.count)
                return movies.count
            case "audiobook":
                print(audiobooks.count)
                return audiobooks.count
            case "ebook":
                print(ebooks.count)
                return ebooks.count
            case "podcast":
                print(podcasts.count)
                return podcasts.count
        default:
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("CellTable",forIndexPath: indexPath) as! MainTableViewCell
        switch mediaArray[currentCellIndexRow] {
        case "musicVideo":
            cell.mainNameLabel.text = musicvideos[indexPath.row].trackName
            cell.mainArtistLabel.text = musicvideos[indexPath.row].artistName
            self.loadImageFromUrl(musicvideos[indexPath.row].artworkUrl60, view: cell.imageView!)
            
        case "movie":
            cell.mainNameLabel.text = movies[indexPath.row].trackName
            cell.mainArtistLabel.text = movies[indexPath.row].artistName
            self.loadImageFromUrl(movies[indexPath.row].artworkUrl60, view: cell.imageView!)
            
        case "audiobook":
            cell.mainNameLabel.text = audiobooks[indexPath.row].collectionName
            cell.mainArtistLabel.text = audiobooks[indexPath.row].artistName
            self.loadImageFromUrl(audiobooks[indexPath.row].artworkUrl60, view: cell.imageView!)
            
        case "ebook":
            cell.mainNameLabel.text = ebooks[indexPath.row].trackName
            cell.mainArtistLabel.text = ebooks[indexPath.row].artistName
            self.loadImageFromUrl(ebooks[indexPath.row].artworkUrl60, view: cell.imageView!)
            
        case "podcast":
            cell.mainNameLabel.text = podcasts[indexPath.row].trackName
            cell.mainArtistLabel.text = podcasts[indexPath.row].artistName
            self.loadImageFromUrl(podcasts[indexPath.row].artworkUrl60, view: cell.imageView!)
            
        default:
            cell.mainNameLabel.text = "Unknown"
            cell.mainArtistLabel.text = "Unknown"
        }
        
        tableViewIndexPaths.append(indexPath)
        return cell
    }
}
extension ViewController:UITableViewDelegate {
    
}
extension ViewController:SearchManagerDelegate {
    func assignData(ebooks: [Ebook]) {
        self.ebooks=ebooks
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
    func assignData(movies: [Movie]) {
        self.movies=movies
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
    func assignData(podcasts: [Podcast]) {
        self.podcasts=podcasts
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
    func assignData(audiobooks: [Audiobook]) {
        self.audiobooks=audiobooks
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
    func assignData(musicvideos: [Musicvideo]) {
        self.musicvideos=musicvideos
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
}
extension ViewController:UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        SearchManager.shareSearchManager.delegate=self
        print("search \(mediaArray[currentCellIndexRow])")
        SearchManager.shareSearchManager.getDatafromSearchText(self.searchBar, media: mediaArray[currentCellIndexRow])
    }
}
