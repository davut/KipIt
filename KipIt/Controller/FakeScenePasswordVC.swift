//
//  newKipVC.swift
//  KipIt
//
//  Created by djepbarov on 11.01.2018.
//  Copyright © 2018 djepbarov. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class FakeScenePasswordVC: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        setDoneButton()
        
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
        let alert = UIAlertController(title: "Your second password is", message: textField.text!, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ok, I'll remember It", style: .default, handler: { (alertAction) in
            self.dismiss(animated: true, completion: {
                KeychainWrapper.standard.set(self.textField.text!, forKey: "mySecondPs")
            })
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func setDoneButton() {
        let keyboardToolBar = UIToolbar()
        keyboardToolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Create!", style: .done, target: self, action: #selector(self.doneClicked))
        keyboardToolBar.setItems([flexibleSpace, doneButton], animated: true)
        textField.inputAccessoryView = keyboardToolBar
    }
}

extension FakeScenePasswordVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 6
    }
}
