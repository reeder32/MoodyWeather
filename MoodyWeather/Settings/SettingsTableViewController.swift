//
//  SettingsTableViewController.swift
//  MoodyWeather
//
//  Created by Nicholas Reeder on 4/9/20.
//  Copyright © 2020 Nicholas Reeder. All rights reserved.
//

enum SettingsSection: Int {
    case Temperature = 0
    case SavedPlaces
    case ThankYous
}

import UIKit

class SettingsTableViewController: UITableViewController {
    var savedPlaces : [SavedLocation] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    let urlKeys = ["weather data", "moon data"]
    let urlValues = [ "openweathermap.org", "farmsense.net"]
    var didUpdatePrefs: ((Bool?) -> Void)?
    var didRemoveLocation: ((Int?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TemperatureCell.self, forCellReuseIdentifier: "tempCell")
        tableView.register(SavedPlacesCell.self, forCellReuseIdentifier: "placeCell")
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "settingsCell")
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .clear
        view.backgroundColor = .chargedColor
        tableView.separatorColor = .clear
        self.savedPlaces = DefaultsManager().savedLocations ?? []
        
    }
    
  // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SettingsSection.Temperature.rawValue {
            return 1
        } else if section == SettingsSection.SavedPlaces.rawValue {
            return savedPlaces.count
        } else if section == SettingsSection.ThankYous.rawValue {
            return urlValues.count
        } else {
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SettingsSection.Temperature.rawValue {
            let cell = TemperatureCell()
            cell.configureCell()
            cell.updatePrefs = { [weak self] value in
                self?.didUpdatePrefs?(value)
            }
            return cell
        } else if indexPath.section == SettingsSection.SavedPlaces.rawValue {
            let cell = SavedPlacesCell(style: .default, reuseIdentifier: "placeCell")
            cell.configureCell(savedPlaces[indexPath.row])
            return cell
        } else {
            let cell = SettingsCell(style: .value1, reuseIdentifier: "settingsCell")
            let key = urlKeys[indexPath.row]
            let value = urlValues[indexPath.row]
            cell.configureCell(key, value)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == SettingsSection.Temperature.rawValue {
            return "Preferences"
        } else if section == SettingsSection.SavedPlaces.rawValue {
            return "Saved Places"
        } else {
            return "Thank yous"
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = .tenseColor
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SettingsSection.ThankYous.rawValue {
            if indexPath.row == 0 {
                goToOMW()
            } else {
                goToFarmSense()
            }
        }
    }
    
    func goToOMW() {
        if let url = URL(string: "https://openweathermap.org/") {
            UIApplication.shared.open(url)
        }
    }
    func goToFarmSense() {
        if let url = URL(string: "http://farmsense.net") {
            UIApplication.shared.open(url)
        }
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if indexPath.section == SettingsSection.SavedPlaces.rawValue {
            return true
        } else {
            return false
        }
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == SettingsSection.SavedPlaces.rawValue {
                let alert = UIAlertController(title: "Delete saved place?", message: "Would you like to remove \(savedPlaces[indexPath.row].name)", preferredStyle: .actionSheet)
                let delete = UIAlertAction(title: "Delete", style: .destructive) {[weak self] (action) in
                    self?.delete(indexPath, indexPath.row)
                }
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(delete)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
            }
            // Delete the row from the data source
            
        }
    }
    
    func delete(_ indexPath: IndexPath, _ row: Int) {
        DefaultsManager().removeSavedLocation(savedPlaces[indexPath.row]) { [weak self] (didDelete) in
            if didDelete {
                self?.didRemoveLocation?(self?.savedPlaces[indexPath.row].id)
                self?.tableView.beginUpdates()
                self?.savedPlaces.remove(at: indexPath.row)
                self?.tableView.deleteRows(at: [indexPath], with: .left)
                self?.tableView.endUpdates()
                //self?.savedPlaces.remove(at: indexPath.row)
            } else {
                
            }
        }
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

class SettingsCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureCell(_ type: String, _ urlString: String) {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        textLabel?.textColor = .white
        detailTextLabel?.textColor = .init(white: 1, alpha: 0.5)
        textLabel?.text = type
        detailTextLabel?.text = urlString
    }
    
}

class SavedPlacesCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(_ place: SavedLocation) {
        selectionStyle = .none
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        textLabel?.textColor = .white
        self.textLabel?.text = place.name
    }
}

class TemperatureCell: UITableViewCell {
    lazy var cButton: UIButton = {
        let b = UIButton()
        b.sizeThatFits(CGSize(width: 40, height: 50))
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("℃", for: .normal)
        b.tag = 100
        b.addTarget(self, action: #selector(updateTempPrefs(_:)), for: .touchUpInside)
        return b
    }()
    
    lazy var fButton: UIButton = {
        let b = UIButton()
        b.sizeThatFits(CGSize(width: 40, height: 50))
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("℉", for: .normal)
        b.tag = 200
        b.addTarget(self, action: #selector(updateTempPrefs(_:)), for: .touchUpInside)
        return b
    }()
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .white
        l.text = "Temperature scale"
        l.textAlignment = .left
        l.numberOfLines = 0
        return l
    }()
    
    let defaults = UserDefaults.standard
    var updatePrefs: ((Bool?) -> Void)?
    
    func configureCell() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        cButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
        fButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
        selectionStyle = .none
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        setupview()
        setupConstraints()
    }
    
    func setupview() {
        self.contentView.addSubview(cButton)
        self.contentView.addSubview(fButton)
        self.contentView.addSubview(titleLabel)
        if let pref = defaults.value(forKey: UserDefaultsKeys.ScalePref.rawValue) as? Int {
            switch pref {
            case 0:
                cButton.alpha = 1
                fButton.alpha = 0.5
            default:
                cButton.alpha = 0.5
                fButton.alpha = 1
            }
        }
    }
    func setupConstraints() {
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        titleLabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 0).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -100).isActive = true
        cButton.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 0).isActive = true
        cButton.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor, constant: 0).isActive = true
        cButton.trailingAnchor.constraint(equalTo: fButton.leadingAnchor, constant: -8).isActive = true
        cButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        fButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        fButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
    }
    
    @objc  func updateTempPrefs(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        
        if button.tag == 100 {
            defaults.set(0, forKey: UserDefaultsKeys.ScalePref.rawValue)
            cButton.alpha = 1
            fButton.alpha = 0.5
        } else {
            defaults.set(1, forKey: UserDefaultsKeys.ScalePref.rawValue)
            cButton.alpha = 0.5
            fButton.alpha = 1
        }
        updatePrefs?(true)
    }
    
}
