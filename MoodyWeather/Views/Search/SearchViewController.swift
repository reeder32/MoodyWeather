//
//  SearchViewController.swift
//  MoodyWeather
//
//  Created by Nicholas Reeder on 3/23/20.
//  Copyright © 2020 Nicholas Reeder. All rights reserved.
//



import UIKit
import CoreLocation
import MapKit

class SearchViewController: UIViewController {
    
    
    lazy var searchBar : UISearchBar = {
        let sb = UISearchBar()
        sb.delegate = self
        sb.placeholder = "Search by location or zip code"
        sb.tintColor = .white
        sb.barStyle = .default
        sb.backgroundImage = UIImage()
        sb.backgroundColor = .clear
        sb.keyboardAppearance = .light
        sb.searchTextField.font = UIFont.preferredFont(forTextStyle: .body)
        sb.searchTextField.textColor = Constants.labelColor
        return sb
    }()
    
    lazy var locationButton: UIButton = {
        let b = UIButton()
        b.setTitle("Or use current location", for: .normal)
        b.layer.borderColor = UIColor(white: 1, alpha: 1).cgColor
        b.layer.borderWidth = 1.5
        b.layer.cornerRadius = Constants.buttonRadius
        b.clipsToBounds = true
        b.titleLabel?.font = Fonts.Bold.of(12)
        b.titleEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        b.titleLabel?.adjustsFontSizeToFitWidth = true
        //b.titleLabel?.numberOfLines = 0
        b.addTarget(self, action: #selector(didTapLocation), for: .touchUpInside)
        return b
    }()
    
    let decoder = JSONDecoder()
    let tableView = UITableView()
    private let apiConnector = OpenWeatherMapApiConnector.shared
    let defaults = UserDefaults.standard
    var onDismiss: ((Bool) -> Void)?
    var didSelect: ((Weather?, Error?) -> Void)?
    var didAdd: ((Weather?, Error?) -> Void)?
    var weather: Weather?
    var searchPlaces: [MKMapItem]? {
        didSet {
            tableView.reloadData()
        }
    }
    var localSearch: MKLocalSearch?
    var geocoder = CLGeocoder()
    var spinner = UIActivityIndicatorView()
    let locationManager = LocationManager.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .happyColor
        setupview()
        setupConstraints()
        setupTableView()
        //loadZipCodes()
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "cell")
        spinner = UIActivityIndicatorView(frame: CGRect(x: self.view.center.x, y: self.view.center.y, width: 37, height: 37))
        spinner.style = .large
        spinner.hidesWhenStopped = true
        spinner.color = .white
        
        NotificationCenter.default.addObserver(forName: UIContentSizeCategory.didChangeNotification, object: nil, queue: .main) { (notif) in
            self.tableView.reloadData()
        }
        
        if self.locationManager.manager?.location != nil {
            self.locationButton.alpha = 0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //loadCities()
        self.searchBar.becomeFirstResponder()
    
    }
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupview() {
        self.view.addSubview(searchBar)
        self.view.addSubview(locationButton)
        self.view.addSubview(self.tableView)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: spinner.frame)
        tableView.alpha = 0
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = .anxiousColor
        tableView.backgroundColor = .clear
    }
    
    func setupConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 48).isActive = true
        searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        searchBar.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        locationButton.centerXAnchor.constraint(equalTo: searchBar.centerXAnchor, constant: 0).isActive = true
        locationButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16).isActive = true
        
        tableView.topAnchor.constraint(equalTo: locationButton.bottomAnchor, constant: 8).isActive = true
        tableView.centerXAnchor.constraint(equalTo: searchBar.centerXAnchor, constant: 0).isActive = true
        tableView.widthAnchor.constraint(equalTo: searchBar.widthAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor, constant: 16).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
    @objc func didTapLocation() {
       
        locationManager.start()
        locationManager.didGetLocation = { [weak self] location, error in
            if let location = location {
                self?.locationManager.stop()
                
                self?.apiConnector.getWeatherForCurrentLocation(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
                
                self?.apiConnector.didGetWeather = { (weather, error) in
                    if let err = error { self?.alert(message: err.localizedDescription); return }
                    guard let weather = weather, error == nil else {
                        // need to inform user of error
                        
                        return
                    }
                    if error != nil { self?.didSelect?(nil, error); return}
                    DispatchQueue.main.async {
                        
                        self?.dismiss(animated: true) {
                            
                            self?.didSelect?(weather, nil)
                            //self.onDismiss?(true)
                        }
                    }
                }
            } else {
                if error != nil {self?.goToSettingsAlert(); return }
            }
        }
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            tableView.alpha = 0
            return
        }
        
        spinner.startAnimating()
        
        let request = MKLocalSearch.Request()
        request.resultTypes = .pointOfInterest
        request.naturalLanguageQuery = searchText
        request.region = MKCoordinateRegion(center: request.region.center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        let search = MKLocalSearch(request: request)
        search.start { [weak self] (response, error) in
            guard error == nil else {
                //self?.alert(message: error?.localizedDescription ?? "Error getting search results")
                return
            }
            
            self?.searchPlaces = response?.mapItems
            self?.spinner.stopAnimating()
            
        }
        
        if tableView.alpha == 0 { tableView.alpha = 1 }
        
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return spinner
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = searchPlaces?[indexPath.row].placemark.coordinate
        
        self.apiConnector.getWeatherForCurrentLocation(lat: location?.latitude, lon: location?.longitude)
        self.apiConnector.didGetWeather = { (weather, error) in
            if let err = error { self.alert(message: err.localizedDescription); return }
            if weather == nil && error == nil { self.alert(message: "Unable to get weather for this location.") }
            guard var weather = weather, error == nil else { return }
            
            if let city = self.searchPlaces?[indexPath.row].placemark.locality, let name = self.searchPlaces?[indexPath.row].name {
                weather.name = ("\(city)(\(name))")
            }
            if error != nil { self.didSelect?(nil, error); return}
            DispatchQueue.main.async {
                self.didSelect?(weather, nil)
                //print(weather.name)
                self.dismiss(animated: true) {
                    self.onDismiss?(true)
                }
            }
            
        }
    }
    
    func addPlace(_ indexPath: IndexPath) {
        let location = searchPlaces?[indexPath.row].placemark.coordinate
        
        self.apiConnector.getWeatherForCurrentLocation(lat: location?.latitude, lon: location?.longitude)
        self.apiConnector.didGetWeather = { (weather, error) in
            if let err = error { self.alert(message: err.localizedDescription); return }
            if weather == nil && error == nil { self.alert(message: "Unable to get weather for this location.") }
            guard let weather = weather, error == nil else { return }
            
            if error != nil { self.didAdd?(nil, error); return}
            DispatchQueue.main.async {
                self.didAdd?(weather, nil)
                self.dismiss(animated: true) {
                    
                    //self.onDismiss?(true)
                }
            }
            
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchPlaces?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = SearchTableViewCell()
        
        if let place = searchPlaces?[indexPath.row] {
            cell.configureWithPlace(place)
            
            cell.didTapAddButton = { [weak self] didTap in
                if didTap {
                    self?.addPlace(indexPath)
                }
            }
            //cell.detailTextLabel?.text = ("\(cellData.zipCode)")
        }
        return cell
    }
    
    
}

