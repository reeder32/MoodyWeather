//
//  WeatherLabel.swift
//  MoodyWeather
//
//  Created by Nicholas Reeder on 4/14/20.
//  Copyright © 2020 Nicholas Reeder. All rights reserved.
//

import UIKit

class WeatherLabel: UILabel {

   override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        font = Fonts.Regular.of(17)
        textAlignment = .left
        minimumScaleFactor = Constants.labelScaleFactor
        adjustsFontSizeToFitWidth = true
        textColor = Constants.labelColor
        alpha = 0
        numberOfLines = 0
    }

}
