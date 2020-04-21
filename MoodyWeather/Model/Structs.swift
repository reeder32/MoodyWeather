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

struct WeatherTest: Codable {
    var weather: [WeatherArray]
    var wind: Wind
    var clouds: Clouds
    var main: Main
    var id: Int
    var name: String
    var sys: System
    let coord: Coord
    var dt: TimeInterval
    var visibility: Int
}


import UIKit
struct MoonPhaseText {
    var string: String
    var moonPhaseString: NSMutableAttributedString?
    
    init(string: String) {
        self.string = string
        self.moonPhase()
    }
    
    private mutating func moonPhase() {
        //print(self.string)
        let stringWithAttachment = NSMutableAttributedString(string: self.string)
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
