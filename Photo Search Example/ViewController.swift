//
//  ViewController.swift
//  Photo Search Example
//
//  Created by Ann Yuan on 4/12/15.
//  Copyright (c) 2015 Ann Yuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        searchInstagramByHashtag("clararockmore")
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        for subview in self.scrollView.subviews {
            subview.removeFromSuperview()
        }
        
        searchBar.resignFirstResponder()
        
        searchInstagramByHashtag(searchBar.text)
    }
    
    func searchInstagramByHashtag(instaHash: String) {
        let instagramURLString = "https://api.instagram.com/v1/tags/\(instaHash)/media/recent?client_id=c8065ff238624bfb9e67871b245f8c33"
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.GET( instagramURLString,
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                //println("JSON: " + responseObject.description)
                if let responseArray = responseObject["data"] as? [AnyObject] {
                    self.processData(responseArray)
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
        })

    }
    
    func processData(data: [AnyObject]) {
        var urlArray:[String] = []
        
        let size = self.view.frame.width
        
        for dataObject in data {
            if let urlString = dataObject.valueForKeyPath("images.standard_resolution.url") as? String {
                urlArray.append(urlString)
            }
        }
        
        scrollView.contentSize = CGSizeMake(size, size * CGFloat(data.count))
        
        for var i = 0; i < urlArray.count; i++ {
            let imageData = NSData(contentsOfURL: NSURL(string: urlArray[i])!)
            
            if let imageDataUnwrapped = imageData {
                let imageView = UIImageView(frame: CGRectMake(0, size * CGFloat(i), size, size))
                imageView.setImageWithURL(NSURL(string: urlArray[i]))
                scrollView.addSubview(imageView)
            }
        }
        
        println(urlArray)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

