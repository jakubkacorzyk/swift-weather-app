//
//  ViewController.swift
//  weatherKacorzyk
//
//  Created by Student on 11.10.2018.
//  Copyright © 2018 agh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var img: UIImageView!

    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var rain: UITextField!
    @IBOutlet weak var maxTemp: UITextField!
    @IBOutlet weak var minTemp: UITextField!
    @IBOutlet weak var pressure: UITextField!
    @IBOutlet weak var windSpeed: UITextField!
    @IBOutlet weak var windDirection: UITextField!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previewButton: UIButton!
    
    var weather : [[String : Any]] = []
    var currentIndex = 0
    
    let doubleFormat = ".2"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.GetManyDayData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func GetManyDayData() {
        let urlString = "https://www.metaweather.com/api/location/44418/"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }

            guard let data = data else { return }
           
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            
            if let dictionary = json as? [String:Any]{
                if let weather_data = dictionary["consolidated_weather"] as? [[String:Any]]{
                    self.weather = weather_data
                    self.updateView()
                    
                }
            }
        
        }.resume()
    }
    
    func downloadImage(imgName : String) {
        let urlString = "https://www.metaweather.com/static/img/weather/png/" + imgName + ".png"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                self.img.image = UIImage(data : data)
            }
            
            }.resume()
    }
    
    func updateView(){
        DispatchQueue.main.async {
            let dayData = self.weather[self.currentIndex]
            self.date.text = (dayData["applicable_date"] as? String)
            self.minTemp.text = (((dayData["min_temp"] as? Double)?.format(f: self.doubleFormat))?.description ?? "") + " °C"
            self.maxTemp.text = (((dayData["max_temp"] as? Double)?.format(f: self.doubleFormat))?.description ?? "") + " °C"
            self.windSpeed.text = (((dayData["wind_speed"] as? Double)?.format(f: self.doubleFormat))?.description ?? "") + " km/h"
            self.windDirection.text = (((dayData["wind_direction"] as? Double)?.format(f: self.doubleFormat))?.description ?? "") + " °"
            self.pressure.text = (((dayData["air_pressure"] as? Double)?.format(f: self.doubleFormat))?.description ?? "") + " hPa"
            self.rain.text = ((dayData["predictability"] as? Int)?.description ?? "") + " %"
            self.downloadImage(imgName: dayData["weather_state_abbr"] as? String ?? "c")
            
            
            if self.currentIndex >= self.weather.count - 1 {
                self.nextButton.isEnabled = false
            }
            else if self.nextButton.isEnabled == false{
                self.nextButton.isEnabled = true
            }
            
            if self.currentIndex < 1 {
                self.previewButton.isEnabled = false
            }
            else if self.previewButton.isEnabled == false{
                self.previewButton.isEnabled = true
            }
            
        }
        return
    }
    
    @IBAction func previewClick(_ sender: Any) {
        self.currentIndex = self.currentIndex - 1
        updateView()
    }
    @IBAction func nextClick(_ sender: Any) {
        self.currentIndex = self.currentIndex + 1
        updateView()
    }
    
}

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
