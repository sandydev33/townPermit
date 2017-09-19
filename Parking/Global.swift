//
//  Global.swift
//  Parking
//
//  Created by khim singh on 30/08/17.
//  Copyright © 2017 eSoft. All rights reserved.
//

import Foundation
import UIKit
import Foundation
import SystemConfiguration.CaptiveNetwork
var custId:String? = nil

enum BtnViewTags:Int {
    // register Screen Btn Tags
    case registerTag = 0
    case facebookTag
    case googleTag
    case loginTag
    // Entry Screen Btn Tags
    case capCodeTownTag
    case selectUseTag
    case durationOfParkingTag
    case fromCalender
    case buyNowTag
    case cancelTag
    case doneTag
    case userBtnTag
    case searchTag
    //Payment Screen Btn Tags
    case monthBtnTag
    case yearBtnTag
    case payNowBtnTag
    case cancelPayBtnTag
    case donePayBtnTag
    case headerBtnTag
    case searchPayBtnTag
    case userPatBtnTag
    
}
struct GLobalKeys {
    static let userFacebookData="userFacebookData"
    static let userGoogleData="userGoogleData"
    static let socialLoginType="socialLoginType"
}

struct Preferences {
    static  func getDataFromPreferences(nameOfPreference name:String,data:(Any?)->Void)->String?
    {
        let preferenceData = UserDefaults.standard.object(forKey:name)
        data(preferenceData)
        return preferenceData as? String
    }
    static   func saveDataToPreferences(nameOfPreference name:String, data:Any)
    {
        UserDefaults.standard.set(data, forKey: name)
        UserDefaults.standard.synchronize()
    }
    static  func removeDataFromPreferences(nameOfPreference name:String)
    {
        UserDefaults.standard.removeObject(forKey: name)
        UserDefaults.standard.synchronize()
    }
    static  func printPreference(nameOfPreference name:String)
    {
        print(UserDefaults.standard.object(forKey: name) ?? "No Value in Preferences")
    }
    
}

func isValidEmail(testStr:String) -> Bool {
    // print("validate calendar: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}
