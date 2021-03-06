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
    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var humidityText: UILabel!
    @IBOutlet weak var pressureText: UILabel!
    @IBOutlet weak var sunRiseText: UILabel!
    @IBOutlet weak var sunSetText: UILabel!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var kittyImg: UIImageView!
    
    
    @IBAction func refrash(_ sender: Any) {
        refresh()
    }
    @IBAction func refrashKitty(_ sender: Any) {
        refreshKitty()
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
            locationManager.requestLocation()
        }
        
        weatherImg.backgroundColor = UIColor(hex: "#5500dcdc")
        weatherImg.roundedImage()
        callTheCatAPI()
        
    }
    
    // MARK: refresh loc
    func refresh() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
    }
    
    // MARK: refresh Kitty
    func refreshKitty() {
        callTheCatAPI()
    }
    
    
    // MARK: CallAPI and update View
    
    private func callOpenWeatherAPI() {
        // 根據網站的 Request tab info 我們拼出請求的網址
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?" +
                        "lat=\(String(format: "%f", lat))" +
                        "&lon=\(String(format: "%f", lon))" +
                        "&appid=\(apiKey)" +
                        "&lang=zh_tw" +
                        "&units=metric")!
        print("On calling OpenWeather API with \n url: \(url) \n")
        
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
                    self.tempText.text = "溫度： \(weatherModel.main.temp)°C"
                    
                    self.descriptionText.text = weatherModel.weather[0].description
                    self.humidityText.text = "濕度： \(weatherModel.main.humidity)%"
                    self.pressureText.text = "氣壓： \(weatherModel.main.pressure)hPa"
                    
                    // date/time formatter
                    let datefomatter = DateFormatter()
                    datefomatter.timeZone = TimeZone(secondsFromGMT: weatherModel.timezone)
                    datefomatter.locale = Locale(identifier: "zh_Hant_TW")
                    datefomatter.dateFormat = "MM 日 DD 月"
                    
                    let timefomatter = DateFormatter()
                    timefomatter.timeZone = TimeZone(secondsFromGMT: weatherModel.timezone)
                    timefomatter.locale = Locale(identifier: "zh_Hant_TW")
                    timefomatter.dateFormat = "HH:mm"
                    
                    let dateStr = datefomatter.string(from: Date(timeIntervalSince1970: TimeInterval(weatherModel.sys.sunrise)))
                    
                    let sunRiseStr = timefomatter.string(from: Date(timeIntervalSince1970: TimeInterval(weatherModel.sys.sunrise)))
                    let sunSetStr = timefomatter.string(from: Date(timeIntervalSince1970: TimeInterval(weatherModel.sys.sunset)))
                    
                    self.dateText.text = dateStr
                    self.sunRiseText.text = "日出時間： \(sunRiseStr)"
                    self.sunSetText.text = "日落時間： \(sunSetStr)"
                    
                    
                    
                    let iconURL:URL = URL(string: "https://openweathermap.org/img/wn/\(weatherModel.weather[0].icon)@2x.png")!
                    self.weatherImg.loadImg(withUrl: iconURL)
                }
                
            } catch {
                print(error)
            }
            
        })
        
        // 啟動 task
        dataTask.resume()
    }
    
    private func callTheCatAPI() {
        // 根據網站的 Request tab info 我們拼出請求的網址
        let url = URL(string: "https://api.thecatapi.com/v1/images/search")!
        print("On calling TheCat API with \n url: \(url) \n")
        
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
                let cat = try JSONDecoder().decode([Cat].self, from: data)
                print(cat)
                DispatchQueue.main.async {
                    let kittyImgSource:URL = URL(string: "\(cat[0].url)")!
                    self.kittyImg.loadImgToSquare(withUrl: kittyImgSource)
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
        self.lon = locValue.longitude
        self.lat = locValue.latitude
        callOpenWeatherAPI()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

}

func cropImageToSquare(image: UIImage) -> UIImage? {
    var imageHeight = image.size.height
    var imageWidth = image.size.width

    if imageHeight > imageWidth {
        imageHeight = imageWidth
    }
    else {
        imageWidth = imageHeight
    }

    let size = CGSize(width: imageWidth, height: imageHeight)

    let refWidth : CGFloat = CGFloat(image.cgImage!.width)
    let refHeight : CGFloat = CGFloat(image.cgImage!.height)

    let x = (refWidth - size.width) / 2
    let y = (refHeight - size.height) / 2

    let cropRect = CGRect(x: x, y: y, width: size.height, height: size.width)
    if let imageRef = image.cgImage!.cropping(to: cropRect) {
        return UIImage(cgImage: imageRef, scale: 0, orientation: image.imageOrientation)
    }

    return nil
}

// MARK: UI extentions

extension UIImageView {
    // load img from url
    func loadImg(withUrl url: URL) {
           DispatchQueue.global().async { [weak self] in
               if let imageData = try? Data(contentsOf: url) {
                   if let image = UIImage(data: imageData) {
                       DispatchQueue.main.async {
                           self?.image = image
                       }
                   }
               }
           }
       }
    
    // load img from url
    func loadImgToSquare(withUrl url: URL) {
           DispatchQueue.global().async { [weak self] in
               if let imageData = try? Data(contentsOf: url) {
                   if let image = UIImage(data: imageData) {
                       DispatchQueue.main.async {
                        self?.image = cropImageToSquare(image: image)
                       }
                   }
               }
           }
       }
    
    
    // make imageView round shape
    func roundedImage() {
        self.layer.cornerRadius = (self.frame.size.width) / 2;
        self.clipsToBounds = true
        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor.white.cgColor
    }
    
}


extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    a = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    r = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}


