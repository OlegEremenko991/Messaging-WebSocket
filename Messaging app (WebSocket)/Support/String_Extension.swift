//
//  String_Extension.swift
//  Messaging app (WebSocket)
//
//  Created by Олег Еременко on 24.09.2020.
//  Copyright © 2020 Oleg Eremenko. All rights reserved.
//

extension String {
    
    // replace symbols
    
    func withReplacedCharacters(_ oldChar: String, by newChar: String) -> String {
        let newStr = self.replacingOccurrences(of: oldChar, with: newChar, options: .literal, range: nil)
        return newStr
    }
}
