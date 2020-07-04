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
        
        socket = WebSocket(request: URLRequest(url: URL(string: "ws://pm.tada.team/ws?name=" + "\(username)")!))
        socket.delegate = self
        socket.connect()
        
        // Обрабатываем тап по таблице, чтобы вернуть вниз поле для ввода текста
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        
        // По умолчанию кнопка для отправки сообщения серая
        sendButton.isEnabled = false
        

    }
    
    deinit {
      socket.disconnect()
      socket.delegate = nil
    }
    
    //MARK: Анимация текстфилда
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name:  UIResponder.keyboardWillShowNotification, object: nil )
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
            self.sendButton.isEnabled = false
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.sendButton.isEnabled = true
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: Отправка сообщений
    
    func sendAction(){
        messageTextfield.endEditing(false)
        sendMessage(messageTextfield.text!)
        messageTextfield.text = ""
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        sendAction()
    }
    
//    // создаем словарь и преобразовываем его в строку для отправки
    func sendMessage(_ message: String) {
        let dictToSend = ["text": "\(message)"]
        let encoder = JSONEncoder()
        guard let jsonData = try? encoder.encode(dictToSend),
            let jsonString = String(data: jsonData, encoding: .utf8) else {
                return
        }
        socket.write(string: jsonString)
    }
    
    //MARK: Получение сообщений
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
}


