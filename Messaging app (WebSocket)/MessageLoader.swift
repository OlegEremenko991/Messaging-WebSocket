//
//  MessageLoader.swift
//  Messaging app (WebSocket)
//
//  Created by Олег Еременко on 02.07.2020.
//  Copyright © 2020 Oleg Eremenko. All rights reserved.
//

import Foundation

class MessageLoader {
    
//    func loadMessages(_ completion: @escaping ([Message]) -> Void){
//        let url = URL(string: "ws://pm.tada.team/ws?name=test123")!
//        let request = URLRequest(url: url)
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if let data = data,
//                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
//                let jsonDict = json as? NSDictionary {
//                var messages: [Message] = []
//                for (_, data) in jsonDict where data is NSDictionary {
//                    if let message = Message(data: data as! NSDictionary) {
//                        messages.append(message)
//                    }
//                }
//                DispatchQueue.main.async {
//                    completion(messages)
//                }
//            }
//        }
//        task.resume()
//    }
}
