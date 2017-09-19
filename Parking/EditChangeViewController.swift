//
//  EditChangeViewController.swift
//  Parking
//
//  Created by khim singh on 07/09/17.
//  Copyright © 2017 eSoft. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import MBProgressHUD
class EditChangeViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cityLabel: UITextField!
    @IBOutlet weak var stateLabel: UITextField!
    @IBOutlet weak var zipCodeLabel: UITextField!

    @IBOutlet weak var lastNameLabel: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    var detailsJson:JSON = []
    var custmerID:String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.emailTextField.text = detailsJson["data"]["email"].stringValue
        self.phoneTextField.text = detailsJson["data"]["phone_number"].stringValue
        self.addressTextField.text = detailsJson["data"]["street_address"].stringValue
        
        self.stateLabel.text = detailsJson["data"]["state"].stringValue
        self.zipCodeLabel.text = detailsJson["data"]["zip_code"].stringValue
        self.lastNameLabel.text = detailsJson["data"]["last_name"].stringValue
        self.cityLabel.text = detailsJson["data"]["city"].stringValue
        self.nameTextField.text = detailsJson["data"]["first_name"].stringValue
       
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        phoneTextField.resignFirstResponder()
        addressTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
        lastNameLabel.resignFirstResponder()
        stateLabel.resignFirstResponder()
        zipCodeLabel.resignFirstResponder()
        cityLabel.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if textField == phoneTextField {
            
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return ((string == numberFiltered) && ((textString.characters.count) <= 10))
        } else if textField == zipCodeLabel{
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return ((string == numberFiltered) && ((textString.characters.count) <= 5))
        }else if textField == nameTextField || textField == lastNameLabel || textField == cityLabel || textField == stateLabel {
            let aSet = NSCharacterSet(charactersIn:"ABCDEFGHIJKLMONPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return ((string == numberFiltered))
        }
       
        
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        animateViewMoving(true, moveValue: 130)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        animateViewMoving(false, moveValue: 130)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func submitBtn(_ sender: Any) {
        if (self.nameTextField.text?.characters.count)! <= 0 || (self.lastNameLabel.text?.characters.count)! <= 0 || (self.cityLabel.text?.characters.count)! <= 0 || (self.stateLabel.text?.characters.count)! <= 0 || (self.addressTextField.text?.characters.count)! <= 0 || (self.emailTextField.text?.characters.count)! <= 0 {
            let okAction=UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                
            })
            let alertController = UIAlertController(title: "PARKING", message:"Please Enter Details", preferredStyle: .alert)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: {
                
            })
            
            
        }
        else if (self.zipCodeLabel.text?.characters.count)! <= 4 {
            let okAction=UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                
            })
            let alertController = UIAlertController(title: "PARKING", message:"Please enter correct Zip Code, number must contains 6 digits", preferredStyle: .alert)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: {
                
            })
        }else if (self.phoneTextField.text?.characters.count)! <= 9{
            let okAction=UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                
            })
            let alertController = UIAlertController(title: "PARKING", message:"Please enter correct phone number, number must contains 10 digits", preferredStyle: .alert)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: {
                
            })
            
        }
        else if !isValidEmail(testStr: self.emailTextField.text!){
            let okAction=UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                
            })
            let alertController = UIAlertController(title: "PARKING", message:"Please enter Valid Email", preferredStyle: .alert)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: {
                
            })
            
        }else{
          custmerID = UserDefaults.standard.string(forKey:"dict")

            let dic = ["apikey":apiKey,
                       "customer_id":custmerID!,
                       "first_name":(self.nameTextField.text)!,
                       "last_name":(self.lastNameLabel.text)!,
                       "street":(self.addressTextField.text)!,
                       "city":(self.cityLabel.text)!,
                       "state":(self.stateLabel.text)!,
                       "zip":(self.zipCodeLabel.text)!,
                       "phone_number":(self.phoneTextField.text)!,
                       "email":(self.emailTextField.text)!]
           
             self.updateWebService(dic: dic)
                   }
      

    }
    func updateWebService(dic:Dictionary<String,Any>) {
        WebService.hitPostService(urlToPass: updateprofileUrl!, parameterToPass: dic) { (data) in
            let json = JSON(data)
            print(json)
            if  json ["status"] == "200"{
                // self.custmerId = self.json["data"]["customer_id"].stringValue
                //  UserDefaults.standard.set(self.custmerId, forKey: "dict")
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.performSegue(withIdentifier: "update", sender: self)
                })
                let alertController = UIAlertController(title: "Parking", message: json["message"].stringValue, preferredStyle: .alert)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: {
                    
                })
                
            }
            else if  json ["status"] == "500"{
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                })
                let alertController = UIAlertController(title: "Parking", message: json["message"].stringValue, preferredStyle: .alert)
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

}
