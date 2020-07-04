//
//  UITableView.swift
//  Messaging app (WebSocket)
//
//  Created by Олег Еременко on 04.07.2020.
//  Copyright © 2020 Oleg Eremenko. All rights reserved.
//

import UIKit

extension UITableView {
    
    // Автоматический скроллинг вниз к последней ячейке
    func scrollToBottom(animated: Bool = true, delay: Double = 0.0) {
        let numberOfRows = self.numberOfRows(inSection: self.numberOfSections - 1) - 1
        guard numberOfRows > 0 else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [unowned self] in
            let indexPath = IndexPath(row: numberOfRows, section: self.numberOfSections - 1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}
