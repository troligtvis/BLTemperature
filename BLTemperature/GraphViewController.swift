//
//  GraphViewController.swift
//  BLTemperature
//
//  Created by Kj Drougge on 2014-12-15.
//  Copyright (c) 2014 kj. All rights reserved.
//

import Foundation
import UIKit

class GraphViewController: UIViewController, UpdateTemperatureDelegate {
    
    @IBOutlet weak var chart: Chart!
    var discovery: BLDiscovery!
    
    var temperatures: [Float]! = []
    var series: ChartSeries!
    
    override func viewDidLoad() {
        
        chart.minY = 20
        chart.maxY = 30

        for var i = 0; i < 10; ++i {
            temperatures.append(Float(25))
        }
        
        series = ChartSeries(temperatures)
        series.color = UIColor.blueColor()
        series.area = true
        
        chart.addSeries(series)
        
        discovery.delegate = self
    }

    func updateTemperature(temperature: Float) {
        dispatch_async(dispatch_get_main_queue(), {
            self.chart.removeSeries()
            
            if self.temperatures.count > 10 {
                self.temperatures.removeAtIndex(0)
            }
            
            self.temperatures.append(temperature)
            
            self.series = ChartSeries(self.temperatures)
            self.series.color = UIColor.blueColor()
            self.series.area = true
            
            self.chart.addSeries(self.series)
            
            self.chart.setNeedsDisplay()
        })
    }
}