//
//  MessageModel.swift
//  Messaging app (WebSocket)
//
//  Created by Олег Еременко on 02.07.2020.
//  Copyright © 2020 Oleg Eremenko. All rights reserved.
//

import Foundation

class Message {
    var name: String
    var text: String
    
    init(name: String, text: String){
        self.name = name
        self.text = text
    }
}
/*
 {"created":"2020-07-03T10:05:17.275966489Z","name":"sUser","text":"some text"}
 */
