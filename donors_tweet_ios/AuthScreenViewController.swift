//
//  AuthScreenViewController.swift
//  donors_tweet_ios
//
//  Created by Juan andrés Ferreyra on 9/7/17.
//  Copyright © 2017 shamanito. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class AuthScreenViewController: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let fbLoginButton = FBSDKLoginButton()
        
        view.addSubview(fbLoginButton)
        //usar constraints
        
        //FB DEFAULT BUTTON
        fbLoginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width-32, height: 50)
        
        fbLoginButton.delegate = self
        fbLoginButton.readPermissions = ["email","public_profile"]
        
        //FB CUSTOM BUTTON
        
        let customFBButton = UIButton(type: .system)
     customFBButton.backgroundColor = .blue
     customFBButton.frame = CGRect(x: 16, y: 116, width: view.frame.width-32, height: 50)
     customFBButton.setTitle("Facebook Custom Button", for: .normal)
     customFBButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
     view.addSubview(customFBButton)
        //listener for touch events for this button
        customFBButton.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
        
    }
    
    func handleCustomFBLogin(){
        print(1234)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did Log Out Of Facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil{
            print(error)
            return
        }
        
        print("Successfully logged in with facebook")
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id,name,email"]).start { (connection, result, err) in
            
            if err != nil {
                print("Failed to start Graph Request:",err ?? "")
                return
            }
            
            
            
            print(result ?? "")
        }
        
    }
    


}
