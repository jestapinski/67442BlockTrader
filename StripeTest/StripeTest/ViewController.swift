//
//  ViewController.swift
//  StripeTest
//
//  Created by Jordan Stapinski on 11/5/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import UIKit
import CoreData
import Stripe

class ViewController: UIViewController {
    
    var ourUser: User?
    var ourPC: STPPaymentContext?
    @IBOutlet public weak var Label: UILabel?
    
    func swapWindows(accessCode: String, pc: STPPaymentContext){
        self.ourPC = pc
        performSegue(withIdentifier: "OpenMain", sender: accessCode)
        return
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        print("HERE")
        if (segue.identifier == "OpenMain") {
            let secondViewController = segue.destination as? MainViewController
            let userinfo = sender as! String
            secondViewController?.userinfo = userinfo
            self.ourPC?.hostViewController = secondViewController
            secondViewController?.paymentContext = self.ourPC
            print("Userinfo")
            print(userinfo)
            //At this point we can save it to DB, changing segue to only run on setup i.e. once per user
            //secondViewController?.Label!.text! = userinfo
            //print(secondViewController?.Label!.text!)
        }
    }
    
    func getUserBack (appContext: NSManagedObjectContext) -> User? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        //Use objects how we want
        request.returnsObjectsAsFaults = false
        
        do
        {
            let results = try appContext.fetch(request)
            if results.count > 0 {
                for result in results as! [User] {
                    if let fn = result.value(forKey: "username") as? String {
                        return result
                    }
                }
            }
            
        }
        catch
        {
            print("Error in retrieval")
            return nil
        }
        return nil
    }
    
    var baseURL = "http://stripetest67442.herokuapp.com"
//      var baseURL = "localhost:4567"
    
    @IBAction func openStripeSite(sender: AnyObject){
        let authURL = self.baseURL + "/authorize"
        let rdrURL = "smartappbanner://"
        if let requestUrl = NSURL(string: authURL) {
            print(requestUrl)
            UIApplication.shared.openURL(requestUrl as URL)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appContext = appDelegate.persistentContainer.viewContext
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: appContext)
        
        newUser.setValue("jstapins", forKey: "username")
        
        do
        {
            try appContext.save()
            print("SUCCESS")
        }
        catch
        {
            print("ERROR")
        }
        // Do any additional setup after loading the view, typically from a nib.
        self.ourUser = getUserBack(appContext: appContext)
        if let usr = self.ourUser {
            self.Label!.text = usr.username
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

