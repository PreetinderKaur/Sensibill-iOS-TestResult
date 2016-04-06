//
//  FiltererViewController.swift
//  Filterer
//
//  Created by Preet on 16/03/16.
//  Copyright © 2016 UofT. All rights reserved.
//

import Foundation
import UIKit

class FiltererViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let animationDuration = 0.4
    let alphaColor: CGFloat = 0.3
    var filteredImage: UIImage?
    var originalImage: UIImage?
    var image: UIImage?
    var sliderValue : Bool = false
    @IBOutlet var filteredImageView: UIImageView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var sliderView: UIView!
    
    @IBOutlet var menuCollectionView: UICollectionView!
    @IBOutlet var bottomMenu: UIView!
    @IBOutlet var originalTxtLabel: UILabel!
    
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var compareButton: UIButton!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var slider: UISlider!
    
    var isShowOriginal = true
    var currentIndex = 0
    var filterSelected = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(NSUserDefaults.standardUserDefaults().objectForKey("username") != nil) {
            let name = NSUserDefaults.standardUserDefaults().objectForKey("username") as! String
            
            self.navigationItem.title = "Welcome \(name)"
            
        }

        originalTxtLabel.hidden = true
        
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        originalImage = imageView.image
        initButtons()
        
    }
    
    func initButtons() {
        image = imageView.image
        compareButton.enabled = false
        editButton.enabled = false
        filterButton.selected = false
        
    }
    // MARK: Share image
    @IBAction func onShare(sender: AnyObject) {
        
        if (self.secondaryMenu.isDescendantOfView(self.view) || self.sliderView.isDescendantOfView(self.view)){
            hideSecondaryMenu()
            hideSlider()
            if(compareButton.selected){
                sliderValue = false
                compareButton.selected = !compareButton.selected
            }
        }
        if(filteredImageView.image != nil){
            let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", filteredImageView.image!], applicationActivities: nil)
            presentViewController(activityController, animated: true, completion: nil)
        }else{
            let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", imageView.image!], applicationActivities: nil)
            presentViewController(activityController, animated: true, completion: nil)
        }
    }
    
    // MARK: Select New Photo from Camera and Album
    @IBAction func onNewPhoto(sender: AnyObject) {
        if (self.secondaryMenu.isDescendantOfView(self.view) || self.sliderView.isDescendantOfView(self.view)){
            hideSecondaryMenu()
            hideSlider()
        }
        
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            originalImage = image
            editButton.selected = false
            compareButton.enabled = false
            editButton.enabled = false
            
            //            filteredImageView.image = image
            self.imageView.alpha = 1.0
            self.filteredImageView.alpha = 0.0
            if(filterButton.selected){
                filterSelected = true
            }else{
                filterSelected = false
            }
            menuCollectionView.reloadData()
            
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (compareButton.enabled) {
            if (compareButton.selected){
                UIView.animateWithDuration(animationDuration) {
                    self.imageView.alpha = 1.0
                    self.filteredImageView.alpha = 0.0
                    self.originalTxtLabel.hidden = false
                }
                
            }else{
                UIView.animateWithDuration(animationDuration) {
                    self.imageView.alpha = 0.0
                    self.filteredImageView.alpha = 1.0
                    self.originalTxtLabel.hidden = true
                }
            }
            
        }
        
        super.touchesEnded(touches, withEvent: event)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (compareButton.enabled) {
            if (compareButton.selected){
                UIView.animateWithDuration(animationDuration) {
                    self.imageView.alpha = 0.0
                    self.filteredImageView.alpha = 1.0
                    self.originalTxtLabel.hidden = true
                }
            }else{
                UIView.animateWithDuration(animationDuration) {
                    self.imageView.alpha = 1.0
                    self.filteredImageView.alpha = 0.0
                    self.originalTxtLabel.hidden = false
                }
            }
            
        }
        
        super.touchesBegan(touches, withEvent: event)
    }
    
    
    // MARK: Show Filter Menu
    @IBAction func onFilter(sender: UIButton) {
        if (!filterSelected){
            sender.selected = !sender.selected
        }
        if (sender.selected) {
            if editButton.selected {
                editButton.selected = false
                hideSlider()
            }
            showSecondaryMenu()
            filterSelected = false
        } else {
            hideSecondaryMenu()
        }
    }
    
    func showSecondaryMenu() {
        
        view.addSubview(secondaryMenu)
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        let heightConstraint = secondaryMenu.heightAnchor.constraintEqualToConstant(60)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0
        UIView.animateWithDuration(animationDuration) {
            self.secondaryMenu.alpha = 1.0
            
        }
        
        
    }
    
    func hideSecondaryMenu(useAnimation: Bool = true) {
        if useAnimation {
            UIView.animateWithDuration(animationDuration, animations: {
                self.secondaryMenu.alpha = 0
                }) { completed in
                    if completed == true {
                        self.secondaryMenu.removeFromSuperview()
                    }
            }
        } else {
            self.secondaryMenu.removeFromSuperview()
        }
    }
    //6. Add an Edit button.
    
    // MARK: Edit image
    func isSlider(index: Int) -> Bool {
        switch index{
        case 3...4:     return false
        default: return true
        }
    }
    //MARK: Edit button.
    
    @IBAction func onEdit(sender: UIButton) {
        originalTxtLabel.hidden = true
        compareButton.selected = false
        self.imageView.alpha = 0.0
        self.filteredImageView.alpha = 1.0
        if isSlider(currentIndex) {
            editButton.selected = !editButton.selected
            if editButton.selected {
                if filterButton.selected {
                    filterButton.selected = false
                    hideSecondaryMenu()
                }
                showSlider()
            } else {
                hideSlider()
            }
        }
        
    }
    
    func showSlider() {
        self.view.addSubview(sliderView)
        sliderView.tintColor = UIColor.blueColor()
        let bottomConstraint = sliderView.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = sliderView.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = sliderView.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        let heightConstraint = sliderView.heightAnchor.constraintEqualToConstant(55)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.sliderView.alpha = 0
        UIView.animateWithDuration(animationDuration) {
            self.sliderView.alpha = 1.0
        }
    }
    func hideSlider(useAnimation: Bool = true) {
        if useAnimation {
            UIView.animateWithDuration(animationDuration, animations: {
                self.sliderView.alpha = 0
                }) { completed in
                    if completed == true {
                        self.sliderView.removeFromSuperview()
                    }
            }
        } else {
            self.sliderView.removeFromSuperview()
        }
    }
    
    
    //    func getImage(index: Int) -> String {
    //        switch index{
    //        case 0...6: return "Paint"
    //        default: return "Brush"
    //        }
    //    }
    func getColor(index: Int) -> UIColor {
        switch index{
        case 0:     return UIColor.redColor().colorWithAlphaComponent(alphaColor)
        case 1:     return UIColor.greenColor().colorWithAlphaComponent(alphaColor)
        case 2:     return UIColor.blueColor().colorWithAlphaComponent(alphaColor)
            
        case 3:     return UIColor.blackColor().colorWithAlphaComponent(alphaColor)
        case 4:     return UIColor.orangeColor().colorWithAlphaComponent(alphaColor)
        case 5:     return UIColor.yellowColor().colorWithAlphaComponent(alphaColor)
            
            
        default: return UIColor.whiteColor().colorWithAlphaComponent(alphaColor)
        }
    }
    
    func applyFilterWithNumber(index: Int){
        
        let raw = ImageFilter(image: imageView.image!)
        switch index {
        case 0:
            let value = slider.value
            raw.applyFilter(.Red(value))
            filteredImageView.image = raw.image
        case 1:
            let value = slider.value
            raw.applyFilter(.Green(value))
            filteredImageView.image = raw.image
        case 2:
            let value = slider.value
            raw.applyFilter(.Blue(value))
            filteredImageView.image = raw.image
        case 3:
            raw.applyFilter(.GreyScale)
            filteredImageView.image = raw.image
        case 4:
            raw.applyFilter(.Sepia)
            filteredImageView.image = raw.image
        case 5:
            let value = slider.value * (5 - 0.2) + 0.2
            raw.applyFilter(.Brightness(value))
            filteredImageView.image = raw.image
        case 6:
            let value = slider.value * (256) - 128
            raw.applyFilter(.Contrast(value))
            filteredImageView.image = raw.image
            
        default: break
            
        }
        filteredImage = filteredImageView.image
        compareButton.enabled = true
        changeView(false)
    }
    //●	After the user adjusts the slider, the image should be updated with the new filter intensity.
    
    
    @IBAction func sliderValueChanged(sender: AnyObject) {
        applyFilterWithNumber(currentIndex)
    }
    
    //2. When a user taps the compare button, the image view should show the original image. When they tap the button again, show the filtered image.
    
    // MARK: Compare image
    
    @IBAction func onCompare(sender: UIButton) {
        hideSlider()
        hideSecondaryMenu()
        filterButton.selected = false
        editButton.selected = false
        
        if (sender.selected){
            sender.selected = false
            self.imageView.alpha = 0.0
            self.filteredImageView.alpha = 1.0
            originalTxtLabel.hidden = true
            
        }else{
            self.imageView.alpha = 1.0
            self.filteredImageView.alpha = 0.0
            originalTxtLabel.hidden = false
            sender.selected = true
        }
        
    }
    
    //4. Cross-fade images when a user selects a new filter or uses the compare function.
    
    func changeView(isShowOriginal: Bool){
        if isShowOriginal{
            UIView.animateWithDuration(animationDuration) {
                self.imageView.alpha = 1.0
                self.filteredImageView.alpha = 0.0
                self.originalTxtLabel.hidden=false
            }
            
        } else {
            UIView.animateWithDuration(animationDuration) {
                self.imageView.alpha = 0.0
                self.filteredImageView.alpha = 1.0
                self.originalTxtLabel.hidden=true
            }
        }
    }
    
}
// MARK: - UICollectionViewDataSource

