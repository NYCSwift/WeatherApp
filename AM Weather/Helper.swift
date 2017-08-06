//
//  Helper.swift
//  AM Weather
//
//  Created by Aferdita Muriqi on 1/2/16.
//  Copyright © 2016 Aferdita Muriqi. All rights reserved.
//

import UIKit

// returns result as dictornary from JSON url/String
func getJSONFromUrl(_ urlString:String, success: @escaping ((_ dictionary: [String: AnyObject]?)->())){
  
  if let url = URL(string: urlString) {
    let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
      
      if (error != nil) {
        do {
            let rawDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
            
            success(rawDictionary)
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
      }
    })
    task.resume()
  }
  else {
    success(nil)
  }
}

func getJSONFromFile(_ urlString:URL, success: ((_ dictionary: [String: AnyObject])->())){
  
    do {
      
      let data = try Data(contentsOf: urlString)
      let rawDictionary = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
      
      success(rawDictionary)
    } catch let error as NSError {
      print("Failed to load: \(error.localizedDescription)")
    }

}

// returns average double of an array of double
func average(_ numbers:[Double]) -> Double {
    return Double(numbers.reduce(0,+))/Double(numbers.count)
}


// converting of Kelvin or fahrenheit into Celsius
struct Celsius {
    var temperatureInCelsius: Double
    init(fromFahrenheit fahrenheit: Double) {
        temperatureInCelsius = (fahrenheit - 32.0) / 1.8
    }
    init(fromKelvin kelvin: Double) {
        temperatureInCelsius = kelvin - 273.15
    }
    init(_ celsius: Double) {
        temperatureInCelsius = celsius
    }
}

// converting of Kelvin or celsius into Fahrenheit
struct Fahrenheit {
    var temperatureInFahrenheit: Double
    init(fromKelvin kelvin: Double) {
        temperatureInFahrenheit = (kelvin - 273.15) * 1.8000 + 32.0
    }
    init(fromCelsius celsius: Double) {
        temperatureInFahrenheit = (celsius * 1.8) + 32
    }
    init(_ fahrenheit: Double) {
        temperatureInFahrenheit = fahrenheit
    }
    
}

// Location is used in City and Day object.
struct Location {
    var long:Double?
    var lat:Double?
}
