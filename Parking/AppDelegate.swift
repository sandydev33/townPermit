//
//  AppDelegate.swift
//  Parking
//
//  Created by khim singh on 29/08/17.
//  Copyright © 2017 eSoft. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import Firebase
import GoogleSignIn
import MBProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,GIDSignInDelegate{

    var window: UIWindow?
    var globalIndicator:MBProgressHUD?=nil
    var ResultView:String? = nil
    var regist:RegisterViewController? = nil
    var action:String? = nil
    

        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
           
            //TODO: - Enter your credentials
            PayPalMobile .initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: "AV8Nf4Ry-74d9YhchXJvAp9wBficICv6HE7IceTafqVQxXohy36phuwUMPlX4TC2ssgFerL9IoXcIWnN",
                                                                    PayPalEnvironmentSandbox: "esoft4usr2-facilitator@gmail.com"])
        let result = UserDefaults.standard.string(forKey:"dict")
        if result != nil{
          
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let objMainViewController: DashboardViewController = mainStoryboard.instantiateViewController(withIdentifier: "dash") as! DashboardViewController
                let nav = UINavigationController(rootViewController: objMainViewController)
                nav.isNavigationBarHidden = true
                
                self.window?.rootViewController = nav
                
                self.window?.makeKeyAndVisible()
            
        }
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self as GIDSignInDelegate
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let socialType = Preferences.getDataFromPreferences(nameOfPreference: GLobalKeys.socialLoginType, data: {_ in})
        if socialType! == "facebook"{
            guard let source = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String else { return false }
            let annotation = options[UIApplicationOpenURLOptionsKey.annotation] as? String
            return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: source, annotation: annotation)
        }
        else if socialType! == "google"{
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
        }
        
        return false
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let _ = user{
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            let url = user.profile.imageURL(withDimension: 100)
            let profileData = ["userID":userId!,"tokenId":idToken!,"fullName":fullName!,"givenName":givenName!,"familyName":familyName!,"email":email!]
            Preferences.saveDataToPreferences(nameOfPreference: GLobalKeys.userGoogleData, data: profileData)
            action = "3"
            let dic = ["apikey":apiKey,
                       "password":userId!,
                       "email":email!,
                       "name":fullName!,
                       "social_login_type":"gplus",
                       "action":(self.action)!
            ]
            self.regist?.socialLoginWebServices(dic: dic)
                    }
        if error != nil {
            // ...
            self.globalIndicator?.hide(animated: true)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // ...
        Auth.auth().signIn(with: credential) { (user, error) in
            // ...
            if error != nil {
                // ...
                return
            }
        }
        //globalIndicator.MBProgressHUD.hide(for: (self.window?.rootViewController?.view)!, animated: true)
        self.globalIndicator?.hide(animated: true)
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
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
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

