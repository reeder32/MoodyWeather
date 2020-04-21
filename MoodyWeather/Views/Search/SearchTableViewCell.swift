//
//  SearchTableViewCell.swift
//  MoodyWeather
//
//  Created by Nicholas Reeder on 3/30/20.
//  Copyright © 2020 Nicholas Reeder. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class SearchTableViewCell: UITableViewCell {
    
    let geoCoder = CLGeocoder()
    var didTapAddButton: ((Bool) -> Void)?
    lazy var nameLabel: UILabel = {
        let l = UILabel()
        l.textColor = Constants.labelColor
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 0
        return l
    }()
    lazy var nearLabel: UILabel = {
        let l = UILabel()
        l.textColor = Constants.subLabelColor
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 1
        l.lineBreakMode = .byTruncatingTail
        return l
    }()
    
    lazy var addButton: UIButton = {
        let b = UIButton(type: .contactAdd)
        b.tintColor = Constants.labelColor
        b.addTarget(self, action: #selector(didTapAccessoryButton), for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureWithPlace(_ place: MKMapItem?) {
        accessoryView = addButton
        setUpViews()
        setupConstraints()
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.selectionStyle = .none
        nameLabel.font = Fonts.Bold.of(15)
        //nameLabel.adjustsFontForContentSizeCategory = true
        nearLabel.font = Fonts.Regular.of(12)
        //nearLabel.adjustsFontForContentSizeCategory = true
        
       
        if let mapItem = place {
            //print(mapItem.placemark.description)
            
            nameLabel.text = "\(mapItem.placemark.locality ?? ""), \(mapItem.placemark.administrativeArea ?? "")"
            nearLabel.text = "Near: \(mapItem.placemark.name ?? "")"
        }
    }
    
    func setUpViews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(nearLabel)
        contentView.addSubview(addButton)
    }
    
    func setupConstraints() {
        addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 4).isActive = true
        addButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        
        nearLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2).isActive = true
        nearLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4).isActive = true
        nearLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        nearLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4).isActive = true
        
    }
    
    
    @objc func didTapAccessoryButton() {
        self.didTapAddButton?(true)
    }
    
}
