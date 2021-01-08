//
//  WeatherModel.swift
//  FoodPin
//
//  Created by 胡嘉樺 on 2021/1/8.
//  Copyright © 2021 NDHU_CSIE. All rights reserved.
//

import Foundation
 
struct WeatherModel: Decodable {
    
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: UInt64
    let sys: Sys
    let timezone: Int64
    let id: Int
    let name: String
    
}

struct Coord: Decodable {
    let lon: Double
    let lat: Double
}

struct Weather: Decodable {
    let description: String
    let icon: String
    let id: Int
    let main: String
}

struct Main: Decodable {
    let humidity: Int
    let pressure: Int
    let temp: Double
    let temp_max: Double
    let temp_min: Double
}

struct Wind: Decodable {
    let deg: Int
    let speed: Double
    let gust: Double?
}

struct Clouds: Decodable {
    let all: Int
}

struct Sys: Decodable {
    let country: String
    let id: Int?
    let message: Double?
    let sunrise: UInt64
    let sunset: UInt64
    let type: Int?
}
