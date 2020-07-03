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

class MessagingVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textBottomConstraint: NSLayoutConstraint!
    
    var username = ""

    var socket: WebSocket!
    var isConnected = false
    
    let server = WebSocketServer()
    
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
    deinit {
      socket.disconnect()
      socket.delegate = nil
    }
    
    //MARK: Анимация текстфилда вместе с движением клавиатуры
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillShow(notification:)), name:  UIResponder.keyboardWillShowNotification, object: nil )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            var newHeight: CGFloat
            let duration:TimeInterval = (notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if #available(iOS 11.0, *) {
                newHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
            } else {
                newHeight = keyboardFrame.cgRectValue.height
            }
            let keyboardHeight = newHeight
            UIView.animate(withDuration: duration, delay: TimeInterval(0), options: animationCurve, animations: {
                self.textBottomConstraint.constant = keyboardHeight
                self.view.layoutIfNeeded()
            })
        }
    }
    
    // Возвращаем вниз поле для ввода текста
    @objc func tableViewTapped(){
        messageTextfield.endEditing(true)
    }
    
    // Опускаем поле для ввода текста при окончании редактирования текста (тап в любое другое место)
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.textBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    // Отправляем сообщение: создаем словарь и преобразовываем его в строку для отправки
    fileprivate func sendMessage(_ message: String) {
        let dictToSend = ["text": "\(message)"]
        let encoder = JSONEncoder()
        guard let jsonData = try? encoder.encode(dictToSend),
            let jsonString = String(data: jsonData, encoding: .utf8) else {
                return
        }
        socket.write(string: jsonString)
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        messageTextfield.endEditing(false)
        sendMessage(messageTextfield.text!)
        messageTextfield.text = ""
    }
    
    func messageRecieved(jsonMessage: String){
        guard let data = jsonMessage.data(using: .utf8),
            let json = try? JSON(data: data) else {
                return
        }
        let resultName = json["name"].stringValue
        let resultText = json["text"].stringValue
        let testMessage = Message(name: resultName, text: resultText)
        messageArray.append(testMessage)
        messageTableView.reloadData()
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
}

