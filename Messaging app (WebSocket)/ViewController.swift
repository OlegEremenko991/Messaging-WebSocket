//
//  ViewController.swift
//  Messaging app (WebSocket)
//
//  Created by Олег Еременко on 02.07.2020.
//  Copyright © 2020 Oleg Eremenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var username = ""
        
    @IBOutlet weak var nextBarButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        nextBarButton.isEnabled = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "loginEntered",
        let vc = segue.destination as? ViewController1 else {
            return
        }
        vc.username = username
    }

    @IBAction func loginChanged(_ sender: UITextField) {
        if let _ = sender.text!.rangeOfCharacter(from: NSCharacterSet.letters){
            nextBarButton.isEnabled = true
        } else {
            nextBarButton.isEnabled = false
        }
    }
}
