//
//  UITextFieldDelegate.swift
//  Messaging app (WebSocket)
//
//  Created by Олег Еременко on 03.07.2020.
//  Copyright © 2020 Oleg Eremenko. All rights reserved.
//

import UIKit

extension LoginVC: UITextFieldDelegate {
    // Check text field and replace invalid characters
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 20
        do {
            
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: [])
            if regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) != nil { return false }
           
            // remove excess characters
            if range.location > maxLength - 1 {
                textField.text?.removeLast()
            }
        }
        catch {
            print("ERROR")
        }
        return true
    }
    
    // Go to the second screen on "Enter" button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text!.isEmpty {
            return false
        }
        performSegue(withIdentifier: "loginEntered", sender: self)
        return true
    }
}
