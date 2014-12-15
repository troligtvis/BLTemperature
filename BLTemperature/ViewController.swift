//
//  ViewController.swift
//  BLTemperature
//
//  Created by Kj Drougge on 2014-12-14.
//  Copyright (c) 2014 kj. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    @IBOutlet weak var temperatureLabel: UILabel!
    
    let network: NetworkCommunication! = NetworkCommunication()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func sendButton(sender: AnyObject) {
        if let temp = blDiscoverySharedInstance.str{

            var dateStr = "<>\(NSDate())"
            blDiscoverySharedInstance.results.append(dateStr)
            network.saveData(blDiscoverySharedInstance.arrayToString())
            network.sendData()
        }
    }
    
    @IBAction func updateBtn(sender: AnyObject) {
        if let temp = blDiscoverySharedInstance.str{
            temperatureLabel.text = "Ambient temperature: \(temp)°"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

