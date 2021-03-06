//
//  CardViewController.swift
//  StripeTest
//
//  Created by Jordan Stapinski on 11/15/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import Foundation
import UIKit
import Stripe
import SVProgressHUD

class CardViewController: UIViewController, STPPaymentCardTextFieldDelegate, CardIOPaymentViewControllerDelegate {
    @IBOutlet weak var payButton: UIButton!
    var paymentTextField: STPPaymentCardTextField!
    
    let API = MyAPIClient()
    
    override func viewDidLoad() {
        // add stripe built-in text field to fill card information in the middle of the view
        super.viewDidLoad()
        let frame1 = CGRect(x: 20, y: 150, width: self.view.frame.size.width - 40, height: 40)
        paymentTextField = STPPaymentCardTextField(frame: frame1)
        paymentTextField.center = view.center
        paymentTextField.delegate = self
        view.addSubview(paymentTextField)
        //disable payButton if there is no card information
        payButton.isEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CardIOUtilities.preload()
    }
    
    @IBAction func scanCard(sender: AnyObject) {
        //open cardIO controller to scan the card
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        cardIOVC?.modalPresentationStyle = .formSheet
        present(cardIOVC!, animated: true, completion: nil)
        
    }
    
    
    @IBAction func payButtonTapped(sender: AnyObject) {
        let card = paymentTextField.cardParams
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        //send card information to stripe to get back a token
        self.API.getStripeToken(card: card)
    }
    
    
        
    func paymentCardTextFieldDidChange(textField: STPPaymentCardTextField) {
        if textField.valid{
            payButton.isEnabled = true
        }
    }
    
    //MARK: - CardIO Methods
    
    //Allow user to cancel card scanning
    func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
        print("user canceled")
        paymentViewController?.dismiss(animated: true, completion: nil)
    }
    
    //Callback when card is scanned correctly
    func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
        if let info = cardInfo {
            let str = NSString(format: "Received card info.\n Number: %@\n expiry: %02lu/%lu\n cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv)
            print(str)
            
            //dismiss scanning controller
            paymentViewController?.dismiss(animated: true, completion: nil)
            
            //create Stripe card
            let card: STPCardParams = STPCardParams()
            card.number = info.cardNumber
            card.expMonth = info.expiryMonth
            card.expYear = info.expiryYear
            card.cvc = info.cvv
            
            //Send to Stripe
            self.API.getStripeToken(card: card)
            
        }
    }
}
