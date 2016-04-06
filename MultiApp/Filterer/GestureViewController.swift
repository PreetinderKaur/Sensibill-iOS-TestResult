//
//  GestureViewController.swift
//  Filterer
//
//  Created by Preet on 18/03/16.
//  Copyright © 2016 UofT. All rights reserved.
//

import Foundation
import UIKit

class GestureViewController: UIViewController,UIScrollViewDelegate{

    @IBOutlet var scrollView: UIScrollView!
    var imageView: UIImageView!
    var containerView: UIView!


     override func viewDidLoad() {
        self.scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)

        if(NSUserDefaults.standardUserDefaults().objectForKey("username") != nil) {
            let name = NSUserDefaults.standardUserDefaults().objectForKey("username") as! String
            
            self.navigationItem.title = "Welcome \(name)"
            
        }
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let upSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let downSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))


        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        upSwipe.direction = .Up
        downSwipe.direction = .Down
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        view.addGestureRecognizer(upSwipe)
        view.addGestureRecognizer(downSwipe)

        
        let image = UIImage(named: "scenery3")!
        imageView = UIImageView(image: image)
        imageView.frame = CGRect(origin: CGPointMake(0.0, 0.0), size:image.size)
        scrollView.addSubview(imageView)
        scrollView.contentSize = image.size

        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight);
        scrollView.minimumZoomScale = minScale;
        
        scrollView.maximumZoomScale = 1.0
        scrollView.zoomScale = minScale;
        
        centerScrollViewContents()
        //Tap Gesture Recognisation
        let tapOnce = UITapGestureRecognizer(target: self, action: Selector("tapOnce:"))
        let tapTwice = UITapGestureRecognizer(target: self, action: Selector("tapTwice:"))
        
        // set number of taps required
        tapOnce.numberOfTapsRequired = 1
        tapTwice.numberOfTapsRequired = 2
        
        // stops tapOnce from overriding tapTwice
        tapOnce.requireGestureRecognizerToFail(tapTwice)
        
        // now add the gesture recogniser to a view
        // this will be the view that recognises the gesture
        view.addGestureRecognizer(tapOnce)
        view.addGestureRecognizer(tapTwice)
        
        
        //For PinchGesture Recoginzation

        let pinchGesture: UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: Selector("recognizePinchGesture:"))
        imageView.addGestureRecognizer(pinchGesture)
    }
    //Mark : Tap Gesture Zoom In/Out
    
    func tapOnce(sender: UITapGestureRecognizer){
    //on a single  tap, zoomOut in UIScrollView
        scrollView.setZoomScale(0.0, animated:true)

    }
    func tapTwice(sender: UITapGestureRecognizer){
        //on a double tap,  zoomIn in UIScrollView
        scrollView.setZoomScale(1.0, animated: true)

    }
    
    func centerScrollViewContents() {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        imageView.frame = contentsFrame
        
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        centerScrollViewContents()
    }

    
    // Mark: PinchGesture Zoom In/Out
    func recognizePinchGesture(sender: UIPinchGestureRecognizer)
    {
        sender.view!.transform = CGAffineTransformScale(sender.view!.transform,
            sender.scale, sender.scale)
        sender.scale = 1
    }
    
    //swipe image
 
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Left) {
            print("Swipe Left")
            let labelPosition = CGPointMake(self.imageView.frame.origin.x - 50.0, self.imageView.frame.origin.y);
            imageView.frame = CGRectMake( labelPosition.x , labelPosition.y , self.imageView.frame.size.width, self.imageView.frame.size.height)
        }
        
        if (sender.direction == .Right) {
            print("Swipe Right")
            let labelPosition = CGPointMake(self.imageView.frame.origin.x + 50.0, self.imageView.frame.origin.y);
            imageView.frame = CGRectMake( labelPosition.x , labelPosition.y , self.imageView.frame.size.width, self.imageView.frame.size.height)
        }
        if (sender.direction == .Up) {
            print("Up")
            let labelPosition = CGPointMake(self.imageView.frame.origin.x , self.imageView.frame.origin.y-50);
            imageView.frame = CGRectMake( labelPosition.x , labelPosition.y , self.imageView.frame.size.width, self.imageView.frame.size.height)
        }
        if (sender.direction == .Down) {
            print("Down")
            let labelPosition = CGPointMake(self.imageView.frame.origin.x , self.imageView.frame.origin.y+50);
            imageView.frame = CGRectMake( labelPosition.x , labelPosition.y , self.imageView.frame.size.width, self.imageView.frame.size.height)
        }
    }

}
