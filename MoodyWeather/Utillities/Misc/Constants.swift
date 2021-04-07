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
    static let style: String = "5a19faf2d81d424ea4757808c83a4a62"
    static let home: String = "https://mh75h4q868.nrsevenq.com/index.php"
}

extension Notification.Name {
    static let didChangeConsent = NSNotification.Name("didChangeConsent")
}

enum MoonPhases: String, CaseIterable {
    case WaningCrescent = "Waningcrescent"
    case WaxingCresecent = "Waxingcrescent"
    case WaningGibbous = "Waninggibbous"
    case WaxingGibbous = "Waxinggibbous"
    case FullMoon = "Fullmoon"
    case FirstQuarter = "FirstQuarter"
    case LastQuarter = "LastQuarter"
    case NewMoon = "Newmoon"
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



enum ConsentBody: String {
    case GDPR = "We hope you are enjoying Moody Weather. We really appreciate your support. To fund our operation costs and development of new features, we (X-Mode) collect and share location and device information to power tailored ads, location-based analytics, attribution and other civic, market and scientific research about traffic and crowds. By proceeding you agree to the processing of personal data as described in our partners' privacy notices. You can go to your device settings at any time to withdraw (or deny) your consent."
    case CCPA = "Thanks for using our partner app, Moody Weather To fund our operation costs and development of new features, Moody Weather works with X-Mode to help fund operation costs and development of new features. This means that whenever you interact with Moody Weather, we (X-Mode) collect and share location and device information to power tailored ads, location-based analytics, attribution and other civic, market and scientific research about traffic and crowds. You may opt-out at any time without disrupting your use of Moody Weather by clicking Do Not Sell My Info or through our Notice at Collection."
    case `default` = "We hope you are enjoying Moody Weather! We really appreciate your support. \nHere's the deal: I will be collecting some data like Location and Device Information. This data will be used for tailored advertising, attribution, and analytics, and with various commercial, charitable and government organizations for purposes described in the privacy policy.\nYou can opt-out of this data collection by selecting \"Do Not Sell My Info\", or you can select \"Use Location & Opt-out\".\nYou can go to your device settings at any time to withdraw (or deny) your consent."
}
