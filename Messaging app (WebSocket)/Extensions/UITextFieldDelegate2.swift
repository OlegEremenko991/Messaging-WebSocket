//
//  UITextFieldDelegate2.swift
//  Messaging app (WebSocket)
//
//  Created by Олег Еременко on 03.07.2020.
//  Copyright © 2020 Oleg Eremenko. All rights reserved.
//

import UIKit

extension MessagingVC: UITextFieldDelegate {
    // Отправка сообщения по нажатию Enter в текстфилде
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendAction()
        return true
    }
}
