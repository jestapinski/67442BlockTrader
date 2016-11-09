//
//  StripeFlow.swift
//  Stripe iOS Example (Simple)
//
//  Created by Jordan Stapinski on 11/2/16.
//  Copyright © 2016 Stripe. All rights reserved.
//

import Foundation

// Have a button send user to https://connect.stripe.com/oauth/authorize?response_type=code&client_id=ca_9PXNKg1qGaTUMW98lIRFkZyjsRV5cPAo&scope=read_write in safari or something, after which we get back info which we can process in back-end and then go back to app

//Phase 0: Be able to create user accounts
//Some simple form to get info from, for this we can just hardcode and build later
//Phase 1: Go through backend to get user info (stripeID) SAT-SUN
//Only when setting up an account
//Take one of hardcoded users and execute OAuth flow
// Redirect using custom URL scheme http://iosdevelopertips.com/cocoa/launching-your-own-application-via-a-custom-url-scheme.html which will give us the URL we redirect to
//https://gist.github.com/amfeng/2314782
//Also, https://stripe.com/docs/connect/standalone-accounts#token-request to get user_id and auth_code

//Take user info -> Go thru Stripe OAuth Flow -> get back stripeID and Auth_token -> Save to DB --> redirect to "Home screen"

//Phase 2: Save user info to user account (Not hard)
//Phase 3: Process payment

/** Saturday (1-4B) and Sunday (5-8)'s Plan of attack for Phase 1 and 2
 1. Start new project, but use same heroku db or just make a new one or something
 1A. New Heroku Project DONE
    1B. New iOS Project DONE
    1.B.1 Install Stripe Cocoapod DONE
 
 2. Create needed entities DONE
 3. Hardcode a user DONE
 
 4A. Register redirect_uri
    4A1. Switch to safari DONE
    4A2. Switch back DONE
 
 4B. App --> Button which opens OAuth in Safari DONE
 
 5. Fill out OAuth stuff and get info back DONE
 6. Ensure redirect goes back to app DONE
 7. Process redirect using logic and get needed elements saved to DB
 8. Display Home Screen (Allow for custom Redirect URI and use a custom Segue)
 */

/** Phase 3 Plan of Attack
 1. Hardcode two users
 2. Get back their stripe_IDs using phase 1 and 2 and save
 3. Set up charge framework on back end
 4. Initiate charge (from some button or something)
 5. Perform charge
 6. Verify charge worked
 */

class UserManagement {
    /** class UserManagement
     
     class will keep track of handling user operations including
     - Setup
     - Authentication
     - Process Payment (To some other user)
     
     let backendBaseURL: String = "https://stripetest67442.herokuapp.com/"
     
     https://stripe.com/docs/mobile/ios will help with backend
     
     */
    
    /** static func getCustomerFromStripe(button){
     let path = "/customer"
     let url = self.backendBaseURL.appendingPathComponent(path)
     //OPTION 1 - Open in safari
     https://connect.stripe.com/oauth/authorize?response_type=code&client_id=ca_9PXNKg1qGaTUMW98lIRFkZyjsRV5cPAo&scope=read_write
     Fixing the client_id and providing some redirect uri in the back end or something
     
     
     //OPTION 2
     let request = URLRequest.request(url, method: .GET, params: params as [String : AnyObject])
     
     //Basically rewrite the below to get what we want
     let task = self.session.dataTask(with: request) { (data, urlResponse, error) in
     DispatchQueue.main.async {
     let deserializer = STPCustomerDeserializer(data: data, urlResponse: urlResponse, error: error)
     if let error = deserializer.error {
     completion(nil, error)
     return
     } else if let customer = deserializer.customer {
     completion(customer, nil)
     }
     }
     }
     task.resume()
     }
     
     */
    
    /** func registerUser(userInfoDict : [String : AnyObject])
     
     var (auth_code, user_id) = authenticateUser(someCredentials)
     Save info using Jeremy's API
     
     This function will take the user's initial information and save it using the API
     Prior to this function being run, the user will have to have been authenticated using Stripe, as StripeID will be passed in
     
     */
    
    /** func authenticateUser(userInfoDict : [String : AnyObject]) -> (bool, auth_code, user_id)
     
     Perform a GET request based on some actions
     Backend will find the user and convert to JSON (see web.rb)
     
     Handle this through Stripe API for Rails
     
     let request = URLRequest.request(url, method: .GET, params: params as [String : AnyObject])
     
     UNDERSTAND BELOW
     let task = self.session.dataTask(with: request) { (data, urlResponse, error) in
     DispatchQueue.main.async {
     let deserializer = STPCustomerDeserializer(data: data, urlResponse: urlResponse, error: error)
     if let error = deserializer.error {
     completion(nil, error)
     return
     } else if let customer = deserializer.customer {
     completion(customer, nil)
     }
     }
     }
     
     Somehow this will end up with a JSON object
     
     
     */
    
    /** func saveUser(JSONObjectFromAuthenticationAndRegistration)
     
     Saves user to DB using our API
     
     */
    
    /** fun processPayment(StripeIDCustomer, StripeIDProvider, amount)
     
     
     Send to backend for a POST request
     -Will re-authenticate both in post request
     - Set provider as destination, charge from customer
     Send as params hash?
     
     */
}
