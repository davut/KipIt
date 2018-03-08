//
//  ViewController.swift
//  KipIt
//
//  Created by djepbarov on 26.12.2017.
//  Copyright © 2017 djepbarov. All rights reserved.
//

import UIKit
import LocalAuthentication
import SwiftKeychainWrapper
class Login: UIViewController {
    
    @IBOutlet weak var emojiLbl: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet var numberButtons: [UIButton]!
    let firstLaunch = FirstLaunch()
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        textField.becomeFirstResponder()
        setDoneButton()
        if firstLaunch.wasLaunchedBefore {
            if KeychainWrapper.standard.bool(forKey: "touchID") == true {
                touchId()
            }
        }
    }
    
    
    @objc func doneClicked() {
        view.endEditing(true)
        guard textField.text?.count == 6 else {return self.view.shake()}
        
        if firstLaunch.isFirstLaunch {
            let alert = UIAlertController(title: "Your password is", message: textField.text!, preferredStyle: .actionSheet)
            KeychainWrapper.standard.set(self.textField.text!, forKey: "myPs")
            alert.addAction(UIAlertAction(title: "Ok, I'll remember It", style: .default, handler: { (alertAction) in
                self.performSegue(withIdentifier: "toMainScene", sender: nil)
            }))
            present(alert, animated: true, completion: nil)
        } else {
            // App opened before
            let psswrd: String? = KeychainWrapper.standard.string(forKey: "myPs")
            let secondPsswrd: String? = KeychainWrapper.standard.string(forKey: "mySecondPs")
            if let mainPass = psswrd {
                if mainPass == textField.text! {
                    performSegue(withIdentifier: "toMainScene", sender: nil)
                }
                else if secondPsswrd == textField.text! {
                    performSegue(withIdentifier: "toFakeScene", sender: nil)
                }
                else {
                    self.view.shake()
                }
            }
        }
    }
}

extension Login: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 6
    }
    
    // TODO: Handle which scene to go
    func touchId() {
        let context = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil){
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To pass in we need your Touch Id", reply: { (success, err) in
                if success {
                    // Enter with touch id
                    DispatchQueue.main.sync {
                        self.performSegue(withIdentifier: KeychainWrapper.standard.bool(forKey: "isMainKip") == true ? "toMainScene" : "toFakeScene", sender: self)
                    }
                }
                else {
                    // Error
                }
            })
        }
    }
    
    func setDoneButton() {
        let keyboardToolBar = UIToolbar()
        keyboardToolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "GO!", style: .done, target: self, action: #selector(self.doneClicked))
        keyboardToolBar.setItems([flexibleSpace, doneButton], animated: true)
        textField.inputAccessoryView = keyboardToolBar
    }
    
}

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
