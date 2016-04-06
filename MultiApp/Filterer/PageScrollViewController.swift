//
//  PageScrollViewController.swift
//  Filterer
//
//  Created by Preet on 16/03/16.
//  Copyright © 2016 UofT. All rights reserved.
//

import Foundation
import UIKit

class PageScrollViewController: UIViewController,UIScrollViewDelegate{

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    
    var pageImages: [UIImage] = []
    var pageViews: [UIImageView?] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up the image you want to scroll & zoom and add it to the scroll view
        if(NSUserDefaults.standardUserDefaults().objectForKey("username") != nil) {
            let name = NSUserDefaults.standardUserDefaults().objectForKey("username") as! String

            self.navigationItem.title = "Welcome \(name)"
            
        }
        
        pageImages = [UIImage(named:"scenery")!,
            UIImage(named:"scenery1")!,
            UIImage(named:"scenery2")!,
            UIImage(named:"scenery3")!,
            UIImage(named:"scenery4")!]
        
        let pageCount = pageImages.count
        
        // Set up the page control
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageCount
    
        // the array to hold the views for each page
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        // the content size of the scroll view
        self.scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        
        let pagesScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * CGFloat(pageImages.count), pagesScrollViewSize.height)
        
        // Load the initial set of pages that are on screen
        loadVisiblePages()
    
    }
    
    func loadVisiblePages() {
        // First, determine which page is currently visible
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        // Update the page control
        pageControl.currentPage = page
        
        // Work out which pages you want to load
        let firstPage = page - 1
        let lastPage = page + 1
        
        // Load pages in our range
        for var index = firstPage; index <= lastPage; ++index {
            loadPage(index)
        }
        
        // Purge anything after the last page
        for var index = lastPage+1; index < pageImages.count; ++index {
            purgePage(index)
        }
        
    }
    func loadPage(page: Int) {
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        if let _ = pageViews[page] {
            // Do nothing. The view is already loaded.
        } else {
            var frame = scrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            
            let newPageView = UIImageView(image: pageImages[page])
            newPageView.contentMode = .ScaleAspectFit
            newPageView.frame = frame
            scrollView.addSubview(newPageView)
            
            pageViews[page] = newPageView
        }
    }
    func purgePage(page: Int) {
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // Remove a page from the scroll view and reset the container array
        if let pageView = pageViews[page] {
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
    }
    
    // MARK: Scroll View Delegate

    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Load the pages that are now on screen
        loadVisiblePages()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}