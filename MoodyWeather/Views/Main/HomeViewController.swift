//
//  HomeViewController.swift
//  MoodyWeather
//
//  Created by Nicholas Reeder on 3/24/20.
//  Copyright © 2020 Nicholas Reeder. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {
    // MARK: UI
    var showDescription: Bool = false
    var descriptionAttributedText: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: Fonts.Bold.of(20) ?? UIFont.boldSystemFont(ofSize: 20)]
    var hasSeenDescriptionPopup : Bool =  UserDefaults.standard.bool(forKey: UserDefaultsKeys.HasSeenDescriptionPopup.rawValue) {
        didSet {
            UserDefaults.standard.setValue(hasSeenDescriptionPopup, forKey: UserDefaultsKeys.HasSeenDescriptionPopup.rawValue)
            showPopup()
        }
    }
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.indicatorStyle = .white
        return sv
    }()
    
    
    lazy var nameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = Fonts.Bold.of(50)
        l.textAlignment = .left
        l.minimumScaleFactor = Constants.labelScaleFactor
        l.textColor = Constants.labelColor
        l.alpha = 0
        l.adjustsFontSizeToFitWidth = true
        l.numberOfLines = 0
        return l
    }()
    lazy var tempLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = Fonts.Bold.of(30)
        l.textAlignment = .left
        l.minimumScaleFactor = Constants.labelScaleFactor
        l.adjustsFontSizeToFitWidth = true
        l.textColor = Constants.labelColor
        l.alpha = 0
        return l
    }()
    
    lazy var temperatureHeader: HeaderLabel = {
        let l = HeaderLabel()
        l.setUpLabel(title: "Temperature:")
        return l
    }()
    
    lazy var cloudsHeader: HeaderLabel = {
        let l = HeaderLabel()
        l.setUpLabel(title: "Clouds:")
        return l
    }()
    
    lazy var sunHeader: HeaderLabel = {
        let l = HeaderLabel()
        l.setUpLabel(title: "Sun:")
        return l
    }()
    lazy var windHeader: HeaderLabel = {
        let l = HeaderLabel()
        l.setUpLabel(title: "Wind:")
        return l
    }()
    lazy var humidityHeader: HeaderLabel = {
        let l = HeaderLabel()
        l.setUpLabel(title: "Humidity:")
        return l
    }()
    
    lazy var moodHeader: HeaderLabel = {
        let l = HeaderLabel()
        l.setUpLabel(title: "Mood:")
        return l
    }()
    lazy var moonHeader: HeaderLabel = {
        let l = HeaderLabel()
        l.setUpLabel(title: "Moon:")
        return l
    }()
    
    lazy var moonLabel: WeatherLabel = {
        let l = WeatherLabel()
        l.text = "Loading..."
        return l
    }()
    
    lazy var descriptionLabel: WeatherLabel = {
        let l = WeatherLabel()
        return l
    }()
    lazy var tempMaxMinLabel: WeatherLabel = {
        let l = WeatherLabel()
        return l
    }()
    
    lazy var cloudLabel: WeatherLabel = {
        let l = WeatherLabel()
        return l
    }()
    
    lazy var windLabel: WeatherLabel = {
        let l = WeatherLabel()
        return l
    }()
    
    lazy var humidityLabel: WeatherLabel = {
        let l = WeatherLabel()
        return l
    }()
    
    lazy var sunriseSunsetLabel: WeatherLabel = {
        let l = WeatherLabel()
        return l
    }()
    
    lazy var moodLabel: WeatherLabel = {
        let l = WeatherLabel()
        l.isUserInteractionEnabled = true
        return l
    }()
    
    var moons: [Moon]? {
        didSet {
            showMoon()
        }
    }
    
    var weather: Weather? {
        didSet {
            showWeather()
        }
    }
    
    var colorCreator: ColorCreator?
    
    var defaults = UserDefaults.standard
    
    init(weather: Weather?, moons: [Moon]?) {
        self.moons = moons
        self.weather = weather
        super.init(nibName: nil, bundle: nil)
        self.colorCreator = ColorCreator(with: self.view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            self.showWeather()
            self.showMoon()
           
        }
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(changeLabelsBasedOnPrefs), name: NSNotification.Name("updatePrefs"), object: nil)
        view.backgroundColor = .relaxedColor
        setupViews()
        addConstraints()
      
    }
    
    func showPopup() {
       
        if !hasSeenDescriptionPopup {
            let popup = ColorPopupLabel(frame: CGRect(x: 24 , y: self.moodLabel.frame.minY, width: 300, height: 40))
            popup.label.text = "You can press me to see what the emojis mean \n👇"
            popup.tag = 100
            popup.label.isUserInteractionEnabled = true
            popup.isUserInteractionEnabled = true
            if self.isViewLoaded && (self.view.window != nil) {
                view.addSubview(popup)
            }
            addTap(popup)
        } else {
            let p = self.view.subviews.first(where: {$0.tag == 100})
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.2) {
                    p?.removeFromSuperview()
                }
            }
        }
       
    }
    
    func setupViews() {
        self.view.addSubview(scrollView)
        //print(self.view.frame.height - scrollView.contentSize.height)
        if self.view.frame.height - scrollView.contentSize.height <= 300 {
            scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: self.view.frame.height + 20)
        } else {
            scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: scrollView.frame.height)
        }
        self.scrollView.addSubview(nameLabel)
        self.scrollView.addSubview(tempLabel)
        self.scrollView.addSubview(temperatureHeader)
        self.scrollView.addSubview(cloudsHeader)
        self.scrollView.addSubview(sunHeader)
        self.scrollView.addSubview(windHeader)
        self.scrollView.addSubview(humidityHeader)
        self.scrollView.addSubview(cloudLabel)
        self.scrollView.addSubview(descriptionLabel)
        self.scrollView.addSubview(sunriseSunsetLabel)
        self.scrollView.addSubview(windLabel)
        
        self.scrollView.addSubview(humidityLabel)
        self.scrollView.addSubview(tempMaxMinLabel)
        self.scrollView.addSubview(moodHeader)
        self.scrollView.addSubview(moodLabel)
        self.scrollView.addSubview(moonHeader)
        self.scrollView.addSubview(moonLabel)
    }
    
    @objc func addConstraints() {
        let margins = getMargins()
        
        scrollView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -48).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0).isActive = true
        
        
        nameLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        
        tempLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        tempLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: 0).isActive = true
        
        moodHeader.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 16).isActive = true
        moodHeader.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
        
        moodLabel.topAnchor.constraint(equalTo: moodHeader.bottomAnchor, constant: 8).isActive = true
        moodLabel.leadingAnchor.constraint(equalTo: moodHeader.leadingAnchor, constant: 0).isActive = true
        
        temperatureHeader.topAnchor.constraint(equalTo: moodLabel.bottomAnchor, constant: 16).isActive = true
        temperatureHeader.leadingAnchor.constraint(equalTo: moodLabel.leadingAnchor, constant: 0).isActive = true
        
        
        tempMaxMinLabel.leadingAnchor.constraint(equalTo: temperatureHeader.leadingAnchor, constant: 0).isActive = true
        tempMaxMinLabel.topAnchor.constraint(equalTo: temperatureHeader.bottomAnchor, constant: 8).isActive = true
        
        cloudsHeader.topAnchor.constraint(equalTo: tempMaxMinLabel.bottomAnchor, constant: 16).isActive = true
        cloudsHeader.leadingAnchor.constraint(equalTo: tempMaxMinLabel.leadingAnchor, constant: 0).isActive = true
        
        cloudLabel.topAnchor.constraint(equalTo: cloudsHeader.bottomAnchor, constant: 8).isActive = true
        cloudLabel.leadingAnchor.constraint(equalTo: cloudsHeader.leadingAnchor, constant: 0).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: cloudLabel.bottomAnchor, constant: 4).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: cloudLabel.leadingAnchor, constant: 0).isActive = true
        
        sunHeader.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16).isActive = true
        sunHeader.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor, constant: 0).isActive = true
        
        sunriseSunsetLabel.topAnchor.constraint(equalTo: sunHeader.bottomAnchor, constant: 8).isActive = true
        sunriseSunsetLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor, constant: 0).isActive = true
        
        windHeader.topAnchor.constraint(equalTo: sunriseSunsetLabel.bottomAnchor, constant: 16).isActive = true
        windHeader.leadingAnchor.constraint(equalTo: sunriseSunsetLabel.leadingAnchor, constant: 0).isActive = true
        
        windLabel.topAnchor.constraint(equalTo: windHeader.bottomAnchor, constant: 8).isActive = true
        windLabel.leadingAnchor.constraint(equalTo: windHeader.leadingAnchor, constant: 0).isActive = true
        
        humidityHeader.topAnchor.constraint(equalTo: windLabel.bottomAnchor, constant: 16).isActive = true
        humidityHeader.leadingAnchor.constraint(equalTo: windLabel.leadingAnchor, constant: 0).isActive = true
        
        humidityLabel.topAnchor.constraint(equalTo: humidityHeader.bottomAnchor, constant: 8).isActive = true
        humidityLabel.leadingAnchor.constraint(equalTo: humidityHeader.leadingAnchor, constant: 0).isActive = true
        
        moonHeader.topAnchor.constraint(equalTo: humidityLabel.bottomAnchor, constant: 16).isActive = true
        moonHeader.leadingAnchor.constraint(equalTo: humidityLabel.leadingAnchor, constant: 0).isActive = true
        
        moonLabel.topAnchor.constraint(equalTo: moonHeader.bottomAnchor, constant: 8).isActive = true
        moonLabel.leadingAnchor.constraint(equalTo: moonHeader.leadingAnchor, constant: 0).isActive = true
        moonLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
        
        self.scrollView.setWidthConstraint(scrollView.widthAnchor, factor: 0.95)
        
    }
    
    
    private func revealInfoLabels() {
        
        for (i ,v) in scrollView.subviews.enumerated() {
            UIView.animate(withDuration: 1.0, animations: {
                v.alpha = 1
            }) { (done) in
                if i == self.scrollView.subviews.count - 1 {
                    self.showPopup()
                  
                }
            }
           
        }
       
    }
    
    
    
    private func showMoon() {
        if let moon = moons?.first {
            DispatchQueue.main.async {
                let phaseString = MoonPhaseText(string: moon.moonPhaseDesc ?? "").moonPhaseString
                phaseString?.append(NSAttributedString(string: "\nMoon Rise: \(moon.moonrise)\nMoon Set: \(moon.moonset)"))
                self.moonLabel.attributedText = phaseString
                
                //self.moonLabel.text = "Moon Phase: \(moon.Phase)\nMoon Type: \(moon.Moon.first ?? "")"
            }
        }
    }
    
    
    private func showWeather() {
        if let weather = weather {
            //print(self.weather as Any)
            DispatchQueue.main.async {
                
                self.colorCreator?.createMoodColor(weather: weather)
                self.nameLabel.text = weather.name
                self.changeLabelsBasedOnPrefs()
                self.cloudLabel.text = "Cloud cover: \(weather.clouds.all)%"
                self.descriptionLabel.text = weather.weather.first?.description.localizedCapitalized
                
                self.sunriseSunsetLabel.text = "Sunrise: \(self.convertTimestamp(weather.sys.sunrise, weather.sys.timezone, weather.sys.country))\nSunset: \(self.convertTimestamp(weather.sys.sunset, weather.sys.timezone, weather.sys.country))"
                self.windLabel.text = "Wind is blowing \(weather.wind.speed) m/s \(self.windDirection(weather.wind.deg ?? 0) ?? "")"
                self.humidityLabel.text = "Humidity: \(weather.main.humidity)%"
                self.revealInfoLabels()
                self.addMoodLabelText()
                self.tapMoodLabel()
              
            }
        }
    }
    
    func tapMoodLabel() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleLabel))
        tap.delegate = self
        moodLabel.addGestureRecognizer(tap)
    }
    
    @objc func toggleLabel(_ gesture: UITapGestureRecognizer) {
        showDescription.toggle()
        addMoodLabelText()
    }
    
    func addMoodLabelText() {
        if let tempColor = self.colorCreator?.moodyWeatherCreator?.tempColor, let cloudColor = self.colorCreator?.moodyWeatherCreator?.cloudColor {
            if showDescription {
                let attrText = NSMutableAttributedString()
                let tempMutText = NSMutableAttributedString(string: tempColor.descriptionName, attributes: descriptionAttributedText)
                let cloudMutText = NSMutableAttributedString(string: cloudColor.descriptionName, attributes: descriptionAttributedText)
                self.moodLabel.attributedText = NSAttributedString(string: "Weather is feeling \(tempMutText) and \(cloudMutText)")
                attrText.append(NSAttributedString(string: "Weather is feeling "))
                attrText.append(tempMutText)
                if tempMutText.string != cloudMutText.string {
                attrText.append(NSAttributedString(string: " and "))
                attrText.append(cloudMutText)
                }
                self.moodLabel.attributedText = attrText
                self.hasSeenDescriptionPopup = true
            } else {
                self.moodLabel.text = "Weather is feeling \(tempColor.name ?? "") and \(cloudColor.name ?? "")"
            }
            
        }
        
    }
    
    @objc func changeLabelsBasedOnPrefs() {
        
        if let pref = defaults.value(forKey: UserDefaultsKeys.ScalePref.rawValue) as? Int {
            switch pref {
            case 0:
                self.tempLabel.text = self.tempLabel.convertToCelcius(weather?.main.temp ?? 0)
                self.tempMaxMinLabel.text = "High: \(self.tempMaxMinLabel.convertToCelcius(weather?.main.temp_max ?? 0))\nLow: \(self.tempMaxMinLabel.convertToCelcius(weather?.main.temp_min ?? 0))"
            default:
                self.tempLabel.text = self.tempLabel.convertToFerenheit(weather?.main.temp ?? 0)
                self.tempMaxMinLabel.text = "High: \(self.tempMaxMinLabel.convertToFerenheit(weather?.main.temp_max ?? 0))\nLow: \(self.tempMaxMinLabel.convertToFerenheit(weather?.main.temp_min ?? 0))"
            }
        } else {
            defaults.set(0, forKey: UserDefaultsKeys.ScalePref.rawValue)
            changeLabelsBasedOnPrefs()
        }
    }
    
}



extension HomeViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    func addTap(_ tapView: UIView) {
        let tapped = UITapGestureRecognizer(target: self, action: #selector(dismissMe))
        tapped.numberOfTapsRequired = 1
        tapped.delegate = self
        tapView.addGestureRecognizer(tapped)
        
    }
    
    @objc func dismissMe() {
        hasSeenDescriptionPopup = true
        self.showPopup()
    }
}



