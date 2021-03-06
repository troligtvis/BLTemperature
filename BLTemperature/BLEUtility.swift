//
//  BLEUtility.swift
//  BLTemperature
//
//  Created by Kj Drougge on 2014-12-14.
//  Copyright (c) 2014 kj. All rights reserved.
//

import Foundation
import CoreBluetooth

class BLEUtilitySwift: NSObject {
    
    class func writeCharacteristic(peripheral:CBPeripheral, sUUID: String, cUUID: String, data: NSData){
        for service in peripheral.services as [CBService] {
            if(service.UUID == CBUUID(string: sUUID)){
                for characteristic in service.characteristics as [CBCharacteristic]{
                    if(characteristic.UUID == CBUUID(string: cUUID)){
                        /* Everything is found, WRITE characteristic ! */
                        peripheral.writeValue(data, forCharacteristic: characteristic, type: CBCharacteristicWriteType.WithResponse)
                    }
                }
            }
        }
    }
    
    class func writeCharacteristic(peripheral:CBPeripheral, sUUID: CBUUID, cUUID: CBUUID, data: NSData){
        for service in peripheral.services as [CBService] {
            if(service.UUID == sUUID){
                for characteristic in service.characteristics as [CBCharacteristic]{
                    if(characteristic.UUID == cUUID){
                        /* Everything is found, WRITE characteristic ! */
                        peripheral.writeValue(data, forCharacteristic: characteristic, type: CBCharacteristicWriteType.WithResponse)
                    }
                }
            }
        }
    }
    
    class func readCharacteristic(peripheral:CBPeripheral, sUUID: String, cUUID: String){
        for service in peripheral.services as [CBService] {
            if(service.UUID == CBUUID(string: sUUID)){
                for characteristic in service.characteristics as [CBCharacteristic]{
                    if(characteristic.UUID == CBUUID(string: cUUID)){
                        /* Everything is found, READ characteristic ! */
                        peripheral.readValueForCharacteristic(characteristic)
                    }
                }
            }
        }
    }
    
    class func readCharacteristic(peripheral:CBPeripheral, sUUID: CBUUID, cUUID: CBUUID){
        for service in peripheral.services as [CBService] {
            if(service.UUID == sUUID){
                for characteristic in service.characteristics as [CBCharacteristic]{
                    if(characteristic.UUID == cUUID){
                        /* Everything is found, READ characteristic ! */
                        peripheral.readValueForCharacteristic(characteristic)
                        
                    }
                }
            }
        }
    }
    
    class func setNotificationForCharacteristic(peripheral:CBPeripheral, sUUID: String, cUUID: String, enable: Bool){
        for service in peripheral.services as [CBService] {
            if(service.UUID == CBUUID(string: sUUID)){
                for characteristic in service.characteristics as [CBCharacteristic]{
                    if(characteristic.UUID == CBUUID(string: cUUID)){
                        /* Everything is found, SET notification ! */
                        peripheral.setNotifyValue(enable, forCharacteristic: characteristic)
                    }
                }
            }
        }
    }
    
    class func setNotificationForCharacteristic(peripheral:CBPeripheral, sUUID: CBUUID, cUUID: CBUUID, enable: Bool){
        for service in peripheral.services as [CBService] {
            if(service.UUID == sUUID){
                for characteristic in service.characteristics as [CBCharacteristic]{
                    if(characteristic.UUID == cUUID){
                        /* Everything is found, set notification ! */
                        peripheral.setNotifyValue(enable, forCharacteristic: characteristic)
                    }
                }
            }
        }
    }
    
    class func isCharacteristicNotifiable(peripheral:CBPeripheral, sUUID: CBUUID, cUUID: CBUUID) -> Bool{
        for service in peripheral.services as [CBService] {
            if(service.UUID == sUUID){
                for characteristic in service.characteristics as [CBCharacteristic]{
                    if(characteristic.UUID == cUUID){
                        if(characteristic.properties == CBCharacteristicProperties.Notify){
                            return true
                        }else{
                            return false
                        }
                    }
                }
            }
        }
        return false;
    }
}