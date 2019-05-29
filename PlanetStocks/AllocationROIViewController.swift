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
    var shares = Double()
    var price = Double()
    var stocks = [String]()
    var dollarsInvested = [Double]()
    var theStocks = [String]()
    var theDollarInvested = [Double]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let savedStocks = Stocks()
        //print(savedStocks.symbol!)
        theStocks = ["AAPL", "MSFT", "FB"]
        theDollarInvested = [100.0, 212.34, 453.45]
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
        
        print(dataEntries)
        
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
