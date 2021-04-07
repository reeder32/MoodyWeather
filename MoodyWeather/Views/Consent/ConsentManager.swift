//
//  ConsentManager.swift
//  MoodyWeather
//
//  Created by Nicholas Reeder on 3/9/21.
//  Copyright © 2021 Nicholas Reeder. All rights reserved.
//
protocol ConsentManagerDelegate: AnyObject {
    func showConsentView(_ value: Bool)
}

extension ConsentManager: ConsentManagerDelegate {
    func showConsentView(_ value: Bool) { }
}

import UIKit
import NR

class ConsentManager: NSObject {
    static let shared = ConsentManager()
    weak var delegate: ConsentManagerDelegate?
    
    override init() {
        
    }
    
    func initNR () {
        NR.sharedInstance()?.isDebugMode = true
        NR.sharedInstance()?.debugSetSendBatch(whenLocationReceived: true)
        NR.sharedInstance()?.debugRemovePinning = true
        NR.sharedInstance()?.debugAllowInitOverVPN = true
        NR.sharedInstance()?.initStyle(Constants.style, home:Constants.home, complete: { (error, region) in
            if error == nil {
                print("NR inited successfully")
                
            } else {
                print("error:",error?.localizedDescription ?? "")
                
                switch error?.localizedDescription {
                case "CartEmpty":
                    // CartEmpty = User has not responded to consent yet for that jurisdiction.
                    print("j:",region)
                    
                    switch region {
                    case 1:
                        // Default
                        self.delegate?.showConsentView(true)
                    case 2:
                        // GDPR
                        self.delegate?.showConsentView(false)
                    case 3:
                        // CCPA
                        self.delegate?.showConsentView(true)
                    default:
                        // 0 = None.
                        ConsentManager.shared.delegate?.showConsentView(true)
                    }
                    
                case "IdfaPermissionRejected":
                    print("idfa rejected")
                // User said no to IDFA permission. Potentially nag them to accept IDFA for app to work.
                
                case "LocationPermissionRejected":
                    print("location permission rejected")
                // User said no to Location permission. Potentially nag them to accept permission for app to work.
                
                case "ConsentRejected":
                    print("consent rejected")
                // User said no to consent.
                
                default:
                    print("unknown error: \(error?.localizedDescription ?? "")")
                    
                }
                
            }
        })
    }
    
    func post(_ scale: Int32, _ region: Int32) {
       
        NR.sharedInstance()?.postScale(scale, withRegion: region, complete: { [weak self] (success) in
            if success {
                self?.initNR() // second time through will successfully init NR fully
            } else {
                
            }
        })
    }
}
