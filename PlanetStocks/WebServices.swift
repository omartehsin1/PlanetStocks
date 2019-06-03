//
//  StockData.swift
//  PlanetStocks
//
//  Created by Omar Tehsin on 2019-05-17.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WebServices{

}


//    func generateBarChart() {
//        var barChartEntry: [BarChartDataEntry] = [BarChartDataEntry]()
//        for i in 0 ..< vol.count {
//            let value = BarChartDataEntry(x: Double(i), y: vol[i])
//            barChartEntry.append(value)
//        }
//
//        let volBars = BarChartDataSet(entries: barChartEntry, label: "Volume")
//        volBars.setColor(UIColor(red: 60/255, green: 220/255, blue: 78/255, alpha: 1))
//        let groupSpace = 0.06
//        let barSpace = 0.02
//        let barWidth = 0.45
//
//
//        let data = BarChartData(dataSet: volBars)
//        data.barWidth = barWidth
//        data.groupBars(fromX: 0, groupSpace: groupSpace, barSpace: barSpace)
//
//
//        barChartView.data = data
//        barChartView.chartDescription?.text = "Volume"
//        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
//        barChartView.leftAxis.labelTextColor = .white
//
//    }


//    func convertCombined(dataEntryX forX:[String],dataEntryY forY: [Double], dataEntryZ forZ: [Double]) {
//        var dataEntries: [BarChartDataEntry] = []
//        var dataEntrieszor: [ChartDataEntry] = [ChartDataEntry]()
//        for (i, v) in forY.enumerated() {
//            let dataEntry = ChartDataEntry(x: Double(i), y: v, data: forX as AnyObject?)
//            dataEntrieszor.append(dataEntry)
//        }
//
//        for (i, v) in forZ.enumerated() {
//            let dataEntry = BarChartDataEntry(x: Double(i), y: v, data: forX as AnyObject?)
//            dataEntries.append(dataEntry)
//
//        }
//        //let max = stockPrice.max()
//
//        let lineChartSet = LineChartDataSet(entries: dataEntrieszor, label: "Stock Price")
//        let lineChartData = LineChartData(dataSets: [lineChartSet])
//
//
//
//        let barChartSet = BarChartDataSet(entries: dataEntries, label: "Volume")
//        let barChartData = BarChartData(dataSets: [barChartSet])
//
//        //ui
//        lineChartSet.setColor(UIColor.red)
//        lineChartSet.setCircleColor(UIColor.red)
//
//        let comData = CombinedChartData(dataSets: [lineChartSet,barChartSet])
//        comData.barData = barChartData
//        comData.lineData = lineChartData
//
//
//        stockChartView.data = comData
//        stockChartView.notifyDataSetChanged()
//        stockChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: theDates)
//        stockChartView.xAxis.granularity = 1
//        stockChartView.rightAxis.axisMaximum = stockPrice.max()!
//        stockChartView.leftAxis.axisMaximum = vol.max()!
//    }
