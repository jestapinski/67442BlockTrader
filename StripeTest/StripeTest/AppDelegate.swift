//
//  AppDelegate.swift
//  StripeTest
//
//  Created by Jordan Stapinski on 11/5/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import UIKit
import CoreData
import Stripe

fileprivate enum RequiredBillingAddressFields: String {
    case None = "None"
    case Zip = "Zip"
    case Full = "Full"
    
    init(row: Int) {
        switch row {
        case 0: self = .None
        case 1: self = .Zip
        default: self = .Full
        }
    }
    
    var stpBillingAddressFields: STPBillingAddressFields {
        switch self {
        case .None: return .none
        case .Zip: return .zip
        case .Full: return .full
        }
    }
}



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var accessCode: String?
    let stripePublishableKey = "pk_test_BfRm3UU2gsYRebGH6cMuwnl7"
    let appleMerchantID: String? = nil
    fileprivate var requiredBillingAddressFields: RequiredBillingAddressFields = .None
//    let applePay
    
    struct Settings {
        let theme: STPTheme
        let additionalPaymentMethods: STPPaymentMethodType
        let requiredBillingAddressFields: STPBillingAddressFields
        let smsAutofillEnabled: Bool
    }
    
//    let theme = STPTheme()
//    theme.primaryBackgroundColor = UIColor(red:0.16, green:0.23, blue:0.31, alpha:1.00)
//    theme.secondaryBackgroundColor = UIColor(red:0.22, green:0.29, blue:0.38, alpha:1.00)
//    theme.primaryForegroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)
//    theme.secondaryForegroundColor = UIColor(red:0.60, green:0.64, blue:0.71, alpha:1.00)
//    theme.accentColor = UIColor(red:0.98, green:0.80, blue:0.00, alpha:1.00)
//    theme.errorColor = UIColor(red:0.85, green:0.48, blue:0.48, alpha:1.00)
//    theme.font = UIFont(name: "GillSans", size: 17)
//    theme.emphasisFont = UIFont(name: "GillSans", size: 17)
    

    
    var settings: Settings {
        let theme = STPTheme()
        theme.primaryBackgroundColor = UIColor(red:0.16, green:0.23, blue:0.31, alpha:1.00)
        theme.secondaryBackgroundColor = UIColor(red:0.22, green:0.29, blue:0.38, alpha:1.00)
        theme.primaryForegroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)
        theme.secondaryForegroundColor = UIColor(red:0.60, green:0.64, blue:0.71, alpha:1.00)
        theme.accentColor = UIColor(red:0.98, green:0.80, blue:0.00, alpha:1.00)
        theme.errorColor = UIColor(red:0.85, green:0.48, blue:0.48, alpha:1.00)
        theme.font = UIFont(name: "GillSans", size: 17)
        theme.emphasisFont = UIFont(name: "GillSans", size: 17)
            return Settings(theme: theme,
                            additionalPaymentMethods: false ? .all : STPPaymentMethodType(),
                            requiredBillingAddressFields: self.requiredBillingAddressFields.stpBillingAddressFields,
                            smsAutofillEnabled: false)
        }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        print(url.host as String!)
        print("New Hope")
        //TODO fix Below
        self.accessCode = (url.host as String!)
        if let code = self.accessCode {
            print(code)
        }
        let config = STPPaymentConfiguration.shared()
        config.publishableKey = self.stripePublishableKey
        config.appleMerchantIdentifier = self.appleMerchantID
        //config.companyName = self.companyName
        config.requiredBillingAddressFields = settings.requiredBillingAddressFields
        config.additionalPaymentMethods = settings.additionalPaymentMethods
        config.smsAutofillDisabled = !settings.smsAutofillEnabled
        
        let paymentContext = STPPaymentContext(apiAdapter: MyAPIClient.sharedClient,
                                               configuration: config,
                                               theme: settings.theme)
        let rootVC = self.window!.rootViewController! as! ViewController
        rootVC.swapWindows(accessCode: self.accessCode!, pc: paymentContext)
        
        //print(self.accessCode)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "MainPage") as MainViewController
//        self.window?.pushViewController(mainVC, animated: true)
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        STPPaymentConfiguration.shared().publishableKey = "pk_test_BfRm3UU2gsYRebGH6cMuwnl7"
        // Override point for customization after application launch.
        print("Publ APP")
        return true
    }



    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("Entering foreground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "StripeTest")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

