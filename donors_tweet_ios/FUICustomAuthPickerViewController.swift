//
//  FUIAuthViewController.swift
//  donors_tweet_ios
//
//  Created by Juan andrés Ferreyra on 9/5/17.
//  Copyright © 2017 shamanito. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseFacebookAuthUI
import FirebaseTwitterAuthUI

let kFirebaseTermsOfService = URL(string: "https://firebase.google.com/terms/")!

enum UISections: Int, RawRepresentable {
    case Settings = 0
    case Providers
    case Name
    case Email
    case UID
    case Phone
    case AccessToken
    case IDToken
}

enum Providers: Int, RawRepresentable {
    case Facebook
    case Twitter
    case Email
}

class FUICustomAuthPickerViewController: UITableViewController {

    fileprivate var authStateDidChangeHandle: AuthStateDidChangeListenerHandle?
    
    fileprivate(set) var auth: Auth? = Auth.auth()
    fileprivate(set) var authUI: FUIAuth? = FUIAuth.defaultAuthUI()
    fileprivate(set) var customAuthUIDelegate: FUIAuthDelegate = FUIAuthDelegate()
    
    @IBOutlet weak var cellSignedIn: UITableViewCell!
    @IBOutlet weak var cellName: UITableViewCell!
    @IBOutlet weak var cellEmail: UITableViewCell!
    @IBOutlet weak var cellUid: UITableViewCell!
    @IBOutlet weak var cellPhone: UITableViewCell!
    @IBOutlet weak var cellAccessToken: UITableViewCell!
    @IBOutlet weak var cellIdToken: UITableViewCell!
    
    @IBOutlet weak var authorizationButton: UIBarButtonItem!
    @IBOutlet weak var customAuthorizationSwitch: UISwitch!
    @IBOutlet weak var customScopesSwitch: UISwitch!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.authUI?.tosurl = kFirebaseTermsOfService

        self.tableView.selectRow(at: IndexPath(row: Providers.Facebook.rawValue, section: UISections.Providers.rawValue),
                                 animated: false,
                                 scrollPosition: .none)
        self.tableView.selectRow(at: IndexPath(row: Providers.Twitter.rawValue, section: UISections.Providers.rawValue),
                                 animated: false,
                                 scrollPosition: .none)
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 240;
        
        self.authStateDidChangeHandle =
            self.auth?.addStateDidChangeListener(self.updateUI(auth:user:))
        
        self.navigationController?.isToolbarHidden = false;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let handle = self.authStateDidChangeHandle {
            self.auth?.removeStateDidChangeListener(handle)
        }
        
        self.navigationController?.isToolbarHidden = true;
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    @IBAction func onAuthorize(_ sender: AnyObject) {
        if (self.auth?.currentUser) != nil {
            do {
                try self.authUI?.signOut()
            } catch let error {
                // Again, fatalError is not a graceful way to handle errors.
                // This error is most likely a network error, so retrying here
                // makes sense.
                fatalError("Could not sign out: \(error)")
            }
            
        } else {
            self.authUI?.delegate = self.customAuthorizationSwitch.isOn ? self.customAuthUIDelegate : nil;
            self.authUI?.isSignInWithEmailHidden = !self.isEmailEnabled()
            
            // If you haven't set up your authentications correctly these buttons
            // will still appear in the UI, but they'll crash the app when tapped.
            self.authUI?.providers = self.getListOfIDPs()
            
                let controller = self.authUI!.authViewController()
                controller.navigationBar.isHidden = self.customAuthorizationSwitch.isOn
                self.present(controller, animated: true, completion: nil)
            
        }
    }
    
    // Boilerplate
    func updateUI(auth: Auth, user: User?) {
        if let user = self.auth?.currentUser {
            self.cellSignedIn.textLabel?.text = "Signed in"
            self.cellName.textLabel?.text = user.displayName ?? "(null)"
            self.cellEmail.textLabel?.text = user.email ?? "(null)"
            self.cellUid.textLabel?.text = user.uid
            self.cellPhone.textLabel?.text = user.phoneNumber
            
            self.authorizationButton.title = "Sign Out";
        } else {
            self.cellSignedIn.textLabel?.text = "Not signed in"
            self.cellName.textLabel?.text = "null"
            self.cellEmail.textLabel?.text = "null"
            self.cellUid.textLabel?.text = "null"
            self.cellPhone.textLabel?.text = "null"
            
            self.authorizationButton.title = "Sign In";
        }
        
        self.cellAccessToken.textLabel?.text = getAllAccessTokens()
        self.cellIdToken.textLabel?.text = getAllIdTokens()
        
        let selectedRows = self.tableView.indexPathsForSelectedRows
        self.tableView.reloadData()
        if let rows = selectedRows {
            for path in rows {
                self.tableView.selectRow(at: path, animated: false, scrollPosition: .none)
            }
        }
    }
    
    func getAllAccessTokens() -> String {
        var result = ""
        for provider in self.authUI!.providers {
            result += (provider.shortName + ": " + provider.accessToken + "\n")
        }
        
        return result
    }
    
    func getAllIdTokens() -> String {
        var result = ""
        for provider in self.authUI!.providers {
            result += (provider.shortName + ": " + (provider.idToken ?? "null")  + "\n")
        }
        
        return result
    }
    
    func getListOfIDPs() -> [FUIAuthProvider] {
        var providers = [FUIAuthProvider]()
        if let selectedRows = self.tableView.indexPathsForSelectedRows {
            for indexPath in selectedRows {
                if indexPath.section == UISections.Providers.rawValue {
                    let provider:FUIAuthProvider?
                    
                    switch indexPath.row {
                   
                    case Providers.Twitter.rawValue:
                        provider = FUITwitterAuth()
                    case Providers.Facebook.rawValue:
                        provider = self.customScopesSwitch.isOn ? FUIFacebookAuth(permissions: ["email",
                                                                                                "user_friends",
                                                                                                "ads_read"])
                            : FUIFacebookAuth()
                    default: provider = nil
                    }
                    
                    guard provider != nil else {
                        continue
                    }
                    
                    providers.append(provider!)
                }
            }
        }
        
        return providers
    }
    
    func isEmailEnabled() -> Bool {
        let selectedRows = self.tableView.indexPathsForSelectedRows
        return selectedRows?.contains(IndexPath(row: Providers.Email.rawValue,
                                                section: UISections.Providers.rawValue)) ?? false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
