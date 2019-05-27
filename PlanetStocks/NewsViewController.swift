//
//  NewsViewController.swift
//  PlanetStocks
//
//  Created by Omar Tehsin on 2019-05-21.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NewsViewController: UIViewController {
    @IBOutlet weak var newsTableView: UITableView!
    var api = "pmew5pipmigx109vcailn67fmvgcirgwzgbznvq3"
    var titleArray = [String]()
    var imageURLArray = [String]()
    var newsURLArray = [String]()
    var dateArray = [String]()
    //var articleDict : [String : Any] = [:]
    var theInput = String()
    var stockVC = StockChartViewController()
    
    var stockChartVC = StockChartViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableView.delegate = self
        newsTableView.dataSource = self
        getNews(input: theInput)
    }

    
    func getNews(input: String) {
        
        let url = URL(string: "https://stocknewsapi.com/api/v1?tickers=\(input)&items=10&fallback=true&token=\(api)")!
        
        
        
        Alamofire.request(url).responseJSON { (response) in
            if let jsonValue = response.result.value {
                let json = JSON(jsonValue)
                
                
                for(_, subJSON) in json["data"]{
                    if let theTitle = subJSON["title"].rawString(), let imageURL = subJSON["image_url"].rawString(),
                        let newsURL = subJSON["news_url"].rawString(),
                        let theDate = subJSON["date"].rawString(){
                        self.titleArray.append(theTitle)
                        self.imageURLArray.append(imageURL)
                        self.newsURLArray.append(newsURL)
                        self.dateArray.append(theDate)
                    }
                    //print(self.newsURLArray)
                    
                }
                
                DispatchQueue.main.async {
                    self.newsTableView.reloadData()
                    //print(self.titleArray)
                }
                
                
            }
            
        }
        
        
        
    }

    
    
    
}

class NewsTableCell : UITableViewCell {
    @IBOutlet weak var newPicView: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var dateTitleLabel: UILabel!
    
}




extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newsCell = newsTableView.dequeueReusableCell(withIdentifier: "newsCell") as! NewsTableCell
        newsCell.newsTitleLabel.text = titleArray[indexPath.row]
        newsCell.dateTitleLabel.text = dateArray[indexPath.row]
        
        let newsImageURL = imageURLArray[indexPath.row]
        let url = URL(string: newsImageURL)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async {
                newsCell.imageView?.image = UIImage(data: data!)
            }
            
            }.resume()
        
        
        
        return newsCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlString = self.newsURLArray[indexPath.row]
        
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    
}


//class NewsInfor: NSDictionary {
//
//}
