//
//  WeatherPageViewController.swift
//  MoodyWeather
//
//  Created by Nicholas Reeder on 4/9/20.
//  Copyright © 2020 Nicholas Reeder. All rights reserved.
//

import UIKit

class WeatherPageViewController: UIPageViewController {
    lazy var toolBar: UIToolbar = {
        let tb = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        tb.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        tb.setShadowImage(UIImage(), forToolbarPosition: .any)
        tb.backgroundColor = .clear
        tb.tintColor = .white
        tb.sizeToFit()
        return tb
    }()
    
    lazy var settingsButon: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(goToSettings))
    }()
    
    lazy var searchButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(goToSearch))
    }()
    
    lazy var infoButton: UIBarButtonItem = {
        let info = UIButton(type: .infoLight)
        info.addTarget(self, action: #selector(goToExplainVC), for: .touchUpInside)
        return UIBarButtonItem(customView: info)
    }()
    
    lazy var spacer: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
    }()
    
    var margins = UILayoutGuide()
    var pages = [HomeViewController]()
    let defaults = UserDefaults.standard
    let connector = OpenWeatherMapApiConnector()
    var initialPage = 0
    let pageControl = UIPageControl()
    var ids: [Int]?
    var vcIndex = 0
    var savedLocations = DefaultsManager().savedLocations
    init(_ ids: [Int]?) {
        self.ids = ids
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [:])
        dataSource = self
        delegate = self
        self.getWeatherForIds()
    }
    
    func setupView() {
        self.view.addSubview(toolBar)
        self.toolBar.setItems([settingsButon, spacer, searchButton, spacer, infoButton], animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getWeatherForIds() {
        
        if let ids = self.ids {
            if ids.count <= 0 {
                // this will be no ids
                let exampleWeather = ExampleWeather().example
                self.getMoon(exampleWeather.coord.lat, exampleWeather.coord.lon, exampleWeather)
                
            }
            
            self.connector.getWeatherForIds(ids.map{ String($0)}) { [weak self] (weather, error) in
                guard let weatherList = weather, error == nil else {
                    return
                }
                for (index,  var weather) in weatherList.list.enumerated() {
                    weather.index = index
                    self?.getMoon(weather.coord.lat, weather.coord.lon, weather)
                    
                }
            }
        } else {
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func addPageWithWeather(_ id: Int) {
        connector.getWeatherWithLocationID(locationID: id) { (weather, error) in
            guard let weather = weather, error == nil else {
                return
            }
            if let _ = self.pages.first(where: {$0.weather?.name.lowercased() == "example"}) {
                self.pages.removeAll()
                self.ids?.removeAll()
            }
            self.ids?.append(weather.id)
            self.initialPage = self.pages.count
            self.getMoon(weather.coord.lat, weather.coord.lon, weather)
        }
    }
    func getMoon(_ lat: Double, _ lon: Double, _ weather: Weather?) {
        connector.getMoonData(lat, lon) { (moons, error) in
            if ((moons?.first) != nil), let moon = moons?.first {
                self.createPages(weather, moon)
            } else {
                if weather != nil {
                    self.createPages(weather, nil)
                } else {
                    self.createPages(nil, nil)
                }
            }
        }
    }
    
    func createPages(_ weather: Weather?, _ moon: Moon?) {
        
        DispatchQueue.main.async {
            
            let homeVC = HomeViewController(weather: weather, moon: moon)
            //print(self.pages.capacity)
            self.pages.append(homeVC)
            //print(self.pages.count, self.ids?.count)
            if self.pages.count == self.ids?.count || weather?.name.lowercased() == "example" {
                self.arrangePages()
            }
        }
        
    }
    
    func arrangePages() {
        var arranged = self.pages
        
        self.pages.forEach { (vc) in
            if let index = vc.weather?.index {
                arranged[index] = vc
            }
        }
        self.pages = arranged
        
        // if let firstPage = self.pages.first(where: {$0.weather?.isCurrentLocation == true}) { self.pages[0] = firstPage}
        setPages()
    }
    
    func setPages() {
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        setupView()
        addPageControl()
        addConstraints()
        if let ids = self.ids {
            if ids.count <= 0 {goToExplainVC()}
        }
    }
    
    func addPageControl() {
        //print(self.pages.count)
        pageControl.frame = CGRect()
        pageControl.isUserInteractionEnabled = false
        pageControl.currentPageIndicatorTintColor = .chargedColor
        pageControl.pageIndicatorTintColor = .white
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPage
        view.addSubview(pageControl)
    }
    
    func addConstraints() {
        margins = view.layoutMarginsGuide
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.bottomAnchor.constraint(equalTo: toolBar.topAnchor, constant: 0).isActive = true
        pageControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        toolBar.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0).isActive = true
        
    }
    
    // MARK: UIBARBUTTONITEM FUNCTIONS
    @objc func goToExplainVC() {
        
        let vc = ExplanationViewController()
        //vc.modalPresentationStyle = .fullScreen
        vc.onDismiss = { [weak self] result in
            if self?.savedLocations != nil {
                
            } else {
                self?.goToSearch()
            }
        }
        present(vc, animated: true, completion: nil)
    }
    @objc func goToSearch() {
        let searchVC = SearchViewController()
        searchVC.didAdd = { [weak self] (weather, error) in
            if error == nil, let weather = weather {
                if let savedIds = DefaultsManager().savedLocations?.compactMap({ $0.id }) {
                    
                    if !savedIds.contains(weather.id) {
                        self?.update(weather)
                        self?.addPageWithWeather(weather.id)
                        
                    } else {
                        self?.alert(message: "Looks like you already have that place saved")
                    }
                }
            } else {
                self?.alert(message: error?.localizedDescription ?? "Error adding location")
            }
        }
        searchVC.didSelect = { [weak self] (weather, error) in
            if error == nil, let weather = weather {
                
                self?.addPageWithWeather(weather.id)
                
            } else {
                self?.alert(message: error?.localizedDescription ?? "Error getting location")
            }
        }
        present(searchVC, animated: true, completion: nil)
    }
    
    func update(_ w: Weather) {
        if self.savedLocations == nil {DefaultsManager().addToSavedLocations(SavedLocation(id: w.id, name: w.name))
            return
            
        } else {
            DefaultsManager().addToSavedLocations(SavedLocation(id: w.id, name: w.name))
        }
        
        //getWeatherForIds()
    }
    
    @objc func goToSettings() {
        let settingsVC = SettingsTableViewController()
        settingsVC.didUpdatePrefs = {  result in
            NotificationCenter.default.post(name: NSNotification.Name.init("updatePrefs"), object: nil, userInfo: [:])
        }
        settingsVC.didRemoveLocation = { [weak self] identifer in
            
            if let pageToRemove = self?.pages.firstIndex(where: {$0.weather?.id == identifer}) {
                self?.pages.remove(at: pageToRemove)
                self?.initialPage = 0
                //self?.arrangePages()
            }
            if let pages = self?.pages {
                for (index, vc) in pages.enumerated() {
                    vc.weather?.index = index
                }
                self?.arrangePages()
            }
        }
        present(settingsVC, animated: true, completion: nil)
    }
    
}

extension WeatherPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? HomeViewController else {
            return nil
        }
        
        if let viewControllerIndex = self.pages.firstIndex(of: vc) {
            vcIndex = viewControllerIndex
            pageControl.currentPage = viewControllerIndex
            if viewControllerIndex == 0 {
                // wrap to last page in array
                //pageControl.currentPage = viewControllerIndex
                return nil
            } else {
                // go to previous page in array
                pageControl.currentPage = viewControllerIndex
                return self.pages[viewControllerIndex - 1]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? HomeViewController else {
            return nil
        }
        
        if let viewControllerIndex = self.pages.firstIndex(of: viewController) {
            vcIndex = viewControllerIndex
            pageControl.currentPage = viewControllerIndex
            if viewControllerIndex < self.pages.count - 1 {
                // go to next page in array
                //pageControl.currentPage = viewControllerIndex
                return self.pages[viewControllerIndex + 1]
            } else {
                // wrap to first page in array
                pageControl.currentPage = viewControllerIndex
                return nil
            }
        }
        return nil
    }
    
    
}
