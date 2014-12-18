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
    @IBOutlet weak var btnLabel: UIButton!
    
    var discovery: BLDiscovery!
    
    var network: NetworkCommunication!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        discovery = blDiscoverySharedInstance
        discovery.delegate = self
    }
    
    @IBAction func sendButton(sender: AnyObject) {
        
        if !discovery.pauseUpdate.boolValue {
            discovery.pauseUpdate = true
            btnLabel.setTitle("Resume", forState: .Normal)
            
            let alertController = UIAlertController(title: nil, message: "Send the data", preferredStyle: .Alert)
            
            let sendAction = UIAlertAction(title: "Send", style: .Default) { (_) in
                let addressTextField = alertController.textFields![0] as UITextField
                let portTextField = alertController.textFields![1] as UITextField
                
                if let temp = self.discovery.str {
                    self.network = NetworkCommunication(address: addressTextField.text, port: portTextField.text.toInt()!)
                    self.network.saveData(self.discovery.arrayToString())
                    self.network.sendData()
                }
            }
            
            sendAction.enabled = false
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
            
            alertController.addTextFieldWithConfigurationHandler { (textField) in
                textField.placeholder = "IP address"
                textField.text = "178.78.213.33" // Change this to default values
                textField.keyboardType = .DecimalPad
                
                NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                    sendAction.enabled = textField.text != ""
                }
                
                alertController.addTextFieldWithConfigurationHandler { (textField) in
                    textField.placeholder = "Port"
                    textField.text = "6667" // Change this to default values
                    textField.keyboardType = .DecimalPad
                }
            }
            
            alertController.addAction(sendAction)
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            discovery.pauseUpdate = false
            btnLabel.setTitle("Send", forState: .Normal)
        }
    }
    
    func updateTemperature(temperature: Float) {
        dispatch_async(dispatch_get_main_queue(), {
            self.temperatureLabel.text = "Ambient temperature:\(temperature)°"
        })
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toGraph" {
            if let gcv = segue.destinationViewController as? GraphViewController {
                gcv.discovery = discovery
            }
        }
    }
    
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {
        if let gvc = segue.sourceViewController as? GraphViewController {
            discovery.delegate = self
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}