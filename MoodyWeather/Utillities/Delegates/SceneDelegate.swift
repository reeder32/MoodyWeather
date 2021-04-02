//
//  SceneDelegate.swift
//  MoodyWeather
//
//  Created by Nicholas Reeder on 3/23/20.
//  Copyright © 2020 Nicholas Reeder. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let defaults = UserDefaults.standard
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
     
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
       
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        showLoadingScreen(scene)
        ConsentManager.shared.delegate = self
        if defaults.bool(forKey: UserDefaultsKeys.HasSeenConsent.rawValue) {
            ConsentManager.shared.initNR()
        }
    }
    
    func showLoadingScreen(_ scene: UIScene?) {
       
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = LoadingViewController()
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

extension SceneDelegate: ConsentManagerDelegate {
    func showConsentView(_ value: Bool) {
        
        if value {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                
                self.showConsentView()
            }
           
        }
    }
    func showConsentView() {
       
            if let vc = UIStoryboard(name: "ConsentStoryboard", bundle: nil).instantiateViewController(identifier: "Consent") as? ConsentViewController {
                vc.type = .Default
                let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow} ).first
                if let topController = keyWindow?.rootViewController {
                    if topController.presentedViewController is WeatherPageViewController {
                    topController.presentedViewController?.present(vc, animated: true, completion: nil)
                    } else {
                        topController.presentedViewController?.presentedViewController?.present(vc, animated: true, completion: nil)
                    }
                } else {
                    
                }
            }
        }

    
}


