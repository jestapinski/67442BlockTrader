//
//  ViewController.swift
//  FBLogin
//
//  Created by Jeremy Lee on 11/22/16.
//  Copyright © 2016 Jeremy Lee. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore


class ViewController: UIViewController {
    
    var dict : [String : AnyObject]!
    @IBOutlet weak var welcomename: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email ])
        loginButton.center = view.center
        
        view.addSubview(loginButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let accessToken = AccessToken.current{
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "loggedin") as UIViewController
            self.present(vc, animated: true, completion: nil)
            
            print("accesstoken: \(accessToken.authenticationToken)")
            let params = ["fields" : "email, name, id"]
            let graphRequest = GraphRequest(graphPath: "me", parameters: params)
            graphRequest.start {
                (urlResponse, requestResult) in
                
                switch requestResult {
                case .failed(let error):
                    print("error in graph request:", error)
                    break
                case .success(let graphResponse):
                    if let responseDictionary = graphResponse.dictionaryValue {
                        print(responseDictionary)


                        //print("\(type(of: test))")
                        //print(String(test)!)
                        
                        var request = URLRequest(url: URL(string: "http://germy.tk:3000/api/signin")!)
                        request.httpMethod = "POST"
                        let postString = "name=\(responseDictionary["name"]!)&email=\(responseDictionary["email"]!)&fb_id=\(responseDictionary["id"]!)&accessToken=\(accessToken.authenticationToken)"
                        request.httpBody = postString.data(using: .utf8)
                        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                                print("error=\(error)")
                                return
                            }
                            
                            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                                print("response = \(response)")
                            }

                            do{
                                
                                let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
                                print("responseString = \(jsonResult!["api_authtoken"]!)")
                                self.welcome_name.text = jsonResult!["api_authtoken"]! as? String
                            }catch{
                                print("issue")
                            }
                            
                        }
                        task.resume()
                    }
                }
            }
        }
    
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   
}

