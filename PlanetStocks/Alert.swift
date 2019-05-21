//
//  Alert.swift
//  PlanetStocks
//
//  Created by Omar Tehsin on 2019-05-21.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import Foundation
import UIKit

struct Alert {
    private static func showBasicAction(on vc: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
        
    }
    
    static func showIncompleteFormAlert(on vc: UIViewController) {
        showBasicAction(on: vc, with: "Incomplete Form", message: "Please Input a Stock Symbol")
    }
    
}
