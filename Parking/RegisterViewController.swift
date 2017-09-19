//
//  RegisterViewController.swift
//  Parking
//
//  Created by khim singh on 29/08/17.
//  Copyright © 2017 eSoft. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn
import MBProgressHUD
import SwiftyJSON
import Alamofire

class RegisterViewController: UIViewController,UITextFieldDelegate,GIDSignInUIDelegate {
    @IBOutlet weak var mobileNoTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    @IBOutlet weak var registerNewBtns: UIButton!
    
    var  json:JSON = []
    var custmerId:String? = nil
    var action:String? = nil
    var registerString:String = "Login"
    var faceData:JSON = []
    @IBOutlet weak var bottomRegisterView: UIView!
    @IBOutlet weak var topLoginView: UIView!
        override func viewDidLoad() {
        super.viewDidLoad()
        mobileNoTextField.autocorrectionType = .no
        emailTextField.autocorrectionType = .no
         GIDSignIn.sharedInstance().uiDelegate = self
        //self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        mobileNoTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        userNameTextField.resignFirstResponder()
        loginPasswordTextField.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if textField == mobileNoTextField {
            
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return ((string == numberFiltered) && ((textString.characters.count) <= 10))
        }
            
   
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        animateViewMoving(true, moveValue: 150)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        animateViewMoving(false, moveValue: 150)
    }
    
    func animateViewMoving (_ up:Bool, moveValue :CGFloat)
    {
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        
        let keyboardDoneButtonView = UIToolbar.init()
        keyboardDoneButtonView.sizeToFit()
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.done,
                                              target: self,
                                              action: #selector(RegisterViewController.doneClicked(_:)))
        
        keyboardDoneButtonView.items = [flexBarButton,doneButton]
        textField.inputAccessoryView = keyboardDoneButtonView
        
        return true
    }
    func doneClicked(_ sender: AnyObject) {
        self.view.endEditing(true)
        // Add the phone number to facebook data stored in user preferences
   
    }
    
    func performFaceBookLogin(){
        //        if (FBSDKAccessToken.current() != nil){
        //            // Logic is user is already login in by facebook
        //            print("Already Exist")
        //
        //
        //        }
        //        else
        //        {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        FBSDKLoginManager().logIn(withReadPermissions: ["public_profile","user_photos","email"], from: self, handler: { (token, error) in
            
            
            if (error != nil) {
                print("Process error")
                let okAction=UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                    
                })
                
