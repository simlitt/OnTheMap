//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Parabsimran Litt on 1/5/16.
//  Copyright © 2016 Parabsimran Litt. All rights reserved.
//


//TODO:Make Parsed Student information show up on the map
//TODO:Get user data the same way as user location
//TODO: Create Drop a pin feature




import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    
    //Mark:Outlets
    
    @IBOutlet weak var onTheMapMapView: MKMapView!
    
    //Mark:Actions
    
    @IBAction func logoutButton(sender: UIBarButtonItem) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
        }
        task.resume()
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func informationPostingButton(sender: UIBarButtonItem) {
    }
    
    @IBAction func refreshButton(sender: UIBarButtonItem) {
    }
    

    func getUserLocations() {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?limit=5")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            //print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            var parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
                let results = parsedResult.valueForKey("results") as! [[String : AnyObject]]
                print(results)
            } catch {
                parsedResult = nil
                print("Could not parse data as JSON: '\(data)'")
                return
            }
            
        }
        task.resume()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserLocations()
//        
//        
//        var annotations = [MKPointAnnotation]()
//        
//        for dictionary in locations {
//            
//        }
        
    }
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
