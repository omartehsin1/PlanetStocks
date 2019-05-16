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
class ViewController: UIViewController {
    //API KEY: 9TR204K3GERJQJ33
    @IBOutlet weak var inputTyped: UITextField!
    var inputString = String()
    var companySearchArray = [String]()
    
    let dropDown = DropDown()
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
        let url = URL(string: "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(inputTyped.text!)&apikey=9TR204K3GERJQJ33")!
        print(url)
        Alamofire.request(url).responseJSON { (response) in
            if let jsonValue = response.result.value {
                let json = JSON(jsonValue)

                for(_, subJSON) in json["bestMatches"] {
                    if let name = subJSON["2. name"].rawString(), let symbol = subJSON["1. symbol"].rawString() {
                        let result = "\(symbol) - \(name)"
                        resultsArray.append(result)
                    }
                }
            }
            completion(resultsArray)
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
//        inputString = inputTyped.text!
//        print(inputString)
//        stockSearch(input: inputTyped.text!) { (resultsArr) in
//            print(resultsArr)
//        }
        
        
    }
    

    
}

