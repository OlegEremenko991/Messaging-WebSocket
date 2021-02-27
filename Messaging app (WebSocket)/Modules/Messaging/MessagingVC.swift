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

    // MARK: - IBOutlets

    @IBOutlet private weak var messageTableView: UITableView! {
        didSet { messageTableView.separatorStyle = .none }
    }

    @IBOutlet private weak var messageTextfield: UITextField!
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var textBottomConstraint: NSLayoutConstraint!

    // MARK: - Public properties
    
    var socket: WebSocket!
    var messageArray: [Message] = []
    var displayedName = ""
    var username = ""
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification: )), name:  UIResponder.keyboardWillShowNotification, object: nil )
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    deinit {
        socket.disconnect()
        socket.delegate = nil
    }
    
    // MARK: - Private methods

    private func setupView() {

        // "Send" button is not enableds by default
        sendButton.isEnabled = false
        
        // Processing tap on the table view to bring down text field and keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
    
        setupSocket()
    }
    
    private func setupSocket() {
        socket = WebSocket(request: URLRequest(url: URL(string: "ws://pm.tada.team/ws?name=" + "\(username)")!))
        socket.delegate = self
        socket.connect()
    }
    
    /// Creates a dictionary and transform it to a JSON-string for further sending
    private func sendMessage(_ message: String) {
        guard message != "" else { return }
        let dictToSend = ["text": "\(message)"]
        guard let jsonData = try? JSONEncoder().encode(dictToSend),
              let jsonString = String(data: jsonData, encoding: .utf8) else { return }
        socket.write(string: jsonString)
    }
    
    /// Sends messages
    private func sendAction() {
        messageTextfield.endEditing(false)
        sendMessage(messageTextfield.text!)
        messageTextfield.text = ""
    }
    
    /// Recieve a message and append it to messageArray
    private func messageRecieved(jsonMessage: String){
        guard let data = jsonMessage.data(using: .utf8),
              let json = try? JSON(data: data) else { return }
        let resultName = json["name"].stringValue
        let resultText = json["text"].stringValue
        let message = Message(name: resultName, text: resultText)
        messageArray.append(message)

        messageTableView.reloadData()
        messageTableView.scrollToBottom()
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            /// Keyboard height
            let newHeight: CGFloat = keyboardFrame.cgRectValue.height - view.safeAreaInsets.bottom

            view.layoutIfNeeded()
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseInOut, animations: {
                self.textBottomConstraint.constant = newHeight
                self.view.layoutIfNeeded()
            })
        }

    }
    
    /// Brings text field down
    @objc private func tableViewTapped(){
        messageTextfield.endEditing(true)
    }
    
    // MARK: - IBActions
    
    @IBAction func sendPressed(_ sender: UIButton) {
        sendAction()
    }
    
}

// MARK: - UITableViewDataSource

extension MessagingVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messageArray.count > 0 ? messageArray.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1") as! MessageCell
        if messageArray.isEmpty {
            cell.setupCell(userName: "", message: "No messages to show", displayedName: displayedName)
        } else {
            let item = messageArray[indexPath.row]
            cell.setupCell(userName: item.name, message: item.text, displayedName: displayedName)
        }

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

    // Bring text field down if user ended typing (tap on table view, for example)
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.textBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
            self.sendButton.isEnabled = false
        }
    }

    // Sending message on "Enter" button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendAction()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let stringToCheck = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        sendButton.isEnabled = stringToCheck != ""
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
            print("websocket encountered a WSError: \(e.message)")
        } else if let e = error {
            print("websocket encountered an error: \(e.localizedDescription)")
        } else {
            print("websocket encountered an unknown error")
        }
    }
}
