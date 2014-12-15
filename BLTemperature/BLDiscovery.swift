//
//  BLDiscovery.swift
//  BLTemperature
//
//  Created by Kj Drougge on 2014-12-14.
//  Copyright (c) 2014 kj. All rights reserved.
//

import Foundation
import CoreBluetooth

let blDiscoverySharedInstance = BLDiscovery()

protocol UpdateLabelDelegate{
    func test()
}

class BLDiscovery: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate{
    
    var centralManager:CBCentralManager!
    var peripheral:CBPeripheral!
    var isBluetoothReady = false
    
    var results: [String]! = []
    var pauseUpdate: Bool! = false
    
    var viewController: ViewController!
    
    override init(){
        super.init()
        
        let centralQueue = dispatch_queue_create("com.gozer", DISPATCH_QUEUE_SERIAL)
        
        println("Initializing central manager")
        centralManager = CBCentralManager(delegate: self, queue: centralQueue)
    }
    
    func startScanning(){
        println("Start scanning")
        centralManager.scanForPeripheralsWithServices(nil, options: nil)
    }
 
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        println("Discovered \(peripheral.name)")
        println("identifier \(peripheral.identifier)")
        println("services \(peripheral.services)")
        println("RSSI \(RSSI)")
        
        self.peripheral = peripheral;
        
        central.connectPeripheral(self.peripheral, options: nil)
    }
    
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        
        self.peripheral.delegate = self;
        self.peripheral.discoverServices(nil)
        println("Connected")
    }
    
    func centralManager(central: CBCentralManager!, didDisconnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        println("Disconnected")
        
        self.peripheral = nil;
    
        // Validate peripheral information
        if ((peripheral == nil) || (peripheral.name == nil) || (peripheral.name == "")) {
            return
        }
        
        // If not already connected to a peripheral, then connect to this one
        if ((self.peripheral == nil) || (self.peripheral?.state == CBPeripheralState.Disconnected)) {
            // Retain the peripheral before trying to connect
            self.peripheral = peripheral
            
            // Reset service
            //self.bleService = nil
            
            // Connect to peripheral
            central.connectPeripheral(peripheral, options: nil)
        }

        
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        println("checking state")
        isBluetoothReady = false;
        switch (central.state) {
        case .PoweredOff:
            println("CoreBluetooth BLE hardware is powered off")
            break
        case .PoweredOn:
            println("CoreBluetooth BLE hardware is powered on and ready")
            self.startScanning()
            break
        case .Resetting:
            println("CoreBluetooth BLE hardware is resetting")
            break
        case .Unauthorized:
            println("CoreBluetooth BLE state is unauthorized")
            break
        case .Unknown:
            println("CoreBluetooth BLE state is unknown");
            break
        case .Unsupported:
            println("CoreBluetooth BLE hardware is unsupported on this platform");
            break
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        
        println("Hello from deligate \(peripheral.name)");
        
        for aService in peripheral.services{
            println("Service UUID: \((aService as CBService).UUID )")
            peripheral.discoverCharacteristics(nil, forService: aService as CBService)
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        
        println("Found Characteristics For Service: \(service.UUID)")
        for aChar in service.characteristics
        {
            
            println("Characteristics UUID: \((aChar as CBCharacteristic).UUID)")
            if((aChar as CBCharacteristic).UUID.isEqual(CBUUID(string: "F000AA11-0451-4000-B000-000000000000"))){
                
                // Ambient Temperature
                var sUUID = CBUUID(string: "F000AA00-0451-4000-B000-000000000000")
                var dUUID = CBUUID(string: "F000AA01-0451-4000-B000-000000000000")
                var cUUID = CBUUID(string: "F000AA02-0451-4000-B000-000000000000")
                
                var random = NSInteger(1)
                var data = NSData(bytes: &random, length: 1)
                BLEUtilitySwift.writeCharacteristic(self.peripheral, sUUID: sUUID, cUUID: cUUID, data: data)
                
                BLEUtilitySwift.setNotificationForCharacteristic(self.peripheral, sUUID: sUUID, cUUID: dUUID, enable: true)
                
                println("Done with setting up temperature sensor")
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didWriteValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        println("didWriteValueForCharacteristic \(characteristic.UUID) error = \(error)");
    }
    
    var str: String! = "something"
    
    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        
        if !pauseUpdate.boolValue {
            
            // Temperature
            var temp = sensorTMP006.calcTAmb(characteristic.value)
            println("TEMP: \(temp)")
            
            str = " \(temp) "
            
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd H:m:s"
            
            let date = dateFormatter.stringFromDate(NSDate()) as String!
            
            
            //var dateStr = "\(NSDate())"
            results.append("\(date),")
            results.append("\(str)\n")
            
            
            
            // FIX THIS SOMEHOW <--------
            //ViewController.setTemperatureLabel("Ambient temperature: \(temp)°")
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        println("didUpdateNotificationStateForCharacteristic \(characteristic.UUID), error = \(error)");
    }
    
    func arrayToString() -> String {
        var str: String! = ""
        
        for var i = 0; i < results.count; ++i{
            
            str = str + String(results[i])
        }
        return str
    } 
}