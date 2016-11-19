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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
