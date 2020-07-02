//
//  ViewController1.swift
//  Messaging app (WebSocket)
//
//  Created by Олег Еременко on 02.07.2020.
//  Copyright © 2020 Oleg Eremenko. All rights reserved.
//

import UIKit

class ViewController1: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var username = ""
    
    var messageArray: [Message] = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        messageTextfield.delegate = self
 
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 510
            self.view.layoutIfNeeded()
        }
    }
    
    //TODO: Declare textFieldDidEndEditing here:
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func tableViewTapped(){
        messageTextfield.endEditing(true)
    }
    
}

extension ViewController1: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1") as! TableViewCell
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
//        if let item = viewModel?.items?[indexPath.row] {
//            cell.itemNameLabel.text = item.itemName
//            cell.itemDaysLabel.text = viewModel?.dateToTextDays(item: item)
//        } else {
//            cell.itemNameLabel.text = "Nothing added yet"
//        }
        return cell
    }
}

extension ViewController1: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
