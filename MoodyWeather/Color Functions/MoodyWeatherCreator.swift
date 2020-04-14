//
//  MoodyWeatherCreator.swift
//  MoodyWeather
//
//  Created by Nicholas Reeder on 3/25/20.
//  Copyright © 2020 Nicholas Reeder. All rights reserved.
//

import Foundation
import UIKit

struct MoodyWeatherCreator {
    var weather: Weather
    var moodyColor: UIColor?
    var cloudColor: UIColor?
    var tempColor: UIColor?
    
    init(weather: Weather) {
        self.weather = weather
        getCloudCoverColor()
        getTempColor()
    }
    
    func bgColor() -> UIColor? {
      
        if let cloudComponents = cloudColor?.cgColor.components, let tempComponents = tempColor?.cgColor.components {

            let red = (CGFloat( (cloudComponents[0])) + CGFloat((tempComponents[0]))) / 2
            let green = (CGFloat( (cloudComponents[1])) + CGFloat((tempComponents[1]))) / 2
            let blue = (CGFloat( (cloudComponents[2])) + CGFloat((tempComponents[2]))) / 2
            print(tempColor as Any, cloudColor as Any)
            print(red, green, blue)
            return UIColor(red: red, green: green, blue: blue, alpha: 1)
        } else {
            return nil
        }
       
    }
    
    mutating func getTempColor() {
       
        switch weather.main.temp {
        case ..<277:
            tempColor = .tenseColor
        case ..<283:
            tempColor = .anxiousColor
        case ..<291:
            tempColor = .relaxedColor
        case ..<298:
            tempColor = .chargedColor
        case ..<303:
            tempColor = .happyColor
        case ..<310:
            tempColor = .averageColor
        default:
            tempColor = .nervousColor
        }
        
    }
    mutating func getCloudCoverColor() {
        switch weather.clouds.all {
        case ..<20:
            cloudColor = .happyColor
            print("cloud cover is: \(weather.clouds.all)")
        case ..<40:
            cloudColor = .relaxedColor
            print("cloud cover is: \(weather.clouds.all)")
        case ..<50:
            cloudColor = .chargedColor
            print("cloud cover is: \(weather.clouds.all)")
        case ..<60:
            cloudColor = .averageColor
            print("cloud cover is: \(weather.clouds.all)")
        case ..<70:
            cloudColor = .nervousColor
            print("cloud cover is: \(weather.clouds.all)")
        case ..<80:
            cloudColor = .anxiousColor
            print("cloud cover is: \(weather.clouds.all)")
        default:
            cloudColor = .tenseColor
            print("cloud cover is default: \(weather.clouds.all)")
        }
    }
}


