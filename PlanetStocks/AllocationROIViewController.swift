//
//  AllocationROIViewController.swift
//  PlanetStocks
//
//  Created by Omar Tehsin on 2019-05-23.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import Charts
import CoreData

class AllocationROIViewController: UIViewController {

    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var lineChartView: LineChartView!
    
    
    var otherStocks = [String]()
    var otherDollarsInvested = [Double]()
    var theStocks = [Double]()
    var theDollarInvested = [Double]()
    var savedStocks = [Stocks]()


    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let fetchRequest: NSFetchRequest<Stocks> = Stocks.fetchRequest()
        do {
            let stocks = try PersistanceService.context.fetch(fetchRequest) as [Stocks]
            self.savedStocks = stocks
            
        } catch {}
        for theSavedStocks in savedStocks {
            otherDollarsInvested.append(theSavedStocks.invested)
            
            otherStocks.append(theSavedStocks.symbol!)
            theStocks.append(theSavedStocks.closePriceCost)

        }
        
        
        let theSumOfClosePrice = theStocks.reduce(0, +)
        
        
        let newDollarArray = otherDollarsInvested.filter {$0 != 0.0}
        
        let sumOfInitialInvestment = newDollarArray.reduce(0, +)
        
        
        let ROI = [((theSumOfClosePrice - sumOfInitialInvestment) / sumOfInitialInvestment) * 100]
        print(ROI)
        
        let otherLine = [sumOfInitialInvestment, theSumOfClosePrice]


        setCharts(dataPoints: otherStocks, values: newDollarArray)
        setLineChart(dataPoints: otherStocks, values: [0.0, theSumOfClosePrice], initialInvestment: [0.0, sumOfInitialInvestment])

    }
    
    func setCharts(dataPoints: [String], values: [Double]) {
        var dataEntries : [PieChartDataEntry] = [PieChartDataEntry]()
        
        for i in 0 ..< values.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i])
            
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        let data = PieChartData(dataSet: pieChartDataSet)
        
        pieChartView.data = data

        
        var colours: [UIColor] = []
        
        for _ in 0..<values.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let colour = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colours.append(colour)
        }
        
        pieChartDataSet.colors = colours
        
        
        //let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: nil)
        
    }
    func setLineChart(dataPoints: [String], values: [Double], initialInvestment: [Double]) {
        var dataEntries = [ChartDataEntry]()
        var secondDataEntries = [ChartDataEntry]()
        for i in 0 ..< values.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        for i in 0 ..< initialInvestment.count {
            let secondDataEntry = ChartDataEntry(x: Double(i), y: initialInvestment[i])
            secondDataEntries.append(secondDataEntry)
        }
        let theLine = LineChartDataSet(entries: dataEntries, label: "ROI")
        let secondLine = LineChartDataSet(entries: secondDataEntries, label: "Initial Investment")
        //let data = LineChartData(dataSet: theLine)
        let data = LineChartData()
        data.addDataSet(theLine)
        data.addDataSet(secondLine)
        lineChartView.data = data
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM YY"

        var colours: [UIColor] = []
        
        for _ in 0..<values.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let colour = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colours.append(colour)
        }
        theLine.colors = colours
        secondLine.colors = colours
    }
//    func setOtherLineChart(dataPoints: [String], values: [Double]) {
//        var dataEntries = [ChartDataEntry]()
//        for i in 0 ..< values.count {
//            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
//            dataEntries.append(dataEntry)
//        }
//        let theLine = LineChartDataSet(entries: dataEntries, label: nil)
//        let data = LineChartData(dataSet: theLine)
//        lineChartView.data = data
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd MMM YY"
//
//        var colours: [UIColor] = []
//
//        for _ in 0..<values.count {
//            let red = Double(arc4random_uniform(256))
//            let green = Double(arc4random_uniform(256))
//            let blue = Double(arc4random_uniform(256))
//
//            let colour = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
//            colours.append(colour)
//        }
//        theLine.colors = colours
//
//    }

}
