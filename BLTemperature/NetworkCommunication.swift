//
//  NetworkCommunication.swift
//  BLTemperature
//
//  Created by Kj Drougge on 2014-12-14.
//  Copyright (c) 2014 kj. All rights reserved.
//

import Foundation

class NetworkCommunication: NSObject, NSStreamDelegate{
    
    private var serverAddress: CFString!
    private var serverPort: UInt32!
    
    private var inputStream: NSInputStream!
    var outputStream: NSOutputStream!
    
    init(address: String, port: Int){
        super.init()
        
        serverAddress = address as CFString
        serverPort = UInt32(port)
        
        println("address:\(serverAddress) port:\(serverPort)")
        
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(nil, self.serverAddress, self.serverPort, &readStream, &writeStream)
        
        self.inputStream = readStream!.takeRetainedValue()
        self.outputStream = writeStream!.takeRetainedValue()
        
        self.inputStream.delegate = self
        self.outputStream.delegate = self
        
        self.inputStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        self.outputStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        
        //self.inputStream.open()
        self.outputStream.open()
        
        println("Done setup socket")
    }
    
    func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        
        switch eventCode{
        case NSStreamEvent.OpenCompleted:
            println("Stream opened")
            break
        case NSStreamEvent.HasSpaceAvailable:
            if outputStream == aStream{
                println("outputstream is ready!")
            }
            break
        case NSStreamEvent.HasBytesAvailable:
            println("has bytes")
            break
            
        case NSStreamEvent.ErrorOccurred:
            println("Can not connect to the host!")
            break
        case NSStreamEvent.EndEncountered:
            outputStream.close()
            outputStream.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
            outputStream = nil
            break
            
        default:
            println("Unknown event")
        }
    }
    
    func saveData(stringWithInfo: String){
        println("saveData")
        if let dirs = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as?  [String] {
            let path = dirs[0].stringByAppendingPathComponent( "data.txt")
            let text = stringWithInfo
            text.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
        } else {
            println("saveData error")
        }
    }
    
    func loadData() -> String{
        if let dirs = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as?  [String] {
            let path = dirs[0].stringByAppendingPathComponent( "data.txt")
            
            if let text = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil) {
                return text
            }
        }
        
        return ""
    }
    
    func sendData(){
        println("sendData")
        if let dirs = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as?  [String] {
            
            let path = dirs[0].stringByAppendingPathComponent( "data.txt")
            
            if let text = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil) {
                var text2 = text + "\r\n"
                var data = NSData(data: text2.dataUsingEncoding(NSASCIIStringEncoding)!)
            
                outputStream?.write(UnsafePointer<UInt8>(data.bytes) , maxLength: data.length)
                blDiscoverySharedInstance.results.removeAll()
            } else {
                println("No file?")
            }
        } else {
            println("Empty")
        }
    }
}