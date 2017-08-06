//
//  WeatherRootViewController.swift
//  AM Weather
//
//  Created by Aferdita Muriqi on 1/1/16.
//  Copyright © 2016 Aferdita Muriqi. All rights reserved.
//

import UIKit

class WeatherRootViewController: UIViewController,UIPageViewControllerDataSource {
  
  
  var pageViewController:UIPageViewController!
  var days = [[Day]]()
  var city:City?
  
  @IBOutlet weak var noAccessLabel: UILabel!
  var local = true
  
  @IBAction func toggle(_ sender: AnyObject) {
    
    local = !local
    
    loadWeather()
  }
  
  func loadWeather() {
    if local {
      let dataUrl = Bundle.main.url(forResource: "data", withExtension: "json")
      
      getJSONFromFile(dataUrl!) { (dictionary) -> () in
        
        // sleep just to simulate if the response would take longer as in this test code
        sleep(1)
        
        //parse location information from json dictionary
        self.city = cityFromDictionay(dictionary)
        
        //parse weather list from dictionary , list contains per day a list of temperatures per hour
        self.days = weatherListFromDictionay(dictionary)!
        DispatchQueue.main.async(execute: { () -> Void in
          
          if let controller = self.viewControllerAtIndex(0)
          {
            self.pageViewController.view.removeFromSuperview()
            self.noAccessLabel.isHidden = true
            self.view.addSubview(self.pageViewController.view)

            let startingViewController:WeatherDayViewController = controller as WeatherDayViewController
            
            self.pageViewController.setViewControllers([startingViewController], direction: .reverse, animated: false, completion: nil)
            
            // enable reload button as the data has been retreived and proccessed already
            self.reloadButton.isEnabled = true
            
            // hide activity indicator
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
          }
          
        })
        
      }
      
    }
    else {
      let urlstring = "http://api.openweathermap.org/data/2.5/forecast?q=paris&mode=json&appid=#############APIKEY################"
      //        let urlstring = "http://api.openweathermap.org/data/2.5/find?q=London&appid=#############APIKEY################"
      
      
      // retrieve Json dictionary from url (any of the url above should work)
      getJSONFromUrl(urlstring) { (dictionary) -> () in
        
        if let dictionary = dictionary {
          // sleep just to simulate if the response would take longer as in this test code
          sleep(1)
          
          //parse location information from json dictionary
          self.city = cityFromDictionay(dictionary)
          
          //parse weather list from dictionary , list contains per day a list of temperatures per hour
          self.days = weatherListFromDictionay(dictionary)!
          DispatchQueue.main.async(execute: { () -> Void in
            
            if let controller = self.viewControllerAtIndex(0)
            {
              self.pageViewController.view.removeFromSuperview()
              self.noAccessLabel.isHidden = true
              self.view.addSubview(self.pageViewController.view)

              let startingViewController:WeatherDayViewController = controller as WeatherDayViewController
              
              self.pageViewController.setViewControllers([startingViewController], direction: .reverse, animated: false, completion: nil)
              
              // enable reload button as the data has been retreived and proccessed already
              self.reloadButton.isEnabled = true
              
              // hide activity indicator
              UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
          })
        }
        else {
          
          self.city = nil
          self.days = [[Day]]()
          
          DispatchQueue.main.async(execute: { () -> Void in
            
            self.pageViewController.view.removeFromSuperview()
            self.noAccessLabel.isHidden = false

            // enable reload button as the data has been retreived and proccessed already
            self.reloadButton.isEnabled = true
            
            // hide activity indicator
            UIApplication.shared.isNetworkActivityIndicatorVisible = false

          })
          
        }
        
      }
      
    }

  }
  
  @IBOutlet weak var reloadButton: UIBarButtonItem!
  
  @IBAction func reload(_ sender: AnyObject) {
    
    //disable reload button and start activityindicator
    reloadButton.isEnabled = false
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    
    loadWeather()
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Create page view controller
    self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController
    self.pageViewController.dataSource = self;
    
    // initially load weather information
    loadWeather()
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.height)! + 20, width: self.view.frame.size.width, height: self.view.frame.size.height - (self.navigationController?.navigationBar.frame.height)! - 40);
    
    self.addChildViewController(pageViewController)
    self.view.addSubview(pageViewController.view)
    self.pageViewController.didMove(toParentViewController: self)
    
  }
  
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    
    var index = (viewController as! WeatherDayViewController).pageIndex
    
    if ((index == 0) || (index == NSNotFound))
    {
      return nil
    }
    
    index! -= 1
    return self.viewControllerAtIndex(index!)
    
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    
    var index = (viewController as! WeatherDayViewController).pageIndex
    
    if (index == NSNotFound)
    {
      return nil
    }
    
    index! += 1
    if (index == self.days.count)
    {
      return nil
    }
    return self.viewControllerAtIndex(index!)
  }
  
  func viewControllerAtIndex(_ index:Int) -> WeatherDayViewController?
  {
    if (self.days.count == 0 || index >= self.days.count)
    {
      return nil
    }
    
    let dayViewController:WeatherDayViewController = self.storyboard?.instantiateViewController(withIdentifier: "DayViewController") as! WeatherDayViewController
    dayViewController.pageIndex = index
    dayViewController.days = self.days[index].sorted(by: { $0.date.sortTime < $1.date.sortTime })
    dayViewController.city = self.city
    
    return dayViewController
    
  }
  
  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    
    return self.days.count
  }
  
  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    
    return 0
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
