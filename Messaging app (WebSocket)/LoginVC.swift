//
//  ViewController.swift
//  Messaging app (WebSocket)
//
//  Created by Олег Еременко on 02.07.2020.
//  Copyright © 2020 Oleg Eremenko. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    var login = ""
    var characterSet = CharacterSet.urlQueryAllowed
        
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var nextBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextBarButton.isEnabled = false
        loginTextField.keyboardType = .asciiCapable
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "loginEntered",
        let vc = segue.destination as? MessagingVC else {
            return
        }
        vc.username = login
    }

    @IBAction func loginChanged(_ sender: UITextField) {
        if let _ = sender.text!.rangeOfCharacter(from: characterSet){
            nextBarButton.isEnabled = true
            login = sender.text!
        } else {
            nextBarButton.isEnabled = false
        }
    }
}

extension LoginVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            print("Backspace was pressed")
            return true
        }
        
        if string == " " || string.isCyrillic { return false }

        return true
    }
}