                let alertController = UIAlertController(title: "Parking", message:"Error in authentication", preferredStyle: .alert)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: {
                    
                })
                MBProgressHUD.hide(for: self.view, animated: true)
            } else if (token?.isCancelled)! {
                print("Cancelled")
                let okAction=UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                    
                })
                
                let alertController = UIAlertController(title: "Parking", message:"Error in authentication", preferredStyle: .alert)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: {
                    
                })
                MBProgressHUD.hide(for: self.view, animated: true)
            } else {
                print("Logged in :-\(String(describing: token))")
                FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"id,name,picture,email"]).start(completionHandler: { (requestConenction, result, error) in
                    print(result ?? "no data")
                    var faceBook = result as! Dictionary<String,Any>
                    self.faceData = JSON(result)
                    MBProgressHUD.hide(for: self.view, animated: true)
                                                self.action = "3"
                                                let dic = ["apikey":apiKey,
                                                           "password":self.faceData["id"].stringValue,
                                                           "email":self.faceData["email"].stringValue,
                                                           "name":self.faceData["name"].stringValue,
                                                           "social_login_type":"fb",
                                                           "action":(self.action)!
                                                ]
                                                self.socialLoginWebServices(dic: dic)

//                    if self.mobileNoTextField.text?.characters.count == 0 {
//                        
//                        let okAction=UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
//                            Preferences.saveDataToPreferences(nameOfPreference:GLobalKeys.userFacebookData, data: result as! [String:Any])
//                            Preferences.printPreference(nameOfPreference: GLobalKeys.userFacebookData)
//                            self.action = "3"
//                            let dic = ["apikey":apiKey,
//                                       "password":self.faceData["id"].stringValue,
//                                       "email":self.faceData["email"].stringValue,
//                                       "name":self.faceData["name"].stringValue,
//                                       "social_login_type":"fb",
//                                       "action":(self.action)!
//                            ]
//                            self.socialLoginWebServices(dic: dic)
//                           
//                            
//                        })
//                        let alertController = UIAlertController(title: "Parking", message:"Successfully authenticated", preferredStyle: .alert)
//                        alertController.addAction(okAction)
//                        self.present(alertController, animated: true, completion: {
//                            
//                        })
//                    }
//                    else{
//                        // logic for navigation or seque
//                        var faceBook = result as! Dictionary<String,Any>
//                        faceBook["email"]=self.mobileNoTextField.text
//                        Preferences.saveDataToPreferences(nameOfPreference:GLobalKeys.userFacebookData, data: faceBook)
//                        Preferences.printPreference(nameOfPreference: GLobalKeys.userFacebookData)
//                        
//                        
//                    }
                    
                    
                    
                })
                
            }
            
        })
        
        
    }

    @IBAction func allBtn(_ sender: UIButton) {
        switch sender.tag {
        case BtnViewTags.registerTag.rawValue:
            if registerString == "Login"{
                if (self.userNameTextField.text?.characters.count)! <= 0 {
                    let okAction=UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                        
                    })
                    let alertController = UIAlertController(title: "PARKING", message:"Please enter Username", preferredStyle: .alert)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: {
                        
                    })
                    
                }else if (self.loginPasswordTextField.text?.characters.count)! <= 0{
                    let okAction=UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                        
                    })
                    let alertController = UIAlertController(title: "PARKING", message:"Please enter Password", preferredStyle: .alert)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: {
                        
                    })
                    
                }else{
                    self.registerNewBtns.setImage(UIImage(named: "login_btn"), for: .normal)
                    action = "2"
                    self.loginWebService()

                }
                
                            }else{
                if (self.mobileNoTextField.text?.characters.count)! <= 9
                {
                    let okAction=UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                        
                    })
                    let alertController = UIAlertController(title: "PARKING", message:"Please enter correct phone number, number must contains 10 digits", preferredStyle: .alert)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: {
                        
                    })
                }
                else if (self.emailTextField.text?.characters.count)! <= 0
                {
                    let okAction=UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                        
                    })
                    let alertController = UIAlertController(title: "PARKING", message:"Please enter Email", preferredStyle: .alert)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: {
                        
                    })
                    
                }
                else if !isValidEmail(testStr: emailTextField.text!){
                    let okAction=UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                        
                    })
                    let alertController = UIAlertController(title: "PARKING", message:"Please enter Valid Email", preferredStyle: .alert)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: {
                        
                    })
                    
                }
                else if (self.passwordTextField.text?.characters.count)! <= 0
                {
                    let okAction=UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                        
                    })
                    let alertController = UIAlertController(title: "PARKING", message:"Please enter Password", preferredStyle: .alert)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: {
                        
                    })
                    
                }else{
                   
                        self.registerNewBtns.setImage(UIImage(named: "register_now"), for: .normal)
                        action = "1"
                        self.registerWebService()
              
                }
            }
            
            
            break
        case BtnViewTags.facebookTag.rawValue:
            self.performFaceBookLogin()
            Preferences.saveDataToPreferences(nameOfPreference:GLobalKeys.socialLoginType, data: "facebook")

             break
        case BtnViewTags.googleTag.rawValue:
            let delegate = UIApplication.shared.delegate as! AppDelegate
            delegate.globalIndicator = MBProgressHUD.showAdded(to: self.view, animated: true)
            delegate.globalIndicator?.show(animated: true)
            delegate.regist = self
            Preferences.saveDataToPreferences(nameOfPreference:GLobalKeys.socialLoginType, data: "google")
            
            GIDSignIn.sharedInstance().signIn()

             break
        case BtnViewTags.loginTag.rawValue:
