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
    @IBOutlet weak var stockChartView: UIView!
    @IBOutlet weak var newView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func segmentTapped(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            stockChartView.isHidden = true
            newView.isHidden = false
        case 1:
            stockChartView.isHidden = false
            newView.isHidden = true
        default:
            break
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toStockChartVC" {
            let stockChartVC = segue.destination as! StockChartViewController
            present(stockChartVC, animated: true, completion: nil)
        } else if segue.identifier == "toNewsVC" {
            let newsVC = segue.destination as! NewsViewController
            present(newsVC, animated: true, completion: nil)
        }
        
        
    }
    
    

    
    
}


