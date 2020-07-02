//
//  WebSocket_Delegate.swift
//  Messaging app (WebSocket)
//
//  Created by Олег Еременко on 02.07.2020.
//  Copyright © 2020 Oleg Eremenko. All rights reserved.
//

import UIKit
import SwiftyJSON
import Starscream

extension MessagingVC: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            socket.disconnect()
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):

            if let data = string.data(using: .utf8) {
                if let json = try? JSON(data: data) {
                    let resultName = json["name"].stringValue
                    print(resultName)
                    let resultText = json["text"].stringValue
                    print(resultText)
                    let testMessage = Message(name: resultName, text: resultText)
                    messageArray.append(testMessage)
                }
            }
            print(messageArray.count)
            messageTableView.reloadData()
            
//            print("Recieved text: \(string)")
            
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
            isConnected = false
            print("Disconnected manually")
        case .error(let error):
            isConnected = false
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
