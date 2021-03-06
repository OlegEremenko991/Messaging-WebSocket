//
//  ViewController.swift
//  Messaging app (WebSocket)
//
//  Created by Олег Еременко on 02.07.2020.
//  Copyright © 2020 Oleg Eremenko. All rights reserved.
//

import UIKit

final class LoginVC: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var loginTextField: UITextField! {
        didSet { loginTextField.keyboardType = .asciiCapable }
    }

    @IBOutlet private weak var nextBarButton: UIBarButtonItem!
    
    // MARK: - Public properties

    var viewModel: LoginViewModel?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let messagingVC = segue.destination as? MessagingVC,
           let userName = viewModel?.userName(),
           let displayedName = viewModel?.displayedName() {
            messagingVC.username = userName
            messagingVC.displayedName = displayedName
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetSession()
    }
    
    // MARK: - Private methods

    private func setupView() {
        setupViewModel()
        changeButtonState(enabled: false)
    }

    private func setupViewModel() {
        viewModel = LoginViewModel.init()
        viewModel?.view = self
    }

    private func resetSession() {
        loginTextField.text = ""
        changeButtonState(enabled: false)
    }

    // MARK: - Public methods

    func changeButtonState(enabled: Bool) { nextBarButton.isEnabled = enabled }

    // MARK: - IBActions

    @IBAction func loginChanged(_ sender: UITextField) { viewModel?.checkLogin(sender) }

}

// MARK: - UITextFieldDelegate

extension LoginVC: UITextFieldDelegate {
    
    // Check text field and replace invalid characters
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 20
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9 ].*", options: [])
            if regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) != nil { return false }
           
            // remove excess characters
            if range.location > maxLength - 1 { textField.text?.removeLast() }
        } catch {
            print("ERROR")
        }
        return true
    }
    
    // Go to the second screen on "Enter" button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text!.isEmpty { return false }
        performSegue(withIdentifier: "loginEntered", sender: self)
        return true
    }
}
