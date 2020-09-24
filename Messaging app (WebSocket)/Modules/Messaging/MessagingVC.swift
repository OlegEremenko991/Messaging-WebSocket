//
//  ViewController1.swift
//  Messaging app (WebSocket)
//
//  Created by Олег Еременко on 02.07.2020.
//  Copyright © 2020 Oleg Eremenko. All rights reserved.

import UIKit
import Starscream
import SwiftyJSON

final class MessagingVC: UIViewController {

// MARK: IBOutlets

    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textBottomConstraint: NSLayoutConstraint!

// MARK: Public properties
    
    var socket: WebSocket!
    var messageArray: [Message] = []
    var displayedName = ""
    var username = ""
    
// MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    deinit {
        socket.disconnect()
        socket.delegate = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification: )), name:  UIResponder.keyboardWillShowNotification, object: nil )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    
// MARK: Private methods

    private func setupView() {
        
        sendButton.isEnabled = false // "Send" button is grey by default
        
        // Processing tap on the table view to bring down text field and keyboard
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
    
        setupSocket()
    }
    
    private func setupSocket() {
        socket = WebSocket(request: URLRequest(url: URL(string: "ws://pm.tada.team/ws?name=" + "\(username)")!))
        socket.delegate = self
        socket.connect()
    }
    
    // Main method for sending messages. Create a dictionary and transform it to a JSON-string for further sending
    private func sendMessage(_ message: String) {
        let dictToSend = ["text": "\(message)"]
        let encoder = JSONEncoder()
        guard let jsonData = try? encoder.encode(dictToSend),
            let jsonString = String(data: jsonData, encoding: .utf8) else {
                return
        }
        socket.write(string: jsonString)
    }
    
    // Perform sending messages
    private func sendAction() {
        messageTextfield.endEditing(false)
        sendMessage(messageTextfield.text!)
        messageTextfield.text = ""
    }
    
    // Recieving messages
    private func messageRecieved(jsonMessage: String){
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
    
// MARK: Public methods
    
    // Text field animated moves
        
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
    
    // Processing tap on the table view to bring text field down
    @objc func tableViewTapped(){
        messageTextfield.endEditing(true)
    }
    
    // Bring text field down if user ended typing (tap on table view, for example)
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.textBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
            self.sendButton.isEnabled = false
        }
    }
    
    // Bring text field up if user tapped on it
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.sendButton.isEnabled = true
            self.view.layoutIfNeeded()
        }
    }
    
// MARK: IBActions
    
    @IBAction func sendPressed(_ sender: UIButton) {
        sendAction()
    }
    
}

// MARK: UITableViewDataSource

extension MessagingVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1") as! MessageCell
        
        cell.messageBody?.text = messageArray[indexPath.row].text
        cell.senderUsername?.text = messageArray[indexPath.row].name
        
        // Setup "system message" if name is nil
        if cell.senderUsername.text!.isEmpty {
            cell.senderUsername.text = "System message"
            cell.senderUsername.textColor = .gray
        }
        
        // Setup name color
        if cell.senderUsername.text == displayedName {
            cell.senderUsername.textColor = .blue
        } else if cell.senderUsername.text != "System message" {
            cell.senderUsername.textColor = .red
        }
        
        // Scroll to the lowest cell
        tableView.scrollToBottom()
        
        return cell
    }
}

// MARK: UITableViewDelegate

extension MessagingVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: UITextFieldDelegate

extension MessagingVC: UITextFieldDelegate {
    
    // Sending message on "Enter" button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendAction()
        return true
    }
}

// MARK: WebSocketDelegate

extension MessagingVC: WebSocketDelegate {
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            socket.disconnect()
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            messageRecieved(jsonMessage: string)
            print(string)
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            print("Disconnected manually")
        case .error(let error):
            handleError(error)
        }
    }
    
    func handleError(_ error: Error?) {
        if let e = error as? WSError {
            print("websocket encountered an error: \(e.message)")
        } else if let e = error {
            print("websocket encountered an error: \(e.localizedDescription)")
        } else {
            print("websocket encountered an error")
        }
    }
}
