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
    @IBOutlet weak var stockChartView: LineChartView!
    var lineChartEntry = [ChartDataEntry]()
    let dropDown = DropDown()
    var symb = String()
    var theResultsArray : [String: String] = [:]
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
        
//        var dateArray = [String]()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-mm-dd"
        do {
            let results = try JSON(data: data! as Data)
            for (key, subJSON) in results["Time Series (Daily)"] {
                let open = subJSON["1. open"].rawString()
                theResultsArray[key] = open
                //print(theResultsArray)
            }
            
            let sortedKeysAndValues = Array(theResultsArray.keys).sorted(by: <)
            //sortedKeysAndValues.hashValue
            //            theResultsArray = [String: String](uniqueKeysWithValues: theResultsArray.sorted { $0.key < $1.key})
            print(sortedKeysAndValues)
            //print(sortedKeysAndValues.hashValue)
            
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
        print(theResultsArray.values)
    }
    
    
    
}

extension String {
    static let shortDateUS: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateStyle = .short
        return formatter
    }()
    var shortDateUS: Date? {
        return String.shortDateUS.date(from: self)
    }
}

