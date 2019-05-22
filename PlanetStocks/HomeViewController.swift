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
    //var api = "JOW9MYUHX9HWJTDE"
    var api = "9TR204K3GERJQJ33"
    //var api = "LI32913MGB8ROSV6"
    let dropDown = DropDown()
    var stocks = [Stocks]()
    
    
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
        
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        //stockSearch(input: symbol)
    }
    @IBAction func clearButtonPressed(_ sender: Any) {
        stockSearchTextField.text = ""
    }
    
    func stockSearch(input: String, completion: @escaping ([String]) ->()) {
        var resultsArray = [String]()
        let url = URL(string: "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(stockSearchTextField.text!)&apikey=\(api)")!
        //print(url)
        Alamofire.request(url).responseJSON { (response) in
            if let jsonValue = response.result.value {
                let json = JSON(jsonValue)
                
                for(_, subJSON) in json["bestMatches"] {
                    if let name = subJSON["2. name"].rawString(), let symb = subJSON["1. symbol"].rawString() {
                        self.symbol = symb
                        self.companyName = name
                        let result = "\(symb)"
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
            print("Selected item: \(item) at index: \(index)")
            //            let arr = item.split(separator: " ")
            //            let s = String(arr[0])
            self.stockSearchTextField.text = item
        }
        stockSearch(input: stockSearchTextField.text!) { (resultsArr) in
            self.dropDown.dataSource = resultsArr
            self.dropDown.show()
            
            //print(resultsArr)
        }
        
    }

    @IBAction func saveTapped(_ sender: Any) {
        
        let savedStocks = Stocks(context: PersistanceService.context)
        savedStocks.company = companyName
        savedStocks.symbol = symbol
        PersistanceService.saveContext()
        stocks.append(savedStocks)
        myStocksTableView.reloadData()
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
        cell.companyName.text = stocks[indexPath.row].company
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
    
    
}
