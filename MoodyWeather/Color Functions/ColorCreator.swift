//
//  ColorCreatorViewController.swift
//  MoodyWeather
//
//  Created by Nicholas Reeder on 3/25/20.
//  Copyright © 2020 Nicholas Reeder. All rights reserved.
//


import UIKit
import Foundation

class ColorCreator {
    var view: UIView
    var timer: Timer?
    var moodColors = MoodColors().colors
    var moodyWeatherCreator: MoodyWeatherCreator?
    
    init(with view: UIView) {
        self.view = view
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(animateBackground), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    @objc func animateBackground() {
        
        UIView.animate(withDuration: 0.99, animations: {
            self.view.backgroundColor = self.moodColors.randomElement()
        })
        
    }
    
    func createMoodColor(weather: Weather){
        //stopTimer()
        self.moodyWeatherCreator = MoodyWeatherCreator(weather: weather)
        UIView.animate(withDuration: 2.0, animations: {
            self.view.backgroundColor = self.moodyWeatherCreator?.bgColor()
        })
    }
    
}



class MoodColors {
 
    
    var colors: [UIColor]
    
     init() {
        self.colors = [.tenseColor, .anxiousColor, .nervousColor, .averageColor, .chargedColor, .relaxedColor, .happyColor]
    }
}
