//
//  MainViewController.swift
//  StripeTest
//
//  Created by Jordan Stapinski on 11/12/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Stripe
import SVProgressHUD

//import CardIO

class MainViewController: UIViewController {
    
//    let paymentContext: STPPaymentContext
    var userinfo: String?
    var ourUser: User?
    var paymentContext: STPPaymentContext?
    @IBOutlet public weak var Label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Label!.text = self.userinfo!
    }
    
    @IBAction func pushUpCardView(sender: AnyObject?){
//        self.paymentContext?.hostViewController = self
        self.paymentContext?.pushPaymentMethodsViewController()
        print("Done Pushing")
        performSegue(withIdentifier: "ToPay", sender: self.Label!.text)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        print("HERE")
        if (segue.identifier == "ToPay") {
//            let secondViewController = segue.destination as? MainViewController
//            let userinfo = sender as! String
//            secondViewController?.userinfo = userinfo
//            self.ourPC?.hostViewController = secondViewController
//            secondViewController?.paymentContext = self.ourPC
//            print("Userinfo")
//            print(userinfo)
            //At this point we can save it to DB, changing segue to only run on setup i.e. once per user
            //secondViewController?.Label!.text! = userinfo
            //print(secondViewController?.Label!.text!)
        }
    }
    
    
}
