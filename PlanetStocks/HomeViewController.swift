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
    var symbolArray = [String]()
    var theSymbol = String()
    var newCellSymbol = String()
    //var api = "JOW9MYUHX9HWJTDE"
    var api = "9TR204K3GERJQJ33"
    //var api = "LI32913MGB8ROSV6"
    let dropDown = DropDown()
    var stocks = [Stocks]()
    var stocksArray = [String]()
    var investedArray = [Double]()
    
    var cellSymbolArray = [String]()
    
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
//        print(newSymbol)
        //symbolArray.append(newSymbol[0])
        theSymbol = newSymbol[0]
        
        performSegue(withIdentifier: "goToMain", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
                    if let name = subJSON["2. name"].rawString(), let symb = subJSON["1. symbol"].rawString() {
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

    @IBAction func saveTapped(_ sender: Any) {
        
        
        if stockSearchTextField.text == "" {
            let alert = UIAlertController(title: "Invalid Search", message: "Please Enter Stock", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
        
        else  {
            let alert = UIAlertController(title: symbol, message: "Enter Quantity and Share Price", preferredStyle: .alert)
//            alert.addTextField(configurationHandler: nil)
//            alert.addTextField(configurationHandler: nil)
            
            alert.addTextField { (textfield) in
                textfield.placeholder = "Enter Share Quantity"
                textfield.keyboardType = .decimalPad
            }
            
            alert.addTextField { (textfield) in
                textfield.placeholder = "Enter Price Per Share"
                textfield.keyboardType = .decimalPad
            }
//
//            alert.textFields![0].placeholder = "Enter Share Quantity"
//            alert.textFields![0].keyboardType = UIKeyboardType.decimalPad
//            alert.textFields![1].placeholder = "Enter Pice Per Share"
//            alert.textFields![1].keyboardType = UIKeyboardType.decimalPad
            //let share = alert.textfield![0].text
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                print("Cancelled")
            }))
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
                let savedStocks = Stocks(context: PersistanceService.context)
                savedStocks.company = self.companyName
                savedStocks.symbol = self.symbol
                self.stocksArray.append(savedStocks.symbol!)
                
                
                //print("Company name is: \(savedStocks.company!)")
                //print("Symbol is: \(savedStocks.symbol!)")
                let shares = alert.textFields![0].text!
                let price = alert.textFields![1].text!
                
                savedStocks.shares = Double(shares)!
                savedStocks.price = Double(price)!
                
                let invested = savedStocks.shares * savedStocks.price
                self.investedArray.append(invested)
                
                PersistanceService.saveContext()
                self.stocks.append(savedStocks)
                print(self.stocks)
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
        return stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myStocksTableView.dequeueReusableCell(withIdentifier: "stockCell") as! MyStockCell
        //cell.companyName.text = stocks[indexPath.row].company
        cell.stockSymbol.text = stocks[indexPath.row].symbol
        
        
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
