//
//  LoginViewModel.swift
//  Messaging app (WebSocket)
//
//  Created by Олег Еременко on 04.07.2020.
//  Copyright © 2020 Oleg Eremenko. All rights reserved.
//

import UIKit

class LoginViewModel {
    
    weak var view: LoginVC?
    var login = ""
    var characterSet = CharacterSet.urlQueryAllowed
    
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
            vc.username = login
        }
    }
}
