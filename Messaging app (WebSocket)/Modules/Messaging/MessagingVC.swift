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
    
    var viewModel: MessagingViewModel?
    var socket: WebSocket!
    var messageArray: [Message] = []
    var username = ""
    
// MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    deinit {
        viewModel?.deinitView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.vcWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.vcWillDisappear()
    }
    
    
// MARK: Private methods

    private func setupView() {
        viewModel = MessagingViewModel.init()
        viewModel?.view = self
        viewModel?.setUpView()
        viewModel?.setUpSocket()
    }
    
// MARK: Public methods
    
    // Text field animated moves
        
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
    
// MARK: IBActions
    
    @IBAction func sendPressed(_ sender: UIButton) {
        viewModel?.sendAction()
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
        
        if cell.senderUsername.text!.isEmpty {
            cell.senderUsername.text = "System message"
            cell.senderUsername.textColor = .gray
        }
        
        if cell.senderUsername.text! == username {
            cell.senderUsername.textColor = .blue
        } else if cell.senderUsername.text != "System message" {
            cell.senderUsername.textColor = .red
        }
        
        tableView.scrollToBottom() // scroll to the lowest cell
        
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
        viewModel?.sendAction()
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
            viewModel?.messageRecieved(jsonMessage: string)
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
