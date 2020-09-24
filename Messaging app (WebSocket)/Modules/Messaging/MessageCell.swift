//
//  TableViewCell.swift
//  Messaging app (WebSocket)
//
//  Created by Олег Еременко on 02.07.2020.
//  Copyright © 2020 Oleg Eremenko. All rights reserved.
//

import UIKit

final class MessageCell: UITableViewCell {

// MARK: IBOutlets

    @IBOutlet weak var senderUsername: UILabel!
    @IBOutlet weak var messageBody: UILabel!
    
// MARK: Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
