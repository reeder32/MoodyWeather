//
//  Extensions.swift
//  MoodyWeather
//
//  Created by Nicholas Reeder on 4/1/20.
//  Copyright © 2020 Nicholas Reeder. All rights reserved.
//

import Foundation
import UIKit

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
extension UIColor {
    // 0 0 0
    class var tenseColor: UIColor { return UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1)}
    // 129 129 129
    class var anxiousColor: UIColor { return UIColor(red: 129 / 255, green: 129 / 255, blue: 129 / 255, alpha: 1)}
    //228 178 27
    class var nervousColor: UIColor { return UIColor(red: 228 / 255, green: 178 / 255, blue: 27 / 255, alpha: 1)}
    // 132 185 58
    class var averageColor: UIColor { return UIColor(red: 132 / 255, green: 185 / 255, blue: 58 / 255, alpha: 1)}
    // 0 160 142
    class var chargedColor: UIColor { return UIColor(red: 0 / 255, green: 160 / 255, blue: 142 / 255, alpha: 1)}
    // 0 110 176
    class var relaxedColor: UIColor { return UIColor(red: 0 / 255, green: 110 / 255, blue: 176 / 255, alpha: 1)}
    // 41 48 135
    class var happyColor: UIColor { return UIColor(red: 41 / 255, green: 48 / 255, blue: 135 / 255, alpha: 1)}
    
    var name: String? {
        switch self {
        case .anxiousColor: return "😦"
        case .nervousColor: return "🥺"
        case .averageColor: return "😐"
        case .tenseColor: return "😬"
        case .chargedColor: return "😜"
        case .relaxedColor: return "😌"
        case .happyColor: return "😄"
        default: return nil
        }
    }
    
}


extension UILabel {
    
    
    
    func createMoodLabel(text: String, location1: Int, color1: UIColor, color2: UIColor?) -> NSMutableAttributedString? {
        
        guard let color1Name = color1.name else {
            return nil
        }
        
        let mutString = NSMutableAttributedString(string: text)
        let color1Attributes = [NSAttributedString.Key.foregroundColor: color1,
                                NSAttributedString.Key.strokeWidth: -2,
                                NSAttributedString.Key.strokeColor: Constants.labelColor] as [NSAttributedString.Key : Any]
        if let color2 = color2, let color2Name = color2.name {
            let color2Attributes = [NSAttributedString.Key.foregroundColor: color2,
                                    NSAttributedString.Key.strokeWidth: -2,
                                    NSAttributedString.Key.strokeColor: Constants.labelColor] as [NSAttributedString.Key : Any]
            mutString.addAttributes(color2Attributes, range: NSRange(location: text.count - color2Name.count , length: color2Name.count))
        }
        mutString.addAttributes(color1Attributes, range: NSRange(location: location1, length: color1Name.count))
        return mutString
    }
    
    func addLineSpacing(_ spacing: CGFloat) {
        guard let text = self.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing =  spacing// Whatever line spacing you want in points
        
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
    
    func convertToCelcius(_ kelvin: Double) -> String {
        let celcius = kelvin - 273.15
        return String(format: "%.0f℃", celcius)
    }
    func convertToFerenheit(_ kelvin: Double) -> String {
        let f = (kelvin - 273.15) * 1.8 + 32
        return String(format: "%.0f℉", f)
    }
    
}

extension UIView {
    func setWidthConstraint(_ dimension: NSLayoutDimension, factor: CGFloat) {
        self.subviews.forEach { (v) in
            if v is UIToolbar || v is UIButton { return }
            v.widthAnchor.constraint(equalTo: dimension, multiplier: factor).isActive = true
        }
    }
}

extension UIViewController {
    
    func getMargins() -> UILayoutGuide {
        return self.view.layoutMarginsGuide
    }
    
    func openSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    func goToSettingsAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Need location permission", message: "If we can't get your location, we will use the last place you searched.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Settings", style: .default) { (select) in
                //action()
                self.openSettings()
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    func alert(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            let ok = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func convertTimestamp(_ timestamp: TimeInterval, _ timestampDiff: Int?, _ country: String?) -> String {
        
        let df: DateFormatter = {
            let dateForm = DateFormatter()
            dateForm.dateFormat = ("hh:mma")
            dateForm.amSymbol = "AM"
            dateForm.pmSymbol = "PM"
            if let diff = timestampDiff {
                // This is the fucking key. Needed this to be added in order to account for daylight savings
                dateForm.timeZone = TimeZone(abbreviation: "GMT")
                dateForm.timeZone = TimeZone(secondsFromGMT: diff)
            } else {
                dateForm.timeZone = TimeZone(identifier: country ?? "")
            }
            return dateForm
        }()
        
        let date = Date(timeIntervalSince1970: timestamp)
        return df.string(from: date)
    }
    
    
    
    func windDirection(_ wind: Int) -> String? {
        switch wind {
        case ..<90:
            return "from the West"
        case ..<180:
            return "from the South"
        case ..<270:
            return "from the East"
        default:
            return "from the North"
        }
    }
    
}
