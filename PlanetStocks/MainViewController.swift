//
//  ViewController.swift
//  PlanetStocks
//
//  Created by Omar Tehsin on 2019-05-16.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {
    var homeVC = HomeViewController()
    var symb = String()
    var theAPI = String()
    var theStocksArray = [String]()
    var theInvestedArray = [Double]()

    @IBOutlet weak var newView: UIView!
    @IBOutlet weak var stockChartView: UIView!
    @IBOutlet weak var portfolioView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = symb
        //print("The symbol is: \(symb)")
        stockChartView.isHidden = false
        newView.isHidden = true
        portfolioView.isHidden = true
    }

    

    @IBAction func segmentTapped(_ sender: UISegmentedControl) {

        switch sender.selectedSegmentIndex {
        case 0:
            stockChartView.isHidden = false
            newView.isHidden = true
            portfolioView.isHidden = true
        case 1:
            stockChartView.isHidden = true
            newView.isHidden = false
            portfolioView.isHidden = true
        case 2:
            stockChartView.isHidden = true
            newView.isHidden = true
            portfolioView.isHidden = false
        default:
            break
        }

    }
    
    
    
    
    
//    @IBAction func stockButtonPressed(_ sender: Any) {
//        performSegue(withIdentifier: "toStockChartVC", sender: self)
//    }
//    
//    @IBAction func newsButtonPressed(_ sender: Any) {
//        performSegue(withIdentifier: "toNewsVC", sender: self)
//    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toStockChartVC" {
            let stockChartVC = segue.destination as! StockChartViewController
            stockChartVC.symb = symb
            stockChartVC.theAPI = theAPI
            //present(stockChartVC, animated: true, completion: nil)
        } else if segue.identifier == "toNewsVC" {
            let newsVC = segue.destination as! NewsViewController
            newsVC.theInput = symb
            //present(newsVC, animated: true, completion: nil)
        } else if segue.identifier == "toAllocationVC" {
            let roiVC = segue.destination as! AllocationROIViewController
            //roiVC.stocks = theStocksArray
           // roiVC.dollarsInvested = theInvestedArray

        }
        
        
    }
    
    


    
}


