//
//  FakeSceneVC.swift
//  KipIt
//
//  Created by djepbarov on 22.01.2018.
//  Copyright © 2018 djepbarov. All rights reserved.
//

import UIKit

class FakeSceneVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    }
    
    func setNavigationBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addAlbum))
        let settingsButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(self.settings))
        self.navigationItem.leftBarButtonItem = addButton
        self.navigationItem.rightBarButtonItem = settingsButton
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .always
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        navigationItem.title = "Albums"
    }
    
    @objc func addAlbum() {
        
    }
    
    @objc func settings() {
        
    }
}
