//
//  Restaurant.swift
//  FoodPin
//
//  Created by NDHU_CSIE on 2020/11/19.
//  Copyright © 2020 NDHU_CSIE. All rights reserved.
//

import UIKit
import CoreData

class Restaurant {
    var name: String
    var type: String
    var location: String
    var phone: String
    var summary: String
    var image: String
    var isVisited: Bool
    var rating: String
    
    init(name: String, type: String, location: String, phone: String, summary: String, image: String, isVisited: Bool) {
        self.name = name
        self.type = type
        self.location = location
        self.phone = phone
        self.summary = summary
        self.image = image
        self.isVisited = isVisited
        self.rating = ""
    }
    
    static func writeRestaurantFromBegin() {
        
        let sourceArray: [Restaurant] = [
            Restaurant(name: "清心福全花蓮中華店-珍珠奶茶手搖飲專賣店", type: "Coffee & Tea Shop", location: "970花蓮縣花蓮市中華路116號", phone: "+88638353959", summary: "清心福全創立於1987年，秉持踏實穩健、創發精進的經營理念，在手搖飲料店櫛比鱗次的台灣，一本用心泡好茶的初衷，傳遞喝好茶的幸福，始終堅持「手搖」傳統，並提供「客製化」的專業服務。\n清心福全嚴選優質茶葉、食材與包材，並逐批或定期送SGS檢驗，落實食品安全衛生自主管理，期許所奉上的每杯手搖飲料，都能帶給消費者「清」澄「心」靈、「福」澤「全」備的富足感。", image: "logo.png", isVisited: false),
            Restaurant(name: "炸蛋蔥油餅 黃車", type: "Food", location: "970花蓮縣花蓮市復興街102號", phone: "+886931121661", summary: "炸彈蔥油餅，可說是花蓮的超人氣美食小吃，連朋友聽到我要來花蓮玩，都特地說要我幫她多吃幾個，呵！\n在同條路上有「黃車」和「藍車」兩家炸彈蔥油餅，我們比較常吃黃車這家的，其實，各有擁護者。", image: "蔥油餅", isVisited: false)
        ]
        
        var restaurant: RestaurantMO!
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            for i in 0..<sourceArray.count {
                restaurant = RestaurantMO(context: appDelegate.persistentContainer.viewContext)
                restaurant.name = sourceArray[i].name
                restaurant.type = sourceArray[i].type
                restaurant.location = sourceArray[i].location
                restaurant.phone = sourceArray[i].phone
                restaurant.summary = sourceArray[i].summary
                restaurant.isVisited = false
                restaurant.rating = nil
                restaurant.image = UIImage(named: sourceArray[i].image)!.pngData()
            }
            appDelegate.saveContext() //write once for all new restauranrs
        }
    }
    
}

