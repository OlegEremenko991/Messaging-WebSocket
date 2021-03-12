//
//  LoginViewModel.swift
//  Messaging app (WebSocket)
//
//  Created by Олег Еременко on 04.07.2020.
//  Copyright © 2020 Oleg Eremenko. All rights reserved.
//

import UIKit

final class LoginViewModel {
    
    // MARK: - Public properties
    
    weak var view: LoginVC?

    // MARK: Private properties

    private var login = ""
    private var characterSet = CharacterSet.urlQueryAllowed
    
    // MARK: - Public methods
    
    func checkLogin(_ sender: UITextField){
        if let _ = sender.text!.rangeOfCharacter(from: characterSet){
            view!.changeButtonState(enabled: true)
            login = sender.text!
        } else {
            view!.changeButtonState(enabled: false)
        }
    }

    func displayedName() -> String {
        login
    }

    func userName() -> String {
        login.replacingOccurrences(of: " ", with: "%20")
    }

}
