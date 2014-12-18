//
//  ViewController.swift
//  BLTemperature
//
//  Created by Kj Drougge on 2014-12-14.
//  Copyright (c) 2014 kj. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UpdateTemperatureDelegate{
    @IBOutlet weak var temperatureLabel: UILabel!
    
    var discovery: BLDiscovery!
    
    let network: NetworkCommunication! = NetworkCommunication()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        discovery = BLDiscovery()
        discovery.delegate = self
        
    }
    
    @IBAction func sendButton(sender: AnyObject) {
        
        
        
        
        if let temp = discovery.str{
            network.saveData(discovery.arrayToString())
            network.sendData()
        }
    }
    
    func updateTemperature(temperature: Float) {
        dispatch_async(dispatch_get_main_queue(), {
            self.temperatureLabel.text = "Ambient temperature:\(temperature)°"
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toGraph" {
        
            if let gcv = segue.destinationViewController as? GraphViewController {
                println("Kommer in?")
                gcv.discovery = discovery
            }
        }
        
    }
    
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {
        if let gvc = segue.sourceViewController as? GraphViewController {
            discovery.delegate = self
        }
    }
}

