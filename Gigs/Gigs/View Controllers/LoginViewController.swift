//
//  LoginViewController.swift
//  Gigs
//
//  Created by Alexander Supe on 1/15/20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var button: UIButton!
    
    // MARK: - Attributes
    var gigController: GigController?
    var login = false
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        format()
    }
    
    // MARK: - Base Functions
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 { login = false; button.setTitle("Sign Up", for: .normal); self.title = "Sign Up" }
        else { login = true; button.setTitle("Sign In", for: .normal); self.title = "Sign In" }
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        if let username = username.text,
            !username.isEmpty,
            let password = password.text,
            !password.isEmpty {
            let user = User(username: username, password: password)
            
            if login { signIn(user: user) }
            else { signUp(user: user) }
        }
    }
    
    // MARK: - Sign Up / Sign In
    func signUp(user: User) {
        guard let gigController = gigController else { return }
        gigController.authController.signUp(with: user) { error in
            if let error = error { print("Error occured during sign up: \(error)") }
            else {
                self.createAlert(title: "Sign Up Successful", message: "Now please log in.") {
                    self.login = true
                    self.segment.selectedSegmentIndex = 1
                    self.button.setTitle("Sign In", for: .normal)
                }
            }
        }
    }
    
    func signIn(user: User) {
        guard let gigController = gigController else { return }
        gigController.authController.signIn(with: user) { error in
            if let error = error { print("Error occurred during sign in: \(error)") }
            else { DispatchQueue.main.async { self.dismiss(animated: true, completion: nil) } }
        }
    }
    
    // MARK: - Helper Functions
    func createAlert(title: String, message: String, action: @escaping () -> ()) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: action)
        }
    }
    
    // MARK: - Formatting
    func format() {
        button.layer.cornerRadius = 10
        username.layer.cornerRadius = 7.5
        username.setLeftPaddingPoints(10)
        password.layer.cornerRadius = 7.5
        password.setLeftPaddingPoints(10)
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
