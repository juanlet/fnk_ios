//
//  Copyright (c) 2016 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
import UIKit
import FirebaseAuthUI
import FirebaseAuth

class FUICustomAuthDelegate: NSObject, FUIAuthDelegate {
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        guard let authError = error else { return }
        
        let errorCode = UInt((authError as NSError).code)
        
        switch errorCode {
        case FUIAuthErrorCode.userCancelledSignIn.rawValue:
            print("User cancelled sign-in");
            break
        default:
            let detailedError = (authError as NSError).userInfo[NSUnderlyingErrorKey] ?? authError
            print("Login error: \((detailedError as! NSError).localizedDescription)");
        }
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        return FUICustomAuthPickerViewController(nibName: "FUICustomAuthPickerViewController",
                                                 bundle: Bundle.main,
                                                 authUI: authUI)
    }
    
  /*  func emailEntryViewController(forAuthUI authUI: FUIAuth) -> FUIEmailEntryViewController {
        return FUICustomEmailEntryViewController(nibName: "FUICustomEmailEntryViewController",
                                                 bundle: Bundle.main,
                                                 authUI: authUI)
    }
    */
}
