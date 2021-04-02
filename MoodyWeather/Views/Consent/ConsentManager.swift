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
        #if DEBUG
        NR.sharedInstance()?.isDebugMode = true
        NR.sharedInstance()?.debugSetSendBatch(whenLocationReceived: true)
        #endif
       
    }
    
    func initNR() {
      
            NR.sharedInstance()?.initWithApiKey(Constants.apiKey, baseUrl: Constants.baseURL, complete: { [weak self] (error, jurisdiction) in
                if error == nil {
                    print("NR inited successfully")
                    self?.delegate?.showConsentView(false)
                   
                } else {
                    
                    switch error?.localizedDescription {
                    case "ZoomNothingYet":
                        debugPrint(jurisdiction)
                        if jurisdiction == .defaultPlatform {
                            self?.delegate?.showConsentView(true)
                        }
                    case "IdfaPermissionRejected":
                        print("No idfa permission")
                        self?.delegate?.showConsentView(false)
                    case "ZoomRejected":
                        //self?.post(.Begin, jurisdiction)
                        self?.delegate?.showConsentView(false)
                    default:
                        print("unknown error: \(error?.localizedDescription ?? "")")
                        self?.delegate?.showConsentView(false)
                    }
                   
                    print(error?.localizedDescription ?? "")
                }
            })
        
    }
    
    
    func post(_ consent: ReederScale, _ jurisdiction: ReederPlatform) {
        NR.sharedInstance()?.postConsentValue(consent, withJurisdiction: jurisdiction, complete: { [weak self] (success) in
            if success {
                // post to delegate
                self?.initNR()
            } else {
                
            }
        })
    }
    
    
    
}
