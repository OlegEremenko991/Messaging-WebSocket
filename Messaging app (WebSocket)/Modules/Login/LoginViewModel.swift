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

    func setUpView(){
        view?.changeButtonState(enabled: false)
        view?.setupTextField()
    }
    
    func checkLogin(_ sender: UITextField){
        if let _ = sender.text!.rangeOfCharacter(from: characterSet){
            view!.changeButtonState(enabled: true)
            login = sender.text!
        } else {
            view!.changeButtonState(enabled: false)
        }
    }
    
    func prepareSegue(_ segue: UIStoryboardSegue){
        if let vc = segue.destination as? MessagingVC {
            vc.username = login.replacingOccurrences(of: " ", with: "%20")
            vc.displayedName = login
        }
    }
}
