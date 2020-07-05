//
//  MessagingVC_Datasource.swift
//  Messaging app (WebSocket)
//
//  Created by Олег Еременко on 02.07.2020.
//  Copyright © 2020 Oleg Eremenko. All rights reserved.
//

import UIKit

extension MessagingVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1") as! TableViewCell
        cell.messageBody?.text = messageArray[indexPath.row].text
        cell.senderUsername?.text = messageArray[indexPath.row].name
                
        if (cell.senderUsername.text!.isEmpty) {
            cell.senderUsername.text = "System message"
        }
        tableView.scrollToBottom() // scroll to the lowest cell
        return cell
    }
}
