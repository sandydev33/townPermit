//
//  DashboardViewController.swift
//  Parking
//
//  Created by khim singh on 18/09/17.
//  Copyright © 2017 eSoft. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func parkingBtn(_ sender: Any) {
        performSegue(withIdentifier: "parking", sender: self )
    }
    
    @IBAction func fishingBtn(_ sender: Any) {
        performSegue(withIdentifier: "fishing", sender: self)
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
