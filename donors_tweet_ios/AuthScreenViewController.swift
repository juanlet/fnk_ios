//
//  AuthScreenViewController.swift
//  donors_tweet_ios
//
//  Created by Juan andrés Ferreyra on 9/7/17.
//  Copyright © 2017 shamanito. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import TwitterKit

class AuthScreenViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    var preferences = UserDefaults.standard

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true


        // Do any additional setup after loading the view.
        //check if user is logged in
        Auth.auth().addStateDidChangeListener() { auth, user in
            // 2
            if user != nil {
                // 3
                self.redirectUserToMain()
            }
        }
        
        self.setupFacebookButtons()
        
        self.setupTwitterButton()
    }
    
    //=========
    // Twitter Methods
    //=========
    
    fileprivate func setupTwitterButton(){
        
        let twitterButton = TWTRLogInButton {(session, error) in
            
            if (session != nil) {
                print("signed in as \(session?.userName ?? "")");
                //log in with Firebase
                
                let client = TWTRAPIClient.withCurrentUser()
                let twitterId = session?.userID
                
                //get user email to insert it into firebase
                client.requestEmail { email, error in
                    if (//email != nil  activate once the app is whitelisted to get emails providing terms and conditions to twitter
                        true) {
                        print("signed in as \(email ?? "")");
                        
                        
                        //get the token and the user's secret from twitter's login response
                        guard let token = session?.authToken else { return }
                        guard let secret = session?.authTokenSecret else { return }
                        
                        let credentials = TwitterAuthProvider.credential(withToken: token, secret: secret)
                        //create firebase user
                        Auth.auth().signIn(with: credentials, completion: { (user, error) in
                            
                            if let err = error {
                                print("Failed to login to Firebase with Twitter: ", err)
                                return
                            }
                            
                            print("Successfully created a Firebase-Twitter user: ",user?.uid ?? "")
                            
                            //update user email
                            
                          //  Auth.auth().currentUser?.updateEmail(to: email!) { (error) in
                            Auth.auth().currentUser?.updateEmail(to: "claudiomiguelespanto@gmail.com") { (error) in
                                if let err = error {
                                    print("Failed to update user email", err)
                                    return
                                }
                                
                                
                                
                                print("Email updated successfully to ",email ?? "")
                                
                                let firebaseId = Auth.auth().currentUser?.uid
                                
                                //saving to user defaults
                                self.saveToUserDefaults(firebaseId!, socialNetwork: "TWITTER", socialNetworkId: twitterId!)
                                
                                self.redirectUserToMain()
                                
                            }
                        })
                        
                        
                    } else {
                        print("error: \(error?.localizedDescription ?? "")");
                    }
                }
                
                
            } else {
                print("error: \(error?.localizedDescription ?? "")");
            }
        }
        
        view.addSubview(twitterButton)
        
        twitterButton.frame = CGRect(x: 16, y: 50 + 66, width: view.frame.width-32, height: 50)
        
    }
    
    //===========================
    //FACEBOOK AUTH METHODS
    //===========================
    
    fileprivate func setupFacebookButtons(){
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
        customFBButton.setTitleColor(.white, for: .normal)
        view.addSubview(customFBButton)
        //listener for touch events for this button
        customFBButton.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
        
    }
    
    func handleCustomFBLogin(){
        FBSDKLoginManager().logIn(withReadPermissions: ["email","public_profile"]
        , from: self) { (result, err) in
            if err != nil{
                print("Custom FB Login Failed:",err ?? "")
                return
            }
            
            print(result?.token.tokenString ?? "")
            self.showEmailAddress()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        self.logOutFirebaseFacebook()
        print("Did Log Out Of Facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil{
            print(error)
            return
        }
        
        print("Successfully logged in with facebook")
        
        self.showEmailAddress()
    }
    
    func showEmailAddress(){
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id,name,email"]).start { (connection, result, err) in
            
            if err != nil {
                print("Failed to start Graph Request:",err ?? "")
                return
            }
            
            self.createFacebookFirebaseUser();
            
            print(result ?? "")
        }
    }
    
    func createFacebookFirebaseUser(){
        let accesstToken = FBSDKAccessToken.current()
        guard let accessTokenString = accesstToken?.tokenString else { return }
        let credential = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        let facebookId = FBSDKAccessToken.current().userID!

        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                // ...
                print("Error with Facebook firebase login",error ?? "Default Error Message")
                return
            }
            // User is signed in
            // ...
            print("User is logged in", user ?? "")
            
            let firebaseId = Auth.auth().currentUser?.uid
            
            self.saveToUserDefaults(firebaseId!, socialNetwork: "FACEBOOK", socialNetworkId: facebookId)
            
            self.redirectUserToMain()
        }
    }
    //logs the user out of firebase
    func logOutFirebaseFacebook(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func redirectUserToMain(){
        //user is logged in, redirect to main View
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainTabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
         self.navigationController?.pushViewController(mainTabBarController, animated: true)
   }
    
    func saveToUserDefaults(_ firebaseId: String,socialNetwork: String,socialNetworkId: String){

        preferences.set( firebaseId,forKey: Config.Global._firebaseIdUserDefaults)
        
        CurrentUserUtil.firebaseId = firebaseId
        
        if socialNetwork == "TWITTER" {
        
            preferences.set(socialNetworkId , forKey: Config.Global._twitterIdUserDefaults)
        
        CurrentUserUtil.twitterId = socialNetworkId
        
        } else if socialNetworkId == "FACEBOOK"{
            preferences.set(socialNetworkId , forKey: Config.Global._facebookIdUserDefaults)
         CurrentUserUtil.facebookId = socialNetworkId
        }
        
        //FOR DEBUGGING TO PRINT ALL THE CONTENT OF USER DEFAULTS TO SEE IF THE KEYS WERE SAVED CORRECTLY TO RECOVER THEM ON THE MAIN VIEW CONTROLLER
        
        
//        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
//            print("\(key) = \(value) \n")
//        }
        
        return

    }
}
