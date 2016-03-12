//
//  ViewController.swift
//  notify
//
//  Created by hossein on 3/12/16.
//  Copyright (c) 2016 Ghelich. All rights reserved.
//

import UIKit


class ViewController: UIViewController ,NSURLConnectionDelegate{

    lazy var data = NSMutableData()
    var cont = 0
    
    @IBAction func sendNotify(sender: AnyObject) {
        

            notify("hello world!!")
        
    }
    
    func notify(title : String ){
        var localNotification = UILocalNotification()
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 20)
        localNotification.alertBody = title
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    
    func startConnection(){
        let urlPath: String = "https://api.github.com/users/mralexgray"
        var url: NSURL = NSURL(string: urlPath)!
        var request: NSURLRequest = NSURLRequest(URL: url)
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)!
        connection.start()
    }

    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!){
        self.data.appendData(data)
    }

    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        var err: NSError
        // throwing an error on the line below (can't figure out where the error message is)
       
        
        if let jsonResult: AnyObject = NSJSONSerialization.JSONObjectWithData(data,options:nil,error: nil) {
            if jsonResult is NSDictionary {
                var myDict: NSDictionary = jsonResult as! NSDictionary
                println("myDict:\(myDict)")
                notify("from web " + String(cont))
            }
            else if jsonResult is NSArray {
                var myArray: NSArray = jsonResult as! NSArray
                println("myArray:\(myArray)")
                
            }
        }
        self.data.setData(NSData())
        cont++
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

       
        var Timer = NSTimer.scheduledTimerWithTimeInterval(20, target: self, selector: Selector("startConnection"), userInfo: nil, repeats: true)
        
        
   NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillEnterBackground:", name: UIApplicationDidEnterBackgroundNotification, object: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
      
        
    }
    func applicationWillEnterBackground(notification: NSNotification) {
        
    }
}

