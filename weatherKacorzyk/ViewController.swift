//
//  ViewController.swift
//  weatherKacorzyk
//
//  Created by Student on 11.10.2018.
//  Copyright © 2018 agh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var dayName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func GetOneDayData(dayNymber : Int) {
        let urlString = URL(string: "https://www.metaweather.com/api/#locationday")
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    
                } else {
                    if let usableData = data {
                        
                    }
                }
            }
            task.resume()
    }
}

