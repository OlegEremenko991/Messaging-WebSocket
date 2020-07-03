//
//  CustomLoginTextField.swift
//  Messaging app (WebSocket)
//
//  Created by Олег Еременко on 03.07.2020.
//  Copyright © 2020 Oleg Eremenko. All rights reserved.
//

import UIKit

class CustomLoginTextField: UITextField {
    // Отключаем возможность "Вставлять" текст в поле
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
