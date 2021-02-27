//
//  TableViewCell.swift
//  Messaging app (WebSocket)
//
//  Created by Олег Еременко on 02.07.2020.
//  Copyright © 2020 Oleg Eremenko. All rights reserved.
//

import UIKit

final class MessageCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet private(set) weak var senderUsername: UILabel!
    @IBOutlet private weak var messageBody: UILabel!

    // MARK: Private properties

    private let systemMessageText = "System message"
    
    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Public methods

    func setupCell(userName: String, message: String, displayedName: String) {
        messageBody.text = message
        if userName.isEmpty {
            // System is the message sender
            senderUsername.text = systemMessageText
            senderUsername.textColor = .gray
        } else {
            senderUsername.text = userName
        }

        if userName == displayedName {
            // Current app user is the message sender
            senderUsername.textColor = .blue
        } else if senderUsername.text != systemMessageText {
            // Bot is the message sender
            senderUsername.textColor = .red
        }
    }

}
