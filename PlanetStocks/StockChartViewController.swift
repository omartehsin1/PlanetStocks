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
    
    @IBOutlet weak var indicatorTextField: UITextField!
    var inputString = String()
    var companySearchArray = [String]()
    @IBOutlet weak var stockChartView: LineChartView!
    @IBOutlet weak var barChartView: BarChartView!
    let myPickerData = ["Daily", "5 Min", "15 Min", "30 Min", "60 Min"]
    
    
    
    var dailyStockPrice = [Double]()
    var fiveMinStockPrice = [Double]()
    var vol = [Double]()
    var theDates = [String]()
    var doubleDates = [Double]()
    let homeVC = HomeViewController()
    var symb = String()
    var theAPI = String()
    var theDailyResultsArray : [String: String] = [:]
    var the5MinResultsArray : [String: String] = [:]
    var the15MinResultsArray : [String: String] = [:]
    var the30MinResultsArray : [String: String] = [:]
    var the60MinResultsArray : [String: String] = [:]
    var theVolumeArray : [String: String] = [:]
    let thePicker = UIPickerView()
    //var api = "JOW9MYUHX9HWJTDE"
    
    //var api = "LI32913MGB8ROSV6"
    override func viewDidLoad() {
        super.viewDidLoad()
        searchDailyStockPrice(input: symb, api: theAPI)
        
        if indicatorTextField.text!.isEmpty {
            indicatorTextField.text = myPickerData[0]
        }
        //search5MinStockPrice(input: symb, api: theAPI)
        for key in theDailyResultsArray.keys.sorted(by: <) {
            let price = Double(theDailyResultsArray[key]!)!
            let volume = Double(theVolumeArray[key]!)!
            dailyStockPrice.append(price)
            vol.append(volume)
            theDates.append(key)
        }
//        let firstFive = dailyStockPrice.prefix(5)
//        print(firstFive)
        
        for key in the5MinResultsArray.keys.sorted(by: <) {
            let price = Double(the5MinResultsArray[key]!)!
            fiveMinStockPrice.append(price)
        }
        
        
        indicatorTextField.inputView = thePicker
        thePicker.delegate = self
        thePicker.dataSource = self
        createToolBar()
        

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        stockChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInSine)
        generateLineData(datapoints: theDates, values: dailyStockPrice)
    }
    
    func createToolBar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        indicatorTextField.inputAccessoryView = toolbar
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func searchDailyStockPrice(input: String, api: String) {
        let url = URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=\(input)&apikey=\(api)")! 
        
        let data = NSData(contentsOf: url)
        
        do {
            let results = try JSON(data: data! as Data)
            for (key, subJSON) in results["Time Series (Daily)"] {
                let open = subJSON["1. open"].rawString()
                let volume = subJSON["5. volume"].rawString()
                theDailyResultsArray[key] = open
                theVolumeArray[key] = volume
                
            }
            
            
        } catch  {
            print("ERROR")
        } //78
        
    }
    func search5MinStockPrice(input: String, api: String) {
        let url = URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=\(input)&interval=5min&outputsize=full&apikey=\(api)")!
        let data = NSData(contentsOf: url)
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDate = formatter.string(from: date)
        print("The current date is: \(currentDate)")
        
        do {
            let results = try JSON(data: data! as Data)
            for (key, subJSON) in results["Time Series (5min)"] {
                let close = subJSON["4. close"].rawString()
                the5MinResultsArray[key] = close
                
            }
            //print(the5MinResultsArray)
            
            
        } catch  {
            print("ERROR")
        }
        let filter = "2019-06-03"
        let result = the5MinResultsArray.filter {$0.key.contains(filter)}
        print(result)
    }
    
    
    
    
    func search15MinStockPrice(input: String, api: String) {
        let url = URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=\(input)&interval=15min&outputsize=full&apikey=\(api)")!
        let data = NSData(contentsOf: url)
        
        do {
            let results = try JSON(data: data! as Data)
            for (key, subJSON) in results["Time Series (Daily)"] {
                let close = subJSON["4. close"].rawString()
                the15MinResultsArray[key] = close
                
            }
            
            
        } catch  {
            print("ERROR")
        }
        
    }
    func search30MinStockPrice(input: String, api: String) {
        let url = URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=\(input)&interval=30min&outputsize=full&apikey=\(api)")!
        let data = NSData(contentsOf: url)
        
        do {
            let results = try JSON(data: data! as Data)
            for (key, subJSON) in results["Time Series (Daily)"] {
                let close = subJSON["4. close"].rawString()
                the30MinResultsArray[key] = close
                
            }
            
            
        } catch  {
            print("ERROR")
        }
        
    }
    
    
    func search60MinStockPrice(input: String, api: String) {
        let url = URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=\(input)&interval=60min&outputsize=full&apikey=\(api)")!
        let data = NSData(contentsOf: url)
        
        do {
            let results = try JSON(data: data! as Data)
            for (key, subJSON) in results["Time Series (Daily)"] {
                let close = subJSON["4. close"].rawString()
                the60MinResultsArray[key] = close
                
            }
            
            
        } catch  {
            print("ERROR")
        }
        
    }

    @IBAction func searchBTNPressed(_ sender: Any) {
        if indicatorTextField.text == "Daily" {
            searchDailyStockPrice(input: symb, api: theAPI)
        }
        
        if indicatorTextField.text == "5 Min" {
            search5MinStockPrice(input: symb, api: theAPI)
        }
    }
    
    
    
    
    func generateLineData(datapoints: [String], values: [Double]) {
        
        
        var lineChartEntry = [ChartDataEntry]()
        for i in 0 ..< values.count {
            let value = ChartDataEntry(x: Double(i), y: values[i])
            lineChartEntry.append(value)
        }
        
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Price")
        let data = LineChartData()
        data.addDataSet(line1)
        line1.colors = [NSUIColor.blue]
        line1.circleRadius = 1
        //line1.fillAlpha = 1
        //line1.drawFilledEnabled = true
        //line1.fillColor = .blue
        
        //Gradient Fill
        let gradientColors = [UIColor.blue.cgColor, UIColor.clear.cgColor] as CFArray
        let colorLocations: [CGFloat] = [1.0, 0.0]
        guard let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) else { print("gradient error"); return }
        line1.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
        line1.drawFilledEnabled = true

        
        
        //Axes SetUp
        stockChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: datapoints)
        stockChartView.xAxis.labelPosition = .bottom
        stockChartView.xAxis.drawGridLinesEnabled = false
        stockChartView.chartDescription?.enabled = false
        stockChartView.legend.enabled = true
        stockChartView.rightAxis.enabled = false
        stockChartView.leftAxis.drawGridLinesEnabled = false
        stockChartView.leftAxis.drawLabelsEnabled = true
        
        stockChartView.data = data

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

extension StockChartViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return myPickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        indicatorTextField.text = myPickerData[row]
    }
}


