//
//  Structs.swift
//  MoodyWeather
//
//  Created by Nicholas Reeder on 4/17/20.
//  Copyright © 2020 Nicholas Reeder. All rights reserved.
//

import Foundation

struct SavedLocation: Codable {
    let id: Int
    let name: String
}

struct WeatherList: Codable {
    var list: [Weather]
    var cnt: Int
}

struct Coord: Codable {
    var lat: Double
    var lon: Double
}

struct Clouds: Codable {
    var all: Int
}
struct System: Codable {
    var country: String
    var id: Int?
    var sunrise: TimeInterval
    var sunset: TimeInterval
    var type: Int?
    var timezone: Int?
}
struct Main: Codable {
    var feels_like: Double
    var humidity: Int
    var pressure: Int
    var temp: Double
    var temp_max: Double
    var temp_min: Double
}
struct Wind: Codable {
    var gust: Double?
    var deg: Int?
    var speed: Double
}
struct WeatherArray: Codable {
    var description: String
    var icon: String
    var id: Int
    var main: String
}
//struct WeatherTest: Codable {
//    var weather: [WeatherArray]
//    var wind: Wind
//    var clouds: Clouds
//    var main: Main
//    var id: Int
//    var name: String
//    var sys: System
//    let coord: Coord
//    var dt: TimeInterval
//    var visibility: Int
//}


import UIKit
struct MoonPhaseText {
    var string: String
    var moonPhaseString: NSMutableAttributedString?
    
    init(string: String) {
        self.string = string
        self.moonPhase()
    }
    
    private mutating func moonPhase() {
        print(self.string)
        let stringWithAttachment = NSMutableAttributedString(string: self.string.localizedCapitalized)
        let phaseName = self.string.replacingOccurrences(of: " ", with: "")
        
        if let imageName = MoonPhases.self.allCases.first(where: {$0.rawValue == phaseName}) {
            let attachment = NSTextAttachment()
            attachment.image = UIImage(named: imageName.rawValue)
            attachment.bounds.origin = CGPoint(x: 0, y: -5)
            attachment.bounds.size = CGSize(width: 30, height: 30)
            let attachmentString = NSAttributedString(attachment: attachment)
            stringWithAttachment.insert(NSAttributedString(string: "Phase: "), at: 0)
            stringWithAttachment.append(NSAttributedString(string: " "))
            stringWithAttachment.append(attachmentString)
            self.moonPhaseString = stringWithAttachment
        } else {
            self.moonPhaseString = stringWithAttachment
        }
    }
}


