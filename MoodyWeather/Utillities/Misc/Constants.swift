//
//  Constants.swift
//  MoodyWeather
//
//  Created by Nicholas Reeder on 4/17/20.
//  Copyright © 2020 Nicholas Reeder. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let buttonRadius = CGFloat(7.0)
    static let labelColor = UIColor(white: 1, alpha: 1)
    static let subLabelColor = UIColor(white: 1, alpha: 0.5)
    static let labelScaleFactor = CGFloat(0.5)
    
}

enum MoonPhases: String, CaseIterable {
    case WaningCrescent = "WaningCrescent"
    case WaxingCresecent = "WaxingCresent"
    case WaningGibbous = "WaningGibbous"
    case WaxingGibbous = "WaxingGibbous"
    case FullMoon = "FullMoon"
    func setImage() -> UIImage? {
        return UIImage(named: self.rawValue)
    }

}

enum Fonts: String {
    case Regular  = "Thonburi"
    case Bold = "Thonburi-Bold"
    case Light = "Thonburi-Light"
    
    func of(_ size: CGFloat) -> UIFont? {
        let font = UIFont(name: self.rawValue, size: size) ?? UIFont.systemFont(ofSize: size, weight: .medium)
        let metrics = UIFontMetrics(forTextStyle: .body)
        return metrics.scaledFont(for: font)
    }
}
