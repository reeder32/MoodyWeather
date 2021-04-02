//
//  DefaultsManager.swift
//  MoodyWeather
//
//  Created by Nicholas Reeder on 4/13/20.
//  Copyright © 2020 Nicholas Reeder. All rights reserved.
//
enum UserDefaultsKeys: String {
    case LocationCoordinates
    case LocationID
    case ScalePref
    case RecentWeather
    case RecentMoon
    case SavedLocations
    case HasSeenDescriptionPopup
    case HasSeenShakeFeature
    case HasSeenConsent
}

import Foundation

class DefaultsManager: NSObject {
    
    let defaults = UserDefaults.standard
    var savedLocations: [SavedLocation]?
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    override init() {
        super.init()
        self.savedLocations = getLocations()
    }
    func getLocations() -> [SavedLocation] {
        guard let savedLocations = self.defaults.value(forKey: UserDefaultsKeys.SavedLocations.rawValue) as? Data else  {
            return []
            
        }
        
        if let locations = try? decoder.decode([SavedLocation].self, from: savedLocations) {
            return locations
        } else {
            return []
        }
    }
    
    func addToSavedLocations(_ savedLocation: SavedLocation?) {
        guard let savedLocation = savedLocation else { return }
        var locations = self.savedLocations
        locations?.append(savedLocation)
        let savedLocations = try? encoder.encode(locations)
        self.defaults.setValue(savedLocations, forKey: UserDefaultsKeys.SavedLocations.rawValue)
    }
    
    func removeSavedLocation(_ savedLocation: SavedLocation?, completion: @escaping (_ : Bool) -> Void) {
        guard let savedLocation = savedLocation else { return }
        if let removeLocation = self.savedLocations?.firstIndex(where: {$0.id == savedLocation.id}) {
            
            self.savedLocations?.remove(at: removeLocation)
            let save = try? self.encoder.encode(self.savedLocations)
            self.defaults.setValue(save, forKey: UserDefaultsKeys.SavedLocations.rawValue)
             completion(true)
        } else {
            completion(false)
        }
    
    }
      
}
