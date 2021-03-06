//
//  ExplanationViewController.swift
//  MoodyWeather
//
//  Created by Nicholas Reeder on 3/23/20.
//  Copyright © 2020 Nicholas Reeder. All rights reserved.
//

import UIKit

class ExplanationViewController: UIViewController {
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.indicatorStyle = .white
        return sv
    }()
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.text = "What's this all about?"
        l.font = Fonts.Bold.of(32)
        l.textColor = Constants.labelColor
        l.minimumScaleFactor = Constants.labelScaleFactor
        l.textAlignment = .left
        l.adjustsFontSizeToFitWidth = true
        l.numberOfLines = 0
        return l
    }()
    
    lazy var colorExplanationContainerView: ColorExplanationContainerView = {
        let v = ColorExplanationContainerView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    lazy var descriptionLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.font = Fonts.Light.of(16)
        l.textColor = Constants.labelColor
        l.minimumScaleFactor = Constants.labelScaleFactor
        l.lineBreakMode = .byWordWrapping
        l.textAlignment = .right
        l.text = "Were you a child of the 70’s and 80’s or wish you were? Did you wear a mood ring that changed color based on how you were feeling? Think of this as the mood ring for the weather. Temperature, humidity, cloud cover, and precipitation all factor in to create the mood of the weather. Type in a location and find out the mood of the weather."
        
        l.addLineSpacing(2.0)
        return l
    }()
    
    lazy var gotItButton: UIButton = {
        let b = UIButton()
        b.setTitle("Got it", for: .normal)
        b.titleLabel?.font = Fonts.Bold.of(16)
        b.setTitleColor(Constants.labelColor, for: .normal)
        b.layer.cornerRadius = Constants.buttonRadius
        b.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        return b
    }()
    
    var onDismiss: ((Bool) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .relaxedColor
        setupviews()
        setConstraints()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isBeingDismissed {
            onDismiss?(true)
        }
    }
    
    func setupviews() {
        self.view.addSubview(gotItButton)
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(titleLabel)
        self.scrollView.addSubview(descriptionLabel)
        self.scrollView.addSubview(colorExplanationContainerView)
        if self.view.frame.height - scrollView.contentSize.height <= 300 {
            scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: self.view.frame.height + self.descriptionLabel.frame.height + colorExplanationContainerView.frame.height)
        } else {
            scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: scrollView.frame.height)
        }
    }
    
    func setConstraints() {
        let margins = getMargins()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        gotItButton.translatesAutoresizingMaskIntoConstraints = false
        
        // scroll view
        scrollView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 8).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: gotItButton.topAnchor, constant: 0).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0).isActive = true
        
        // titleLabel
        //titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).isActive = true
        //titleLabel.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.8).isActive = true
        
        
        
        // descriptionLabel
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).isActive = true
        //descriptionLabel.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.35).isActive = true
        
        colorExplanationContainerView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24).isActive = true
        colorExplanationContainerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        colorExplanationContainerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 32).isActive = true
        
        
        //colorExplanationContainerView.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.55).isActive = true
        
        // gotItButton
        self.scrollView.setWidthConstraint(scrollView.widthAnchor, factor: 0.9)
        gotItButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -8).isActive = true
        gotItButton.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.05).isActive = true
        //gotItButton.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.55).isActive = true
        gotItButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor, constant: 0).isActive = true
        
    }
    
    @objc func goToOWM() {
        if let url = URL(string: "https://openweathermap.org/") {
            UIApplication.shared.open(url)
        }
        
    }
    
    @objc func dismissVC() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}






