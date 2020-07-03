//
//  UITextFieldDelegate.swift
//  Messaging app (WebSocket)
//
//  Created by Олег Еременко on 03.07.2020.
//  Copyright © 2020 Oleg Eremenko. All rights reserved.
//

import UIKit

extension LoginVC: UITextFieldDelegate {
    // Разрешаем ввод в текстфилде строго по маске
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 20
        do {
            // Задаем маску и проверяем текстфилд, запрещаем вводить другие символы/буквы
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: [])
            if regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) != nil { return false }
           
            // Проверяем количество символов в текстфилде и удаляем лишние
            if range.location > maxLength - 1 {
                textField.text?.removeLast()
            }
        }
        catch {
            print("ERROR")
        }
        return true
    }
    
    // Переходим на второй экран при нажатии enter в текстфилде
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text!.isEmpty {
            return false
        }
        performSegue(withIdentifier: "loginEntered", sender: self)
        return true
    }
}
