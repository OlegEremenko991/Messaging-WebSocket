//
//  LoginViewModel.swift
//  Messaging app (WebSocket)
//
//  Created by Олег Еременко on 04.07.2020.
//  Copyright © 2020 Oleg Eremenko. All rights reserved.
//

import UIKit

final class LoginViewModel {
    
// MARK: Public properties
    
    weak var view: LoginVC?
    
// MARK: Private properties

    private var login = ""
    private var characterSet = CharacterSet.urlQueryAllowed
    
// MARK: Public methods

    func setUpView(){
        view?.nextBarButton.isEnabled = false
        view?.loginTextField.keyboardType = .asciiCapable
    }
    
    func checkLogin(_ sender: UITextField){
        if let _ = sender.text!.rangeOfCharacter(from: characterSet){
            view!.nextBarButton.isEnabled = true
            login = sender.text!
        } else {
            view!.nextBarButton.isEnabled = false
        }
    }
    
    func prepareSegue(_ segue: UIStoryboardSegue){
        if let vc = segue.destination as? MessagingVC {
            vc.username = login.withReplacedCharacters(" ", by: "%20")
            vc.displayedName = login
        }
    }
}
