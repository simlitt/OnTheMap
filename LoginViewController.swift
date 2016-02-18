//
//  ViewController.swift
//  OnTheMap
//
//  Created by Parabsimran Litt on 1/5/16.
//  Copyright © 2016 Parabsimran Litt. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {
    
    var tapRecognizer: UITapGestureRecognizer? = nil
    var bottomLabelTap: UITapGestureRecognizer? = nil
    
    
    //Mark: Labels
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    //Mark: TextFields
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    //Mark: Actions
    
    @IBAction func loginButton(sender: UIButton) {
        
        let username = emailTextField.text!
        let password = passwordTextField.text!
        
        if (emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty) {
            emailTextField.placeholder = "Email field is empty"
            passwordTextField.placeholder = "Password field is empty"
        } else {
            let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
            request.HTTPMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request) { data, response, error in
                if error != nil { // Handle error…
                    return
                }
                let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
                print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            }
            task.resume()
            performSegueWithIdentifier("LoggedIn", sender: nil)
            
        }
    }

    
    
    //Mark: Show/Hide Keyboard
    
    func addKeyboardDismissRecognizer() {
        self.view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        self.view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y == 0.0 {
            self.view.frame.origin.y -= self.getKeyboardHeight(notification) / 2
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0.0 {
            self.view.frame.origin.y += self.getKeyboardHeight(notification) / 2
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addKeyboardDismissRecognizer()
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeKeyboardDismissRecognizer()
        self.unsubscribeToKeyboardNotifications()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
        bottomLabelTap = UITapGestureRecognizer(target: self, action: "tapFunction:")
        bottomLabel.userInteractionEnabled = true
        bottomLabel.addGestureRecognizer(bottomLabelTap!)
        
    }
    
    func tapFunction(sender:UITapGestureRecognizer) {
        let url = (URL: NSURL(string: "https://www.udacity.com/account/auth#!/signin")!)
        let application:UIApplication = UIApplication.sharedApplication()
        application.openURL(url)
        
    }


}

