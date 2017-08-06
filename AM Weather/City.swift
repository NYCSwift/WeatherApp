//
//  City.swift
//  AM Weather
//
//  Created by Aferdita Muriqi on 1/1/16.
//  Copyright © 2016 Aferdita Muriqi. All rights reserved.
//

import Foundation

struct City{
    
    var name:String?
    var country:String?
    var coordinates:Location?

    init(country: String, name: String, lon: Double, lat: Double)
    {
        self.name = name
        self.country = country
        self.coordinates = Location(long: lon, lat: lat)
    }
    
}

func cityFromDictionay(_ dictionary: [String:AnyObject]) -> City? {
    if let rawUser = dictionary["city"] as? [String:AnyObject],
        let name = rawUser["name"] as? String,
        let country = rawUser["country"] as? String,
        let coord = rawUser["coord"] as? [String:Double],
        let lon = coord["lon"],
        let lat = coord["lat"]
    {
        
        return City(country: country, name: name, lon: lon, lat: lat)
    }
    return nil
}