extension FiltererViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 7;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCellWithReuseIdentifier("CELL", forIndexPath: indexPath) as! MyCell
        //        let image = UIImage(named: getImage(indexPath.row))
        
        //  5. Use images instead of text for the filter buttons.
        
        let temp = ImageFilter(image: imageView.image!)
        let index = indexPath.row
        switch index{
        case 0:
            let value = slider.value
            temp.applyFilter(.Red(value))
            cell.imageView.image = temp.image
        case 1:
            let value = slider.value
            temp.applyFilter(.Green(value))
            cell.imageView.image = temp.image
        case 2:
            let value = slider.value
            temp.applyFilter(.Blue(value))
            cell.imageView.image = temp.image
        case 3:
            temp.applyFilter(.GreyScale)
            cell.imageView.image = temp.image
        case 4:
            temp.applyFilter(.Sepia)
            cell.imageView.image = temp.image
        case 5:
            let value = slider.value * (5 - 0.2) + 0.2
            temp.applyFilter(.Brightness(value))
            cell.imageView.image = temp.image
        case 6:
            let value = slider.value * (256) - 128
            temp.applyFilter(.Contrast(value))
            cell.imageView.image = temp.image
            
        default: break
        }
        
        //        cell.backgroundColor = getColor(indexPath.row)
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
}

// MARK: - UICollectionViewDelegate

extension FiltererViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        currentIndex = indexPath.row
        editButton.enabled = isSlider(currentIndex)
        applyFilterWithNumber(currentIndex)
    }
    
    
}
