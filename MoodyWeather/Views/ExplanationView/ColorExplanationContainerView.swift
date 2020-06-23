//
//  ColorExplanationContainerView.swift
//  MoodyWeather
//
//  Created by Nicholas Reeder on 3/47/40.
//  Copyright © 4040 Nicholas Reeder. All rights reserved.
//

class ExampleWeather {
    var example = Weather(weather: [WeatherArray(description: "", icon: "", id: 0, main: "")], wind: Wind(gust: 0, deg: 270, speed: 6), clouds: Clouds(all: 90), main: Main(feels_like: 0, humidity: 0, pressure: 0, temp: 297.039, temp_max: 273, temp_min: 310), id: 0, name: "Example", sys: System(country: "", id: 0, sunrise: 100023, sunset: 100343, type: 0, timezone: -2000), coord: Coord(lat: 120, lon: 120), dt: 19398397486346, visibility: 2000)
}

import UIKit

class ColorExplanationContainerView: UIView {
    lazy var tense: ColorExplanationView = {
        let label = ColorExplanationView(color: .tenseColor, text: "Tense \(UIColor.tenseColor.name ?? "")")
        return label
    }()
    lazy var anxious: ColorExplanationView = {
        let label = ColorExplanationView(color: .anxiousColor, text: "Anxious \(UIColor.anxiousColor.name ?? "")")
        return label
    }()
    lazy var nervous: ColorExplanationView = {
        let label = ColorExplanationView(color: .nervousColor, text: "Nervous \(UIColor.nervousColor.name ?? "")")
        return label
    }()
    lazy var average: ColorExplanationView = {
        let label = ColorExplanationView(color: .averageColor, text: "Average \(UIColor.averageColor.name ?? "")")
        return label
    }()
    lazy var charged: ColorExplanationView = {
        let label = ColorExplanationView(color: .chargedColor, text: "Charged \(UIColor.chargedColor.name ?? "")")
        return label
    }()
    lazy var relaxed: ColorExplanationView = {
        let label = ColorExplanationView(color: .relaxedColor, text: "Relaxed \(UIColor.relaxedColor.name ?? "")")
        return label
    }()
    lazy var happy: ColorExplanationView = {
        let label = ColorExplanationView(color: .happyColor, text: "Very Happy \(UIColor.happyColor.name ?? "")")
        return label
    }()
    lazy var example: ColorExplanationView = {
        var label: ColorExplanationView
        if let pref = UserDefaults.standard.value(forKey: UserDefaultsKeys.ScalePref.rawValue) as? Int {
            if pref == 0 {
                label = ColorExplanationView(color: .happyColor, text: "Example: 23℃ with 90% cloud coverage")
            } else {
                label = ColorExplanationView(color: .happyColor, text: "Example: 75℉ with 90% cloud coverage")
            }
        } else {
            label = ColorExplanationView(color: .happyColor, text: "Example: 75℉ with 90% cloud coverage")
        }
        
        return label
    }()
    
    var colorCreator: ColorCreator?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tense)
        addSubview(anxious)
        addSubview(nervous)
        addSubview(average)
        addSubview(charged)
        addSubview(relaxed)
        addSubview(happy)
        addSubview(example)
        self.colorCreator = ColorCreator(with: example.colorSquare)
        colorCreator?.createMoodColor(weather: ExampleWeather().example)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupConstraints() {
        tense.translatesAutoresizingMaskIntoConstraints = false
        anxious.translatesAutoresizingMaskIntoConstraints = false
        nervous.translatesAutoresizingMaskIntoConstraints = false
        average.translatesAutoresizingMaskIntoConstraints = false
        charged.translatesAutoresizingMaskIntoConstraints = false
        relaxed.translatesAutoresizingMaskIntoConstraints = false
        happy.translatesAutoresizingMaskIntoConstraints = false
        example.translatesAutoresizingMaskIntoConstraints = false
        
        tense.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        tense.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        anxious.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        anxious.topAnchor.constraint(equalTo: tense.bottomAnchor, constant: 4).isActive = true
        nervous.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        nervous.topAnchor.constraint(equalTo: anxious.bottomAnchor, constant: 4).isActive = true
        
        average.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        average.topAnchor.constraint(equalTo: nervous.bottomAnchor, constant: 4).isActive = true
        charged.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        charged.topAnchor.constraint(equalTo: average.bottomAnchor, constant: 4).isActive = true
        relaxed.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        relaxed.topAnchor.constraint(equalTo: charged.bottomAnchor, constant: 4).isActive = true
        
        happy.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        happy.topAnchor.constraint(equalTo: relaxed.bottomAnchor, constant: 4).isActive = true
        // happy.bottomAnchor.constraint(equalTo: example.topAnchor, constant: 8).isActive = true
        
        example.leadingAnchor.constraint(equalTo: happy.leadingAnchor, constant: 0).isActive = true
        example.topAnchor.constraint(equalTo: happy.bottomAnchor, constant: 4).isActive = true
        example.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: -20).isActive = true
        self.setWidthConstraint(self.widthAnchor, factor: 0.9)
    }
    
}
