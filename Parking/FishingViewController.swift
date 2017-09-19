//
//  FishingViewController.swift
//  Parking
//
//  Created by khim singh on 18/09/17.
//  Copyright © 2017 eSoft. All rights reserved.
//

import UIKit

class FishingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         if indexPath.section == 0{
        return 330.0
         }else{
        return 621.0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "fish", for: indexPath) as! FishingTableViewCell
            return cell

        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "address", for: indexPath) as! FisingAddressTableViewCell
            return cell
        }
       
        
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
