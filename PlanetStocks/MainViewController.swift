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
class MainViewController: UIViewController {
    var symb = String()
    var theAPI = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = symb
        print("The symbol is: \(symb)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    

//    @IBAction func segmentTapped(_ sender: UISegmentedControl) {
//
//        switch sender.selectedSegmentIndex {
//        case 0:
//            stockChartView.isHidden = true
//            newView.isHidden = false
//        case 1:
//            stockChartView.isHidden = false
//            newView.isHidden = true
//        default:
//            break
//        }
//
//    }
    
    
    
    
    
    @IBAction func stockButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "toStockChartVC", sender: self)
    }
    
    @IBAction func newsButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "toNewsVC", sender: self)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toStockChartVC" {
            let stockChartVC = segue.destination as! StockChartViewController
            stockChartVC.symb = symb
            stockChartVC.theAPI = theAPI
            present(stockChartVC, animated: true, completion: nil)
        } else if segue.identifier == "toNewsVC" {
            let newsVC = segue.destination as! NewsViewController
            newsVC.theInput = symb
            present(newsVC, animated: true, completion: nil)
        }
        
        
    }
    
    


    
}

