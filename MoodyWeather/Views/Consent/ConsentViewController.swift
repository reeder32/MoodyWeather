//
//  ConsentViewController.swift
//  MoodyWeather
//
//  Created by Nicholas Reeder on 3/3/21.
//  Copyright © 2021 Nicholas Reeder. All rights reserved.
//

import UIKit
import NR

class ConsentViewController: UIViewController, URLButton {
    func didChangeConsent(value: ReederScale, jurisdiction: ReederPlatform) {
        dismiss(animated: true) {
            ConsentManager.shared.post(value, jurisdiction)
        }
      
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var declineButton: ConsentButton!
    @IBOutlet weak var privacyPolicyButton: ConsentButton!
    @IBOutlet weak var agreeButton: ConsentButton!
   
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var optOutLocationButton: ConsentButton!
    
    var type: ConsentViewType?
    override func viewDidLoad() {
        titleLabel.font = Fonts.Bold.of(25)
        appNameLabel.font = Fonts.Bold.of(35)
        textView.font = Fonts.Regular.of(15)
        textView.layer.cornerRadius = Constants.buttonRadius
        super.viewDidLoad()
        if type != nil {
            setupViews()
        } else {
            dismiss(animated: true, completion: nil)
        }
        isModalInPresentation = true
        // Do any additional setup after loading the view.
    }
    
    func setupViews() {
        
        setUpLabels()
        setUpBodyText()
        setUpButtons()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.HasSeenConsent.rawValue)
    }
    
    // MARK: - Text View
    
    private func setUpBodyText() {
        switch type {
        case .GDPR:
            self.textView.text = ConsentBody.GDPR.rawValue
        case .CCPA:
            self.textView.text = ConsentBody.CCPA.rawValue
        default:
            self.textView.text = ConsentBody.default.rawValue
        }
    }
    
    // MARK: - Labels
    private func setUpLabels() {
        switch type {
        case .GDPR:
            titleLabel.text = "GDPR Privacy Notice"
        case .CCPA:
            titleLabel.text = "CCPA Privacy Notice"
        default:
            titleLabel.text = "Privacy Notice"
        }
    }
    
    // MARK: - Buttons
    private func setUpButtons() {
        switch type {
        case .GDPR:
            print("Not sure I'll need this...")
        case .CCPA:
            optOutLocationButton.title("Opt-out, Use Location")
            privacyPolicyButton.title("Privacy Policy")
            declineButton.title("Opt-out")
            agreeButton.title("Proceed")
        default:
            optOutLocationButton.title("Opt-out, Use Location")
            declineButton.title("Opt-out")
            agreeButton.title("Okay")
            privacyPolicyButton.title("Privacy Policy")
        }
        
        agreeButton.addTarget(self, action: #selector(agreeButtonPressed), for: .touchUpInside)
        privacyPolicyButton.addTarget(self, action: #selector(privacyButtonPressed), for: .touchUpInside)
        declineButton.addTarget(self, action: #selector(declineButtonPressed), for: .touchUpInside)
        optOutLocationButton.addTarget(self, action: #selector(declineButtonPressed), for: .touchUpInside)
        optOutLocationButton.isHidden = true
    }
  
    
    @objc func privacyButtonPressed() {
        goToPrivacyPolicyURL()
    }
    
    @objc func agreeButtonPressed() {
       self.didChangeConsent(value: .Begin, jurisdiction: .defaultPlatform)
     
       
    }
    
    @objc func declineButtonPressed() {
        //TODO: opt-out and no location permission
        self.didChangeConsent(value: .LastTime, jurisdiction: .defaultPlatform)
    }
    
 
    
}

extension UIButton {
    func title(_ title: String) {
        self.setTitle(title, for: .normal)
    }
}

class ConsentButton: UIButton {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        layer.cornerRadius = Constants.buttonRadius
        backgroundColor = .systemGray5
        setTitleColor(Constants.labelColor, for: .normal)
        titleLabel?.font = Fonts.Bold.of(17.5)
    }
}

extension UIViewController {
    func showConsentView() {
       
            if let vc = UIStoryboard(name: "ConsentStoryboard", bundle: nil).instantiateViewController(identifier: "Consent") as? ConsentViewController {
                vc.type = .Default
                let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow} ).first
                if let topController = keyWindow?.rootViewController {
                    print(topController.presentedViewController?.presentedViewController)
                    topController.presentedViewController?.presentedViewController?.present(vc, animated: true, completion: nil)
                } else {
                    
                }
            }
        }
    
}

    

