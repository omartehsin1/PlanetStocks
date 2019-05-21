//
//  ViewController.swift
//  PlanetStocks
//
//  Created by Omar Tehsin on 2019-05-16.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
import SwiftyJSON
import Charts
class ViewController: UIViewController {
    //API KEY: 9TR204K3GERJQJ33
    //JOW9MYUHX9HWJTDE
    @IBOutlet weak var inputTyped: UITextField!
    var inputString = String()
    var companySearchArray = [String]()
    @IBOutlet weak var stockChartView: CombinedChartView!
    var stockPrice = [Double]()
    var vol = [Double]()
    var theDates = [String]()
    var doubleDates = [Double]()
    let dropDown = DropDown()
    var symb = String()
    var theResultsArray : [String: String] = [:]
    var theVolumeArray : [String: String] = [:]
    //var api = "JOW9MYUHX9HWJTDE"
    //var api = "9TR204K3GERJQJ33"
    var api = "LI32913MGB8ROSV6"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputTyped.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        // Do any additional setup after loading the view.
        
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        setUpDropDown()
        
    }
    
    
    
    func stockSearch(input: String, completion: @escaping ([String]) ->()) {
        var resultsArray = [String]()
        let url = URL(string: "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(inputTyped.text!)&apikey=\(api)")!
        //print(url)
        Alamofire.request(url).responseJSON { (response) in
            if let jsonValue = response.result.value {
                let json = JSON(jsonValue)
                
                for(_, subJSON) in json["bestMatches"] {
                    if let name = subJSON["2. name"].rawString(), let symbol = subJSON["1. symbol"].rawString() {
                        self.symb = symbol
                        let result = "\(symbol) - \(name)"
                        resultsArray.append(result)
                    }
                }
            }
            completion(resultsArray)
        }
        
        
    }
    
    func stockPrice(input: String) {
        let url = URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=\(symb)&apikey=\(api)")! //got an error here, find a way to only do symbol
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
    
    func setUpDropDown() {
        dropDown.anchorView = inputTyped
        dropDown.bottomOffset = CGPoint(x: 0, y: inputTyped.bounds.height)
        dropDown.direction = .any
        dropDown.dismissMode = .onTap
        DropDown.appearance().backgroundColor = UIColor(white: 1, alpha: 0.8)
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.inputTyped.text = item
        }
        stockSearch(input: inputTyped.text!) { (resultsArr) in
            self.dropDown.dataSource = resultsArr
            self.dropDown.show()
            //print(resultsArr)
        }
    }
    
    @IBAction func searchPressed(_ sender: Any) {
        stockPrice(input: symb)
        //print(theResultsArray.values)
        for key in theResultsArray.keys.sorted(by: <) {
            //print("\(key) \(theResultsArray[key])")
            let price = Double(theResultsArray[key]!)!
            let volume = Double(theVolumeArray[key]!)!
            //let divVol = volume / 100
            stockPrice.append(price)
            vol.append(volume)
            theDates.append(key)
        }
//        setChartData()
        //generateLineData()
        convertCombined(dataEntryX: theDates, dataEntryY:vol , dataEntryZ: stockPrice)
        

       
    }
    @IBAction func clearButtonPressed(_ sender: Any) {
        inputTyped.text = ""
        
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
        //stockChartView.rightAxis.axisMaximum = stockPrice.max()!
        stockChartView.leftAxis.axisMaximum = vol.max()!
        
//        let stringArray = stockPrice.map { String($0) }
//        let otherStringArray = vol.map { String($0) }
//        print(stringArray)
//
//        let leftFormatter = CustomYAxisLabelValueFormatter()
//        leftFormatter.Ylabels = otherStringArray
//
//        let rightFormatter = CustomYAxisLabelValueFormatter()
//        rightFormatter.Ylabels = stringArray
        
        //stockChartView.animate(xAxisDuration: 2, yAxisDuration: 2)
//        stockChartView.leftAxis.valueFormatter = leftFormatter
//        stockChartView.rightAxis.valueFormatter = rightFormatter
        
        
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
    
   
    
    @IBAction func segmentTapped(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            performSegue(withIdentifier: "toNewsVC", sender: self)
        default:
            break
        }
        
    }
    
    

    
    
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
