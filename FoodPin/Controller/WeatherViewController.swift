//
//  WeatherViewController.swift
//  FoodPin
//
//  Created by 胡嘉樺 on 2021/1/8.
//  Copyright © 2021 NDHU_CSIE. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var locText: UILabel!
    @IBOutlet weak var tempText: UILabel!
    
    @IBAction func refrash(_ sender: Any) {
        refresh()
    }
    
    let locationManager = CLLocationManager()
    var lon: Double!
    var lat: Double!
    
    let apiKey = "f042c4ccb330d1cbbf9b264e25a0f0b7"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    
    // MARK: refresh loc
    func refresh() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: CallAPI and update View
    
    private func callAPI() {
        // 根據網站的 Request tab info 我們拼出請求的網址
        print("https://api.openweathermap.org/data/2.5/weather?" +
                "lat=\(String(format: "%f", lat))" +
                "&lon=\(String(format: "%f", lon))" +
                "&appid=\(apiKey)" +
                "&units=metric")
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?" +
                        "lat=\(String(format: "%f", lat))" +
                        "&lon=\(String(format: "%f", lon))" +
                        "&appid=\(apiKey)" +
                        "&units=metric")!
        
        // 將網址組成一個 URLRequest
        var request = URLRequest(url: url)
        
        // 設置請求的方法為 GET
        request.httpMethod = "GET"
        
        // 建立 URLSession
        let session = URLSession.shared
        
        // 使用 sesstion + request 組成一個 task
        // 並設置好，當收到回應時，需要處理的動作
        let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            // 這邊是收到回應時會執行的 code
            
            // 因為 data 是 optional，有可能請求失敗，導致 data 是空的
            // 如果是空的，我們直接 return，不做接下來的動作
            guard let data = data else {
                return
            }
            
            do {
                // 使用 JSONDecoder 去解開 data
                let weatherModel = try JSONDecoder().decode(WeatherModel.self, from: data)
                print(weatherModel)
                DispatchQueue.main.async {
                    self.locText.text = weatherModel.name
                    let temp = "溫度： \(weatherModel.main.temp)°C"
                    self.tempText.text = temp
                }
                
            } catch {
                print(error)
            }
            
        })
        
        // 啟動 task
        dataTask.resume()
        
        
    }
    
    // MARK: Loacation part
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.longitude) \(locValue.latitude)")
        lon = locValue.longitude
        lat = locValue.latitude
        locationManager.stopUpdatingLocation()
        callAPI()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
}
