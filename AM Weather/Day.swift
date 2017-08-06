//
//  Day.swift
//  AM Weather
//
//  Created by Aferdita Muriqi on 1/1/16.
//  Copyright © 2016 Aferdita Muriqi. All rights reserved.
//

import Foundation

struct Day {
    
    var temp:Double
    var tempMin:Double
    var tempMax:Double
    var weatherDescription:String
    var date:Date

    var name:String?
    var coordinates:Location?
    
    init(temp: Double, tempMin: Double, tempMax: Double, weatherDescription: String, date: Date)
    {
        self.temp = temp
        self.tempMin = tempMin
        self.tempMax = tempMax
        self.weatherDescription = weatherDescription
        self.date = date
    }
}

extension Day: Groupable {
    
    func sameGroupAs(_ otherDay: Day) -> Bool {
        let f = self.date.shortStyle
        let s = otherDay.date.shortStyle
        
        return f == s
    }
    
}
extension Day: Comparable {
}

func < (lhs: Day, rhs: Day) -> Bool {
    return lhs.date.shortStyle < rhs.date.shortStyle
}

func > (lhs: Day, rhs: Day) -> Bool {
    return lhs.date.shortStyle > rhs.date.shortStyle
}

func == (lhs: Day, rhs: Day) -> Bool {
    return lhs.date.shortStyle == rhs.date.shortStyle
}


func weatherListFromDictionay(_ dictionary: [String:AnyObject]) -> [[Day]]? {
    if let list = dictionary["list"] as? [AnyObject]{
        
        var weatherList:[Day] = [Day]()
        for data in list
        {
            var entry:Day!
            if let main = data["main"] as? [String:AnyObject],
                let temp = main["temp"] as? Double,
                let tempMin = main["temp_min"] as? Double,
                let tempMax = main["temp_max"] as? Double,
                let weather = data["weather"] as? [AnyObject],
                let weatherDescription = weather[0]["description"] as? String,
                let date = data["dt"] as? TimeInterval
            {
                entry = Day(temp: temp, tempMin: tempMin, tempMax: tempMax, weatherDescription: weatherDescription, date: Date(timeIntervalSince1970:date))
            }
            
            
            if let  name = data["name"] as? String,
                let coord = data["coord"] as? [String:Double],
                let lon = coord["lon"],
                let lat = coord["lat"]
            {
                entry.name = name
                entry.coordinates = Location(long: lon, lat: lat)
            }
            weatherList.append(entry)
            
            
        }
        
        
        // returns a group of days, true = ascending, latest shows first, false = descending, current date should show first
        // for the test coding true should be as expected, if any of the live urls are being used , would recommend setting this to false, so the current day will show first.
        return weatherList.uniquelyGroupBy(false) { $0.sameGroupAs($1) }
    }
    return nil
}
