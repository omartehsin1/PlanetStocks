//
//  HomeViewController.swift
//  PlanetStocks
//
//  Created by Omar Tehsin on 2019-05-22.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
import SwiftyJSON
import CoreData


class HomeViewController: UIViewController {
    var symbol = String()
    var companyName = String()
    var theSymbol = String()
    var newCellSymbol = String()
    var api = "JOW9MYUHX9HWJTDE"
    //var api = "9TR204K3GERJQJ33"
    //var api = "LI32913MGB8ROSV6"
    let dropDown = DropDown()
    var stocks = [Stocks]()
    var stocksArray = [String]()
    var investedArray = [Double]()
    var theClosePriceDict : [String : String] = [:]
    var closePriceArray = [String]()
    
    
    @IBOutlet weak var stockSearchTextField: UITextField!

    @IBOutlet weak var myStocksTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stockSearchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        myStocksTableView.delegate = self
        myStocksTableView.dataSource = self
        
        let fetchRequest: NSFetchRequest<Stocks> = Stocks.fetchRequest()
        do {
            let stocks = try PersistanceService.context.fetch(fetchRequest)
            self.stocks = stocks
            self.myStocksTableView.reloadData()
        } catch {}
        
        //print(stocks)
//        let anotherFetchRequest: NSFetchRequest<Stocks> = Stocks.fetchRequest()
//        anotherFetchRequest.predicate = NSPredicate.init(format: "id==\(0x60000270cb20)")
//        do {
//            let objects = try PersistanceService.context.fetch(anotherFetchRequest)
//            for object in objects {
//                PersistanceService.context.delete(object)
//            }
//            PersistanceService.saveContext()
//        } catch {
//            print(error)
//        }
        
        

        // Do any additional setup after loading the view.
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        setUpDropDown()
        stockSearch(input: stockSearchTextField.text!) { (resultsArr) in
            self.dropDown.dataSource = resultsArr
            self.dropDown.show()
            
        }
        
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        let newSymbol = symbol.components(separatedBy: " ")
        theSymbol = newSymbol[0]
        print("The symbol after search is \(theSymbol)")
        
        performSegue(withIdentifier: "goToMain", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let savedStocks = Stocks(context: PersistanceService.context)
        let mainVC = segue.destination as! MainViewController
        if segue.identifier == "goToMain" {
            
            mainVC.symb = theSymbol
            mainVC.theAPI = api
            mainVC.theStocksArray = stocksArray
            mainVC.theInvestedArray = investedArray
            
        }
        else if segue.identifier == "goToMainFromCell" {
            mainVC.symb = newCellSymbol
            mainVC.theAPI = api
        }
        
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        stockSearchTextField.text = ""
    }
    
    func stockSearch(input: String, completion: @escaping ([String]) ->()) {
        var resultsArray = [String]()
        
        let url = URL(string: "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(stockSearchTextField.text!)&apikey=\(api)")!
        
        Alamofire.request(url).responseJSON { (response) in
            if let jsonValue = response.result.value {
                let json = JSON(jsonValue)
                
                for(_, subJSON) in json["bestMatches"] {
                    if let name = subJSON["2. name"].rawString(), let symb = subJSON["1. symbol"].rawString(), let theLastPrice = subJSON["4. close"].rawString() {
                        self.symbol = symb
                        self.companyName = name
                        let result = "\(symb) - \(name)"
                        
                        resultsArray.append(result)
                    }
                }
                
            }
            completion(resultsArray)
            
        }
        
        
    }
    
    
    
