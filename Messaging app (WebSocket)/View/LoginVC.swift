//
//  ViewController.swift
//  Messaging app (WebSocket)
//
//  Created by Олег Еременко on 02.07.2020.
//  Copyright © 2020 Oleg Eremenko. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    var viewModel: LoginViewModel?
        
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var nextBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = LoginViewModel.init()
        viewModel?.view = self
        viewModel?.setUpView()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        viewModel?.prepareSegue(segue)
    }

    @IBAction func loginChanged(_ sender: UITextField) {
        viewModel?.checkLogin(sender)
    }
}
