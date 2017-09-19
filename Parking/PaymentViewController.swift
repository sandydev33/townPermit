//
//  PaymentViewController.swift
//  Parking
//
//  Created by khim singh on 31/08/17.
//  Copyright © 2017 eSoft. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController,PayPalPaymentDelegate {
   
    @IBOutlet weak var parkingChargeLabel: UILabel!
    @IBOutlet weak var serviceChargeLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    var parkingString:String? = nil
    var serviceString:String? = nil
    var totalString:String? = nil
    var takString:String? = nil
    var chargeString:String? = nil
    var year:Array<Any>? = nil
    
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
 var payPalConfig = PayPalConfiguration() // default
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
         year = ["2017","2018","2019","2020","2021","2022"]
        totalString?.characters.removeFirst()
        totalString?.characters.removeLast()
        chargeString?.characters.removeFirst()
        totalString = totalString?.trimmingCharacters(in: .whitespaces)
        chargeString = chargeString?.trimmingCharacters(in: .whitespaces)

        parkingChargeLabel.text = parkingString!
        serviceChargeLabel.text = serviceString!
        totalLabel.text = totalString!
        
        // Set up payPalConfig
        payPalConfig.acceptCreditCards = true
        payPalConfig.merchantName = "Awesome Shirts, Inc."
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")

         payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        payPalConfig.payPalShippingAddressOption = .both
        print("PayPal iOS SDK Version: \(PayPalMobile.libraryVersion())")
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PayPalMobile.preconnect(withEnvironment: environment)
    }

    func decimal(with string: String) -> NSDecimalNumber {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        return formatter.number(from: string) as? NSDecimalNumber ?? 0
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func allBtns(_ sender: UIButton) {
        switch sender.tag {
        
        case BtnViewTags.payNowBtnTag.rawValue:
            let item1 = PayPalItem(name: "Parking Charges", withQuantity: 1, withPrice: NSDecimalNumber(string: totalString!), withCurrency: "USD", withSku: "Hip-0037")
            let item2 = PayPalItem(name: "Tak Charges", withQuantity: 1, withPrice: NSDecimalNumber(string: "0.00"), withCurrency: "USD", withSku: "Hip-00066")
           // let item3 = PayPalItem(name: "Long-sleeve plaid shirt (mustache not included)", withQuantity: 1, withPrice: NSDecimalNumber(string: "37.99"), withCurrency: "USD", withSku: "Hip-00291")
            
            let items = [item1, item2]
            let subtotal = PayPalItem.totalPrice(forItems: items)
            
            // Optional: include payment details
            let shipping = NSDecimalNumber(string: "0.00")
            let tax = NSDecimalNumber(string: "0.00")
            let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
            
            let total = subtotal.adding(shipping).adding(tax)//(self.decimal(with: totalString!))
            
            //subtotal.adding(shipping).adding(tax)
            
            let payment = PayPalPayment(amount: total  , currencyCode: "USD", shortDescription: "Parking Charge", intent: .sale)
            
            payment.items = items
            payment.paymentDetails = paymentDetails
            
            if (payment.processable) {
                let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
                present(paymentViewController!, animated: true, completion: nil)
            }
            else {
                // This particular payment will always be processable. If, for
                // example, the amount was negative or the shortDescription was
                // empty, this payment wouldn't be processable, and you'd want
                // to handle that here.
                print("Payment not processalbe: \(payment)")
            }

            break
        case BtnViewTags.headerBtnTag.rawValue:
            break
        case BtnViewTags.searchPayBtnTag.rawValue:
            break
        case BtnViewTags.userPatBtnTag.rawValue:
            break
        default:
            break
        }
    }
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("PayPal Payment Cancelled")
//        resultText = ""
//        successView.isHidden = true
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        print("PayPal Payment Success !")
        
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            // send completed confirmaion to your server
            print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
     self.performSegue(withIdentifier: "paypal", sender: self)
           
//            self.resultText = completedPayment.description
//            self.showSuccess()
        })
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
