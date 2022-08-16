//
//  SignUpViewController.swift
//  kevROCK
//
//  Created by Aleksei Kevra on 12.05.2022.
//

import UIKit
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth
import Firebase


class SignUpViewController: UIViewController {
    
    // - UI
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signUpButtonOutlet: UIButton!
    
    // - Constraint
    @IBOutlet weak var signUpBottom: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        KeyboardManager.shared.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    @IBAction func signUpButtonAction(_ sender: Any) {
        createNewUser()
    }
    
    @IBAction func Back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - Keyboard logic
extension SignUpViewController: KeyboardManagerProtocol {
    func keyboardWillShow(height: CGFloat, duration: Double, curve: UInt) {
        let bottom = Constants.bottomInset + view.safeAreaInsets.bottom
        guard height > bottom + 10 else {
            return
        }
        signUpBottom.constant = height - view.safeAreaInsets.bottom + 10
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve)) {
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(duration: Double, curve: UInt) {
        signUpBottom.constant = Constants.bottomInset
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve)) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField {
            lastnameTextField.becomeFirstResponder()
        } else if textField == lastnameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
}

// MARK: - Configure
extension SignUpViewController {
    
    func configure() {
        textFieldDelegate()
        errorLabel.alpha = 0
    }
    
    func textFieldDelegate() {
        firstNameTextField.delegate = self
        lastnameTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.delegate = self
    }

    
    func checkValid() -> String? {
        
        if firstNameTextField.text == "" ||
            emailTextField.text == "" ||
            lastnameTextField.text == "" ||
            passwordTextField.text == "" ||
            firstNameTextField.text == nil ||
            lastnameTextField.text == nil ||
            emailTextField.text == nil ||
            passwordTextField.text == nil {
            return "Please fill in all fields"
        }
        
        return nil
        
    }
    
    func createNewUser() {
        let error = checkValid()
        
        if error != nil {
            errorLabel.alpha = 1
            errorLabel.text = error
        } else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { result, error in
                if error != nil {
                    self.errorLabel.text = error?.localizedDescription ?? "error localized"
                } else {
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: [
                        "firstname": self.firstNameTextField.text!,
                        "email": self.emailTextField.text!,
                        "uid": result!.user.uid
                    ]) { error in
                        if error != nil {
                            self.errorLabel.text = "ok" 
                        }
                        print(result!.user.uid)
                    }
                    self.errorLabel.alpha = 1
                    self.errorLabel.text = "User has succsessfulled registr \(result?.user.email ?? "error")" 
                }
            }
        }
    }
    
    enum Constants {
        static let bottomInset: CGFloat = 168
    }
    
}
