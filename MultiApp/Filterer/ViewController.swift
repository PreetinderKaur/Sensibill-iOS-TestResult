//
//  ViewController.swift
//  Filterer
//
//  Created by Preet on 2016-03-6.


import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    
    var tableArray: [String] = []
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
       
        let loginButton : UIBarButtonItem = UIBarButtonItem(title: "Login", style: UIBarButtonItemStyle.Plain, target: self, action:Selector("showAlert"))
        self.navigationItem.rightBarButtonItem = loginButton

        tableArray = ["Image Processing App", "Image Gallery App","Play Image App"]
    }
    //Login functionality: username will be saved for application session using NSUserDefault
    
    func showAlert(){
        var loginTextField: UITextField!

        let alert = UIAlertController(title: "Login", message: "", preferredStyle:
            UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            loginTextField = textField
            loginTextField.placeholder = "Enter username"
            loginTextField.delegate = self

        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))

        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
            // Save username to NSUserDefault
            
            NSUserDefaults.standardUserDefaults().setObject(loginTextField.text, forKey: "username");
            NSUserDefaults.standardUserDefaults().synchronize();
        }))
        presentViewController(alert, animated: true, completion: nil)

    }
   
    // MARK: -
    // MARK: Table View DataSource Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        
        cell.textLabel?.text = tableArray[indexPath.row]

        return cell

    }
    // MARK: -
    // MARK: Table View Delegate Methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Check if username saved in NSUserDefault then it will go to next screen
        
        if(NSUserDefaults.standardUserDefaults().objectForKey("username") != nil) {
            print("name")
            
            if indexPath.row == 0{
                self.performSegueWithIdentifier("ShowFilterApp", sender: self)
            }else if indexPath.row == 1{
                    self.performSegueWithIdentifier("imageScroll", sender: self)
            }else if indexPath.row == 2{
                self.performSegueWithIdentifier("playImage", sender: self)
                
            }

        }else{
            let alertController = UIAlertController(title: "Alert", message:
                "Please login with Name", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        

    }
    
    // MARK: -
    // MARK: TextField Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }

}