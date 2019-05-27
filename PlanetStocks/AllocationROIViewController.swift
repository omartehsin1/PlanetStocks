//
//  AllocationROIViewController.swift
//  PlanetStocks
//
//  Created by Omar Tehsin on 2019-05-23.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import Charts

class AllocationROIViewController: UIViewController {

    @IBOutlet weak var pieChartView: PieChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let stocks = ["MSFT", "AAPL", "FB", "TSLA"]
        let dollarsInvested = [100.0, 223.0, 312.0, 750.0]
        
        setCharts(dataPoints: stocks, values: dollarsInvested)

        // Do any additional setup after loading the view.
    }
    
    func setCharts(dataPoints: [String], values: [Double]) {
        var dataEntries : [PieChartDataEntry] = [PieChartDataEntry]()
        
        for i in 0 ..< dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], data: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "Allocation")
        
        let data = PieChartData(dataSet: pieChartDataSet)
        pieChartView.data = data
        
        var colours: [UIColor] = []
        
        for i in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let colour = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colours.append(colour)
        }
        
        pieChartDataSet.colors = colours
    }

}