    func setUpDropDown() {
        dropDown.anchorView = stockSearchTextField
        dropDown.bottomOffset = CGPoint(x: 0, y: stockSearchTextField.bounds.height)
        dropDown.direction = .any
        dropDown.dismissMode = .onTap
        DropDown.appearance().backgroundColor = UIColor(white: 1, alpha: 0.8)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            
            self.symbol = item
            print("Selected item: \(item) at index: \(index)")

            self.stockSearchTextField.text = item
        }
    }
    func lastStockPrice(input: String, api: String) {
        let url = URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=\(input)&apikey=\(api)")!
        
        print(url)
        let data = NSData(contentsOf: url)
        
        do {
            let results = try JSON(data: data! as Data)
            for (key, subJSON) in results["Time Series (Daily)"] {
                let close = subJSON["4. close"].rawString()
                theClosePriceDict[key] = close
  
            }
            
            
            
        } catch  {
            print("ERROR")
        }
        
    }

    @IBAction func saveTapped(_ sender: Any) {
        
        
        if stockSearchTextField.text == "" {
            let alert = UIAlertController(title: "Invalid Search", message: "Please Enter Stock", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
        
        else  {
            let alert = UIAlertController(title: symbol, message: "Enter Quantity and Share Price", preferredStyle: .alert)

            alert.addTextField { (textfield) in
                textfield.placeholder = "Enter Share Quantity"
                textfield.keyboardType = .decimalPad
            }
            
            alert.addTextField { (textfield) in
                textfield.placeholder = "Enter Price Per Share"
                textfield.keyboardType = .decimalPad
            }

            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                print("Cancelled")
            }))
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
                let savedStocks = Stocks(context: PersistanceService.context)
                savedStocks.company = self.companyName
                savedStocks.symbol = self.symbol
                self.stocksArray.append(savedStocks.symbol!)

                let shares = alert.textFields![0].text!
                let price = alert.textFields![1].text!
                

                savedStocks.invested = Double(shares)! * Double(price)!
                self.investedArray.append(savedStocks.invested)
                
                
  
                let aSymbol = self.symbol.components(separatedBy: " ")
                let newSymbol = aSymbol[0]
                self.lastStockPrice(input: newSymbol, api: self.api)
                for key in self.theClosePriceDict.keys.sorted(by: <) {
                    savedStocks.closePrice = self.theClosePriceDict[key]!
                    self.closePriceArray.append(savedStocks.closePrice!)
                }
                let slicedLastNumbers = self.closePriceArray.suffix(2)
                let lastNumbers = Array(slicedLastNumbers)
                print(lastNumbers)
                let todaysClose = Double(lastNumbers[1])!
                let yesterdaysClose = Double(lastNumbers[0])!
                let difference = ((todaysClose - yesterdaysClose)/todaysClose) * 100
                let truncatedNumber = difference.truncate(places: 3)
                
                
                savedStocks.difference = String(truncatedNumber)
                
                   

                PersistanceService.saveContext()
                self.stocks.append(savedStocks)
                
                self.myStocksTableView.reloadData()
            }))
            
            self.present(alert, animated: true)
            
        }
        

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        stockSearchTextField.text = ""
    }
    

}

class MyStockCell : UITableViewCell {
    @IBOutlet weak var stockSymbol: UILabel!
    
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var stockPrice: UILabel!
    
    @IBOutlet weak var percentChange: UILabel!
    
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(stocks.count)
        return stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myStocksTableView.dequeueReusableCell(withIdentifier: "stockCell") as! MyStockCell
        cell.stockSymbol.text = stocks[indexPath.row].symbol
        
        
        cell.stockPrice.text = stocks[indexPath.row].closePrice

        
        cell.percentChange.text = "\(stocks[indexPath.row].difference ?? "")%"
        
        if (cell.percentChange.text?.hasPrefix("-"))! {
            cell.percentChange.textColor = .red
        } else {
            cell.percentChange.textColor = .green
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let commit = stocks[indexPath.row]
            PersistanceService.context.delete(commit)
            stocks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            PersistanceService.saveContext()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellSymbol = stocks[indexPath.row].symbol!
        let theCellSymbol = cellSymbol.components(separatedBy: " ")
        
        newCellSymbol = theCellSymbol[0]
        
        
        print(newCellSymbol)
        self.myStocksTableView.deselectRow(at: indexPath as IndexPath, animated: true)
        performSegue(withIdentifier: "goToMainFromCell", sender: self)
    }
    
    
}

extension Double
{
    func truncate(places : Int)-> Double
    {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}
