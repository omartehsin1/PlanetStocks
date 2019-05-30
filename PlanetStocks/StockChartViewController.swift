//
//  StockChartViewController.swift
//  PlanetStocks
//
//  Created by Omar Tehsin on 2019-05-21.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
import SwiftyJSON
import Charts

class StockChartViewController: UIViewController {
    //API KEY: 9TR204K3GERJQJ33
    //JOW9MYUHX9HWJTDE
    
    var inputString = String()
    var companySearchArray = [String]()
    @IBOutlet weak var stockChartView: LineChartView!
    @IBOutlet weak var barChartView: BarChartView!
    
    
    
    var stockPrice = [Double]()
    var vol = [Double]()
    var theDates = [String]()
    var doubleDates = [Double]()
    let homeVC = HomeViewController()
    var symb = String()
    var theAPI = String()
    var theResultsArray : [String: String] = [:]
    var theVolumeArray : [String: String] = [:]
    //var api = "JOW9MYUHX9HWJTDE"
    
    //var api = "LI32913MGB8ROSV6"
    override func viewDidLoad() {
        super.viewDidLoad()
        searchStockPrice(input: symb, api: theAPI)
        for key in theResultsArray.keys.sorted(by: <) {
            let price = Double(theResultsArray[key]!)!
            let volume = Double(theVolumeArray[key]!)!
            stockPrice.append(price)
            vol.append(volume)
            theDates.append(key)
        }
        

        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //convertCombined(dataEntryX: theDates, dataEntryY: stockPrice, dataEntryZ: vol)
        generateLineData()
    }
    
    
    
    
    func searchStockPrice(input: String, api: String) {
        let url = URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=\(input)&apikey=\(api)")! 
        print(url)
        let data = NSData(contentsOf: url)
        
        do {
            let results = try JSON(data: data! as Data)
            for (key, subJSON) in results["Time Series (Daily)"] {
                let open = subJSON["1. open"].rawString()
                let volume = subJSON["5. volume"].rawString()
                theResultsArray[key] = open
                theVolumeArray[key] = volume
                
                
            }
            
            
        } catch  {
            print("ERROR")
        }
        
    }
    

    func generateBarChart() {
        var barChartEntry: [BarChartDataEntry] = [BarChartDataEntry]()
        for i in 0 ..< vol.count {
            let value = BarChartDataEntry(x: Double(i), y: vol[i])
            barChartEntry.append(value)
        }
        
        let volBars = BarChartDataSet(entries: barChartEntry, label: "Volume")
        volBars.setColor(UIColor(red: 60/255, green: 220/255, blue: 78/255, alpha: 1))
        let groupSpace = 0.06
        let barSpace = 0.02
        let barWidth = 0.45
        
        
        let data = BarChartData(dataSet: volBars)
        data.barWidth = barWidth
        data.groupBars(fromX: 0, groupSpace: groupSpace, barSpace: barSpace)
        
        
        barChartView.data = data
        barChartView.chartDescription?.text = "Volume"
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        barChartView.leftAxis.labelTextColor = .white
        
    }

    
    func convertCombined(dataEntryX forX:[String],dataEntryY forY: [Double], dataEntryZ forZ: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        var dataEntrieszor: [ChartDataEntry] = [ChartDataEntry]()
        for (i, v) in forY.enumerated() {
            let dataEntry = ChartDataEntry(x: Double(i), y: v, data: forX as AnyObject?)
            dataEntrieszor.append(dataEntry)
        }
        
        for (i, v) in forZ.enumerated() {
            let dataEntry = BarChartDataEntry(x: Double(i), y: v, data: forX as AnyObject?)
            dataEntries.append(dataEntry)
            
        }
        //let max = stockPrice.max()
        
        let lineChartSet = LineChartDataSet(entries: dataEntrieszor, label: "Stock Price")
        let lineChartData = LineChartData(dataSets: [lineChartSet])
        
        
        
        let barChartSet = BarChartDataSet(entries: dataEntries, label: "Volume")
        let barChartData = BarChartData(dataSets: [barChartSet])
        
        //ui
        lineChartSet.setColor(UIColor.red)
        lineChartSet.setCircleColor(UIColor.red)
        
        let comData = CombinedChartData(dataSets: [lineChartSet,barChartSet])
        comData.barData = barChartData
        comData.lineData = lineChartData
        
        
        stockChartView.data = comData
        stockChartView.notifyDataSetChanged()
        stockChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: theDates)
        stockChartView.xAxis.granularity = 1
        stockChartView.rightAxis.axisMaximum = stockPrice.max()!
        stockChartView.leftAxis.axisMaximum = vol.max()!
    }
    
    
    
    
    func generateLineData() {
        
        
        var lineChartEntry = [ChartDataEntry]()
        for i in 0 ..< stockPrice.count {
            let value = ChartDataEntry(x: Double(i), y: stockPrice[i])
            lineChartEntry.append(value)
        }
        
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Price")
        line1.colors = [NSUIColor.blue]
        line1.circleRadius = 1
        line1.fillAlpha = 1
        line1.drawFilledEnabled = true
        line1.fillColor = .blue
        
        
        
        let data = LineChartData()
        data.addDataSet(line1)
        
        
        stockChartView.data = data
        stockChartView.chartDescription?.text = "Stock Price"
        stockChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: theDates)
        stockChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        //        stockChartView.animate(xAxisDuration: 2, yAxisDuration: 2, easingOption: ChartEasingOption.easeInBounce)
        stockChartView.leftAxis.labelTextColor = .white
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class CustomLabelsAxisValueFormatter : NSObject, IAxisValueFormatter
{
    
    var labels: [String] = []
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let count = self.labels.count
        
        guard let axis = axis, count > 0 else {
            
            return ""
        }
        
        let factor = axis.axisMaximum / Double(count)
        
        let index = Int((value / factor).rounded())
        
        if index >= 0 && index < count {
            
            return self.labels[index]
        }
        
        return ""
    }
    
    
}

class CustomYAxisLabelValueFormatter : NSObject, IAxisValueFormatter {
    
    
    var Ylabels: [String] = []
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let count = self.Ylabels.count
        
        guard let axis = axis, count > 0 else {
            
            return ""
        }
        
        let factor = axis.axisMaximum / Double(count)
        
        let index = Int((value / factor).rounded())
        
        if index >= 0 && index < count {
            
            return self.Ylabels[index]
        }
        
        return ""
    }
    
    
}
