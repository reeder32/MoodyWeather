//
//  HeaderLabel.swift
//  MoodyWeather
//
//  Created by Nicholas Reeder on 3/29/20.
//  Copyright © 2020 Nicholas Reeder. All rights reserved.
//

import UIKit

class HeaderLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpLabel(title: String) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = title
        self.font = Fonts.Bold.of(20)
        self.minimumScaleFactor = Constants.labelScaleFactor
        self.textAlignment = .left
        self.textColor = Constants.labelColor
        self.alpha = 0
        self.adjustsFontSizeToFitWidth = true
    }
    
}
