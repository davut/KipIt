//
//  SettingsVC.swift
//  KipIt
//
//  Created by djepbarov on 8.01.2018.
//  Copyright © 2018 djepbarov. All rights reserved.
//

import UIKit
import LocalAuthentication
import SwiftKeychainWrapper
class SettingsVC: UIViewController {

    @IBOutlet weak var setTouchIdUsageBtn: UIButton!
    @IBOutlet weak var switchForTouchID: UISwitch!
    var mainKip = "Go to Main Scene"
    var secondKip = "Go to Fake Scene"
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        stateOfTouchId()
        
    }
    
    @IBAction func touchIdSwitchValueChanged(_ sender: UISwitch){
        if sender.isOn {
            KeychainWrapper.standard.set(true, forKey: "touchID")
        }else {
            KeychainWrapper.standard.set(false, forKey: "touchID")
        }
        setTouchIdUsageBtn.isEnabled = sender.isOn
    }
    
    func stateOfTouchId() {
        switchForTouchID.isOn = KeychainWrapper.standard.bool(forKey: "touchID") == true ? true : false
        setTouchIdUsageBtn.isEnabled = switchForTouchID.isOn
        setTouchIdUsageBtn.setTitle(KeychainWrapper.standard.bool(forKey: "isMainKip") == true ? secondKip : mainKip, for: .normal)
    }
    @IBAction func setTouchIdUsageBtnPressed(_ sender: UIButton) {
        if sender.currentTitle == mainKip {
            KeychainWrapper.standard.set(true, forKey: "isMainKip")
            setTouchIdUsageBtn.setTitle(secondKip, for: .normal)
        }
        else if sender.currentTitle == secondKip {
            KeychainWrapper.standard.set(false, forKey: "isMainKip")
            setTouchIdUsageBtn.setTitle(mainKip, for: .normal)
        }
    }
}
