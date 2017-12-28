//
//  FirstLaunch.swift
//  KipIt
//
//  Created by djepbarov on 26.12.2017.
//  Copyright © 2017 djepbarov. All rights reserved.
//

import Foundation
final class FirstLaunch {
    
    let userDefaults: UserDefaults = .standard
    
    let wasLaunchedBefore: Bool
    var isFirstLaunch: Bool {
        return !wasLaunchedBefore
    }
    
    init() {
        let key = "com.developerdavut.kipIt.FirstLaunch.WasLaunchedBefore"
        let wasLaunchedBefore = userDefaults.bool(forKey: key)
        self.wasLaunchedBefore = wasLaunchedBefore
        if !wasLaunchedBefore {
            userDefaults.set(true, forKey: key)
        }
    }
}
