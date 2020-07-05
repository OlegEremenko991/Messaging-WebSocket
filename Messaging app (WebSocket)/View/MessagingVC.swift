//
//  ViewController1.swift
//  Messaging app (WebSocket)
//
//  Created by Олег Еременко on 02.07.2020.
//  Copyright © 2020 Oleg Eremenko. All rights reserved.
// TARGET: ws://pm.tada.team/ws?name=testUser

import UIKit
import Starscream
import SwiftyJSON

class MessagingVC: UIViewController {
    
    var viewModel: MessagingViewModel?
    var username = ""
    
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textBottomConstraint: NSLayoutConstraint!

    var socket: WebSocket!
//    var isConnected = false
    
    var messageArray: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MessagingViewModel.init()
        viewModel?.view = self
        viewModel?.setUpView()
        viewModel?.setUpSocket()
    }
    
    deinit {
        viewModel?.deinitView()
    }
    
    //MARK: Text field animated moves
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.vcWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.vcWillDisappear()
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        viewModel?.vcKeyboardWillShow(notification)
    }
    
    @objc func tableViewTapped(){
        viewModel?.messageEndEditing()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel?.messageDidEndEditing()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        viewModel?.messageDidBeginEditing()
    }
    
    //MARK: Sending messages
    
    @IBAction func sendPressed(_ sender: UIButton) {
        viewModel?.sendAction()
    }
}


