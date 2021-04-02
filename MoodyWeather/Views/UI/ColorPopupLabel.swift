//
//  ColorPopupLabel.swift
//  MoodyWeather
//
//  Created by Nicholas Reeder on 1/22/21.
//  Copyright © 2021 Nicholas Reeder. All rights reserved.
//

import UIKit

class ColorPopupLabel: UIView {
    
    let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        self.layer.cornerRadius = 4.0
        self.clipsToBounds = true
        addLabel()
       
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func addLabel() {
        label.font = Fonts.Bold.of(12)
        label.textColor = .black
        label.backgroundColor = Constants.labelColor
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        addSubview(label)
       
    }
    
    
    

}
