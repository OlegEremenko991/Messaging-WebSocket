//
//  ViewController1.swift
//  Messaging app (WebSocket)
//
//  Created by Олег Еременко on 02.07.2020.
//  Copyright © 2020 Oleg Eremenko. All rights reserved.
// TARGET: ws://pm.tada.team/ws?name=test123

import UIKit
import Starscream
import SwiftyJSON

class MessagingVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var connectionButton: UIBarButtonItem!
    
    var username = ""

    var socket: WebSocket!
    var isConnected = false
    
    var messageArray: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        socket = WebSocket(request: URLRequest(url: URL(string: "ws://pm.tada.team/ws?name=" + "\(username)")!))
        socket.delegate = self
        socket.connect()
        
        // Обрабатываем тап по таблице, чтобы вернуть вниз поле для ввода текста
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
    }
    
    // Возвращаем вниз поле для ввода текста
    @objc func tableViewTapped(){
        messageTextfield.endEditing(true)
    }
    
    // Поднимаем над клавиатурой поле для ввода текста
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 295
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        messageTextfield.endEditing(false)
        socket.write(string: messageTextfield.text!)
        messageTextfield.text = ""
    }
    
    @IBAction func connectionPressed(_ sender: UIBarButtonItem) {
        if isConnected {
            sender.title = "Connect"
            socket.disconnect()
        } else {
            sender.title = "Disconnect"
            socket.connect()
        }
    }
    
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        UIView.animate(withDuration: 0.5) {
//            self.heightConstraint.constant = 50
//            self.view.layoutIfNeeded()
//        }
//    }
}