//            if (self.mobileNoTextField.text?.characters.count)! <= 9
//            {
//                let okAction=UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
//                    
//                })
//                let alertController = UIAlertController(title: "PARKING", message:"Please enter correct phone number, number must contains 10 digits", preferredStyle: .alert)
//                alertController.addAction(okAction)
//                self.present(alertController, animated: true, completion: {
//                    
//                })
//            }
//            else if (self.emailTextField.text?.characters.count)! <= 0
//            {
//                let okAction=UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
//                    
//                })
//                let alertController = UIAlertController(title: "PARKING", message:"Please enter Email", preferredStyle: .alert)
//                alertController.addAction(okAction)
//                self.present(alertController, animated: true, completion: {
//                    
//                })
//                
//            }
//            else if !isValidEmail(testStr: emailTextField.text!){
//                let okAction=UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
//                    
//                })
//                let alertController = UIAlertController(title: "PARKING", message:"Please enter Valid Email", preferredStyle: .alert)
//                alertController.addAction(okAction)
//                self.present(alertController, animated: true, completion: {
//                    
//                })
//                
//            }
//            else if (self.passwordTextField.text?.characters.count)! <= 0
//            {
//                let okAction=UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
//                    
//                })
//                let alertController = UIAlertController(title: "PARKING", message:"Please enter Password", preferredStyle: .alert)
//                alertController.addAction(okAction)
//                self.present(alertController, animated: true, completion: {
//                    
//                })
//                
//            }else{
//               
//                
//            }
            registerString = "Register"
            topLoginView.isHidden = true
            self.bottomRegisterView.isHidden = false
            self.registerNewBtns.setImage(UIImage(named: "register_now"), for: .normal)
             break
            
        default:
             break
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "register"{
            let vc = segue.destination as! DashboardViewController
           // vc.custmerId = self.custmerId
            
        }
    }
    func registerWebService(){
         MBProgressHUD.showAdded(to: self.view, animated: true)
        let dic = ["apikey":apiKey,
                   "mobile":self.mobileNoTextField.text!,
                   "email":self.emailTextField.text!,
                   "password":self.passwordTextField.text!,
                   "action":(action)!
                     ]
        WebService.hitPostService(urlToPass: loginUrl!, parameterToPass: dic) { (data) in
           self.json = JSON(data)
            if  self.json ["status"] == "200"{
               self.custmerId = self.json["data"]["customer_id"].stringValue
                UserDefaults.standard.set(self.custmerId, forKey: "dict")
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                     MBProgressHUD.hide(for: self.view, animated: true)
                    self.performSegue(withIdentifier: "register", sender: self)
//                    self.registerString = "Login"
//                    self.registerNewBtns.setImage(UIImage(named: "login_btn"), for: .normal)
//                    self.topLoginView.isHidden = false
//                    self.bottomRegisterView.isHidden = true
                    
                   
                })
                let alertController = UIAlertController(title: "Parking", message: self.json["message"].stringValue, preferredStyle: .alert)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: {
                   
                })

            }else if self.json ["status"] == "300"{
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.registerString = "Login"
                    self.registerNewBtns.setImage(UIImage(named: "login_btn"), for: .normal)
                    self.topLoginView.isHidden = false
                    self.bottomRegisterView.isHidden = true

                })
                let alertController = UIAlertController(title: "Parking", message: self.json["message"].stringValue, preferredStyle: .alert)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: {
                    
                })
            }
            
            else{
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                 MBProgressHUD.hide(for: self.view, animated: true)
                
            })
                let alertController = UIAlertController(title: "Parking", message: "Something Went Wrong. Please Try Again", preferredStyle: .alert)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: { 
                    
                })
            }
            
        }
        
    }
    func loginWebService(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let dic = ["apikey":apiKey,
                   "username":self.userNameTextField.text!,
                   "password":self.loginPasswordTextField.text!,
                   "action":(action)!
        ]
        WebService.hitPostService(urlToPass: loginUrl!, parameterToPass: dic) { (data) in
            self.json = JSON(data)
            if  self.json ["status"] == "200"{
                self.custmerId = self.json["data"]["customer_id"].stringValue
                UserDefaults.standard.set(self.custmerId, forKey: "dict")
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.performSegue(withIdentifier: "register", sender: self)
                })
                let alertController = UIAlertController(title: "Parking", message: self.json["message"].stringValue, preferredStyle: .alert)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: {
                    
                })
                
            }else{
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                })
                let alertController = UIAlertController(title: "Parking", message: "Something Went Wrong. Please Try Again", preferredStyle: .alert)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: {
                    
                })
            }
            
        }
        
    }
    func socialLoginWebServices(dic:Dictionary<String,Any>){
        
       
        WebService.hitPostService(urlToPass: loginUrl!, parameterToPass: dic) { (data) in
            self.json = JSON(data)
            print(self.json)
            if  self.json ["status"] == "200"{
            self.custmerId = self.json["data"]["customer_id"].stringValue
              UserDefaults.standard.set(self.custmerId, forKey: "dict")
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.performSegue(withIdentifier: "register", sender: self)
                })
                let alertController = UIAlertController(title: "Parking", message: self.json["message"].stringValue, preferredStyle: .alert)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: {
                    
                })
                
            }
              else if  self.json ["status"] == "500"{
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                })
                let alertController = UIAlertController(title: "Parking", message: self.json["message"].stringValue, preferredStyle: .alert)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: {
                    
                })
                
            }else{
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                })
                let alertController = UIAlertController(title: "Parking", message: "Something Went Wrong. Please Try Again", preferredStyle: .alert)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: {
                    
                })
            }
            
        }

    }
    @IBAction func newRegisterBtn(_ sender: Any) {
        

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
