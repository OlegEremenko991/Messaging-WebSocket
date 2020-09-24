//
//  MessagingViewModel.swift
//  Messaging app (WebSocket)
//
//  Created by Олег Еременко on 05.07.2020.
//  Copyright © 2020 Oleg Eremenko. All rights reserved.
//

import UIKit
import Starscream
import SwiftyJSON

final class MessagingViewModel {
    
// MARK: Public properties

    weak var view: MessagingVC?
    
//MARK: Public methods
    
    // Setting up view
    func setUpView(){
        view?.sendButton.isEnabled = false // "Send" button is grey by default
        
        // Processing tap on the table view to bring down text field and keyboard
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view?.tableViewTapped))
        view?.messageTableView.addGestureRecognizer(tapGesture)
    }
    
    func setUpSocket(){
        view?.socket = WebSocket(request: URLRequest(url: URL(string: "ws://pm.tada.team/ws?name=" + "\(view!.username)")!))
        view?.socket.delegate = view
        view?.socket.connect()
    }
    
    func deinitView(){
        view?.socket.disconnect()
        view?.socket.delegate = nil
    }
    
    // Text field animated moves, keyboard methods
    
    func vcWillAppear(){
        NotificationCenter.default.addObserver(view!, selector: #selector(view?.keyboardWillShow(notification:)), name:  UIResponder.keyboardWillShowNotification, object: nil )
    }
    
    func vcWillDisappear(){
        NotificationCenter.default.removeObserver(view!, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func vcKeyboardWillShow(_ notification: Notification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            var newHeight: CGFloat
            let duration:TimeInterval = (notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if #available(iOS 11.0, *) {
                newHeight = keyboardFrame.cgRectValue.height - (self.view?.view.safeAreaInsets.bottom)!
            } else {
                newHeight = keyboardFrame.cgRectValue.height
            }
            let keyboardHeight = newHeight
            UIView.animate(withDuration: duration, delay: TimeInterval(0), options: animationCurve, animations: {
                self.view?.textBottomConstraint.constant = keyboardHeight
                self.view?.view.layoutIfNeeded()
            })
        }
    }
    
    // Text field methods and sending messages
    
    // Processing tap on the table view to bring text field down
    func messageEndEditing(){
        view?.messageTextfield.endEditing(true)
    }
    
    // Bring text field up if user tapped on it
    func messageDidBeginEditing(){
        UIView.animate(withDuration: 0.5) {
            self.view?.sendButton.isEnabled = true
            self.view?.view.layoutIfNeeded()
        }
    }
    
    // Bring text field down if user ended typing (tap on table view, for example)
    func messageDidEndEditing(){
        UIView.animate(withDuration: 0.5) {
            self.view?.textBottomConstraint.constant = 0
            self.view?.view.layoutIfNeeded()
            self.view?.sendButton.isEnabled = false
        }
    }
    
    // Main method to send message. Create a dictionary and transform it to a JSON-string for further sending
    func sendMessage(_ message: String){
        let dictToSend = ["text": "\(message)"]
        let encoder = JSONEncoder()
        guard let jsonData = try? encoder.encode(dictToSend),
            let jsonString = String(data: jsonData, encoding: .utf8) else {
                return
        }
        view?.socket.write(string: jsonString)
    }
    
    // Here we perform sending messages
    func sendAction(){
        view?.messageTextfield.endEditing(false)
        sendMessage((view?.messageTextfield.text!)!)
        view?.messageTextfield.text = ""
    }

    // Recieving messages
    
    func messageRecieved(jsonMessage: String){
        guard let data = jsonMessage.data(using: .utf8),
            let json = try? JSON(data: data) else {
                return
        }
        let resultName = json["name"].stringValue
        let resultText = json["text"].stringValue
        let testMessage = Message(name: resultName, text: resultText)
        view?.messageArray.append(testMessage)
        view?.messageTableView.reloadData()
    }
}
