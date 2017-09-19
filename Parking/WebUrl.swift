//
//  WebUrl.swift
//  SugarBox
//
//  Created by khim singh on 16/05/17.
//  Copyright © 2017 eSoft. All rights reserved.
//

import Foundation
//static variable 
let apiKey = "X-API-KEY"
let baseUrl = "http://test1.esoftech.in/town/api/v1_0/"

//=========================================================================================
let loginUrl = URL(string: baseUrl + "login")
let townlist = URL(string: baseUrl + "townlist")
let utility = URL(string: baseUrl + "utility")
let utilityInfo = URL(string: baseUrl + "utilityinfo")
let saveorder = URL(string: baseUrl + "saveorder")
let profiledataUrl = URL(string: baseUrl + "profiledata")
let beachpassUrl = URL(string: baseUrl + "beachpass")
let updateprofileUrl = URL(string: baseUrl + "updateprofile")

//let baseUrl = "http://zeeapp.margocdn.com/apphost/"
//let baseUrl = "http://apphosting01.margocdn.com/"
//let dPListUrl = URL(string: baseUrl + "networklist") // nearest
//let oTtUrl = URL(string: baseUrl + "ottpartners") //ottpartners
//let mapListUrl = URL(string: baseUrl + "category/deploymentpartner")// listView
//let filterCatgoryUrl = baseUrl + "category/deploymentpartner?"
//let filterUrl = URL(string: baseUrl + "filters")
//let networksListUrl = URL(string: baseUrl + "deploymentpartner") // viewall Home 
//let sendOtpUrl = URL(string: baseUrl + "sendotp")
//let verifyOtpUrl = URL(string: baseUrl + "verifyotp")
//let confirmsubscriberotpUrl = URL(string: baseUrl + "confirmsubscriberotp")
//let registersubscriber = URL(string: baseUrl + "registersubscriber")
//
//// New Service for register  SB Networks
//
//let subscriber = URL(string: "sms01.dev.margocdn.com:8080/v1/is-subscriber-exists-other-nw?sendOtp=true")
//let otp = URL(string: "http://sms01.dev.margocdn.com:8080/v1/is-confirm-otp-exists-other-nw?sendOtp=true")
//
//

// for Post Request


//let networksListUrl = URL(string: baseUrl + "networks-list.json")
//let dPListUrl = URL(string: baseUrl + "dp-list.json")
//let oTtUrl = URL(string: baseUrl + "ottpartners-list.json")
//let mapListUrl = URL(string: baseUrl + "dpmap-listbycategory.json")
//let filterUrl = URL(string: baseUrl + "filters.json")
//let sendOtpUrl = URL(string: baseUrl + "send-otp.json")
//let verifyOtpUrl = URL(string: baseUrl + "verify-otp.json")
		
