//
//  AirportDetailViewController.swift
//  AirplaneListApp
//
//  Created by Richard de Jongh on 22-10-16.
//  Copyright © 2016 FraTho. All rights reserved.
//

import UIKit

class AirportDetailViewController: UIViewController {

    var airport : Airport?
    
    @IBOutlet weak var icao: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        icao.text = airport?.icao
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
