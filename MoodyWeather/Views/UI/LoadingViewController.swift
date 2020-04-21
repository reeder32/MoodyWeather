//
//  LoadingViewController.swift
//  MoodyWeather
//
//  Created by Nicholas Reeder on 3/26/20.
//  Copyright © 2020 Nicholas Reeder. All rights reserved.
//


import UIKit
import CoreLocation

class LoadingViewController: UIViewController {
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = Fonts.Bold.of(40)
        l.text = "Why so moody?"
        l.textColor = Constants.labelColor
        l.minimumScaleFactor = Constants.labelScaleFactor
        l.textAlignment = .center
        l.sizeToFit()
        l.numberOfLines = 0
        return l
    }()
    var colorCreator: ColorCreator?
    var connector = OpenWeatherMapApiConnector.shared
    lazy var locationIDs: [Int] = {
        var ids = [Int]()
        let savedIds = DefaultsManager().savedLocations
        savedIds?.forEach({ (locations) in
            ids.append(locations.id)
        })
        return ids
    }()
    var weather: Weather?
    let decoder = JSONDecoder()
    let defaults = UserDefaults.standard
    var ids = [0]
    var location: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .averageColor
        self.colorCreator = ColorCreator(with: self.view)
        self.colorCreator?.startTimer()
        setupViews()
        setConstraints()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.check()
    }
    
    func setupViews() {
        view.addSubview(titleLabel)
    }
    
    func setConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        
    }
    
    
   private func check() {
   
        let locationManager = LocationManager.instance
        locationManager.start()
       
        locationManager.didGetLocation = { [weak self] loc, error in
            
            if self?.location == nil {
                self?.location = loc
               
                if error != nil { self?.presentPageControl(self?.locationIDs ?? []); locationManager.stop(); return }
                if let loc = loc {
                    
                    self?.getWeatherForCurrentLocation(location: loc)
                } else {
                    self?.presentPageControl(self?.locationIDs ?? [])
                }
                
            }
             locationManager.stop()
        }
        
    }
    
    func getWeatherForCurrentLocation(location: CLLocation) {
        //print(location)
  
        connector.getWeatherForCurrentLocation(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        connector.didGetWeather = { [weak self] (weather, error) in
            if error != nil {
                self?.presentPageControl(self?.locationIDs ?? [])
                return

            }
            guard let weather = weather, error == nil else {

                return

            }
            // need to init homevc with weather

            let currentLocationId = [weather.id]

            let combined = currentLocationId + (self?.locationIDs ?? [])

            self?.presentPageControl(combined)
        }
    }
    
    
    func presentPageControl(_ ids: [Int]) {
        
        DispatchQueue.main.async {
            let vc = WeatherPageViewController(ids)
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: {
                self.colorCreator?.stopTimer()
            })
        }
    }
    
    
}
