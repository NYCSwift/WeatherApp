//
//  DayViewController.swift
//  AM Weather
//
//  Created by Aferdita Muriqi on 1/1/16.
//  Copyright © 2016 Aferdita Muriqi. All rights reserved.
//

import UIKit

class WeatherDayViewController: UITableViewController {
    
    var pageIndex:Int!
    var days:[Day]!
    var city:City?
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var todayTemp: UILabel!
    @IBOutlet weak var todayHighTemp: UILabel!
    @IBOutlet weak var todayLowTemp: UILabel!
    
    let tsymbol = "\u{00B0}"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //unwrap data depends on availability
        if let name = self.city?.name,
            let country = self.city?.country,
            let long = self.city?.coordinates?.long,
            let lat = self.city?.coordinates?.lat
        {
            self.cityLabel.text = "\(name), \(country)"
            self.locationLabel.text = "(\(long) / \(lat))"
            self.dateLabel.text = "\(self.days[0].date.mediumStyle)"
        }
        else
        {
            if let name = self.days[0].name,
                let long = self.days[0].coordinates?.long,
                let lat = self.days[0].coordinates?.lat
            {
                self.cityLabel.text = "\(name)"
                self.locationLabel.text = "(\(long) / \(lat))"
                self.dateLabel.text = "\(self.days[0].date.mediumStyle)"
            }
            else
            {
                self.dateLabel.text = "\(self.days[0].date.mediumStyle)"
            }
        }
        
        
        // get highest temperatur of the day
        let highTemp = self.days.map{$0.tempMax}.max()
        
        //get lowest temperature of the day
        let lowTemp = self.days.map{$0.tempMin}.min()
        
        //calculate average tempaerature of the day
        let avgTemp = average(self.days.map{$0.temp})
        
        // display temperatures in fahrenheit ( Kelvin is the temperature format retrieved by the json urls)
        self.todayHighTemp.text = "H \(Int(Fahrenheit(fromKelvin: highTemp!).temperatureInFahrenheit))\(tsymbol)"
        self.todayLowTemp.text = "L \(Int(Fahrenheit(fromKelvin: lowTemp!).temperatureInFahrenheit))\(tsymbol)"
        self.todayTemp.text = "\(Int(Fahrenheit(fromKelvin: avgTemp).temperatureInFahrenheit))\(tsymbol)F"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.days.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // custom layout table cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HourTableViewCell
        
        let day = self.days[indexPath.row]
        
        cell.weatherDescription.text = day.weatherDescription
       
        // display time only from date property
        cell.timeLabel.text = day.date.time
        
        // display temperatures in fahrenheit ( Kelvin is the temperature format retrieved by the json urls)
        cell.tempLabel.text = "\(Int(Fahrenheit(fromKelvin: day.temp).temperatureInFahrenheit))\(tsymbol)F"
        cell.highLabel.text = "H \(Int(Fahrenheit(fromKelvin: day.tempMax).temperatureInFahrenheit))\(tsymbol)"
        cell.lowLabel.text = "L \(Int(Fahrenheit(fromKelvin: day.tempMin).temperatureInFahrenheit))\(tsymbol)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "forecast"
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
