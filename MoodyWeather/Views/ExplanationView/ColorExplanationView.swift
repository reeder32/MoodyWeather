//
//  ColorExplanationView.swift
//  MoodyWeather
//
//  Created by Nicholas Reeder on 3/27/20.
//  Copyright © 2020 Nicholas Reeder. All rights reserved.
//

import UIKit

class ColorExplanationView: UIView {

    lazy var colorSquare: UIView = {
        let v = UIView()
        v.frame.size.height = 20
        v.frame.size.width = 20
        v.clipsToBounds = true
        v.layer.borderColor = UIColor(ciColor: .white).cgColor
        v.layer.borderWidth = 1.0
        v.layer.cornerRadius = 10.0
        return v
    }()
    lazy var colorLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = Fonts.Light.of(15)
        l.minimumScaleFactor = Constants.labelScaleFactor
        l.textColor = Constants.labelColor
        l.numberOfLines = 0
        //l.sizeToFit()
        //l.lineBreakMode = .byCharWrapping
        l.adjustsFontSizeToFitWidth = true
        l.textAlignment = .left
        return l
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(color: UIColor, text: String) {
        super.init(frame: .zero)
        self.colorSquare.backgroundColor = color
        self.colorLabel.text = text
        setupView()
        
    }
    
    func setupView() {
        addSubview(colorLabel)
        addSubview(colorSquare)
        setupConstraints()
    }
    
//    override var intrinsicContentSize: CGSize {
//        return CGSize(width: 400, height: 20)
//    }
    
    func setupConstraints() {
        //print(self.colorSquare, self.colorSquare.backgroundColor)
        colorSquare.translatesAutoresizingMaskIntoConstraints = false
        colorSquare.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        colorSquare.centerYAnchor.constraint(equalTo: colorLabel.centerYAnchor, constant: 0).isActive = true
        colorSquare.widthAnchor.constraint(equalToConstant: 20).isActive = true
        colorSquare.heightAnchor.constraint(equalToConstant: 20).isActive = true
        colorLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        colorLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        colorLabel.leadingAnchor.constraint(equalTo: colorSquare.trailingAnchor, constant: 8).isActive = true
        colorLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        //self.updateConstraints()
       
    }
    

}
