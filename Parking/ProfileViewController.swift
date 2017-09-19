//
//  ProfileViewController.swift
//  Parking
//
//  Created by khim singh on 30/08/17.
//  Copyright © 2017 eSoft. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SDWebImage
class ProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var TableView: UITableView!
    var details:Array<Any>? = nil
    var profileJson:JSON = []
    var custmerId:String? = nil
    @IBOutlet weak var imageUrl: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      details = ["Address","Phone #","Email ID","Previous Transactions","Passes"]
      custmerId = UserDefaults.standard.string(forKey:"dict")
        let dic = ["apikey":apiKey,
                   "customer_id":custmerId!]
        self.profiledata(dic: dic)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (details?.count)!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profile", for: indexPath) as! ProfileTableViewCell
        cell.profileDetails.text = details?[indexPath.row] as? String
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "change", sender: self)
    }
    func profiledata(dic:Dictionary<String,Any>) {
        WebService.hitPostService(urlToPass: profiledataUrl!, parameterToPass: dic) { (data) in
            self.profileJson = JSON(data)
            if self.profileJson ["status"] == "200"{
                
               self.imageUrl.sd_setImage(with: URL(string: self.profileJson["data"]["image"].stringValue ), placeholderImage:UIImage(named: "dummy"))
                self.nameLabel.text = self.profileJson["data"]["first_name"].stringValue + " " + self.profileJson["data"]["last_name"].stringValue
                
                print(self.profileJson)
            }else if self.profileJson ["status"] == "500" {
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                    
                })
                let alertController = UIAlertController(title: "Parking", message: self.profileJson["message"].stringValue, preferredStyle: .alert)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: {
                    
                })
                
            }
        }

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "change"{
            let vc = segue.destination as! EditChangeViewController
            vc.detailsJson = self.profileJson
            
        }
    }
    @IBAction func editBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "change", sender: self)
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
