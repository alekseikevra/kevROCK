//
//  AuthViewController.swift
//  kevROCK
//
//  Created by Aleksei Kevra on 11.05.2022.
//

import UIKit
import FirebaseAuth
import Firebase

class AuthViewController: UIViewController {
    
    // - Constraint
    @IBOutlet weak var logoConstraintY: NSLayoutConstraint!
    @IBOutlet weak var logoWidth: NSLayoutConstraint!
    @IBOutlet weak var logoHeight: NSLayoutConstraint!
    
    // - UI
    @IBOutlet weak var joinKevrockLabel: UILabel!
    @IBOutlet weak var loginTextField: UITextField!     // EMAIL!!!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButtonOutlet: UIButton!
    @IBOutlet weak var dontHaveAccountLabel: UILabel!
    @IBOutlet weak var signUpButtonOutlet: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signUpWithStack: UIStackView!
    @IBOutlet weak var phoneImage: UIImageView!
    @IBOutlet weak var googleImage: UIImageView!
    @IBOutlet weak var facebookImage: UIImageView!
    @IBOutlet weak var appleImage: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        tabBarPresent()
        
        func tabBarPresent() {
            DispatchQueue.main.async {
                if Auth.auth().currentUser?.uid != nil {
                    let tabBarVC = TabBarViewController()
                    tabBarVC.modalPresentationStyle = .overFullScreen
                    self.present(tabBarVC, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        print("all is good")
        
    }
    
    // - Action
    @IBAction func closeSegue(_ sender: UIStoryboardSegue) {
        
    }
    
    @IBAction func signInButtonAction(_ sender: Any) {
        authAndSignIn()
    }
    
    @IBAction func signUpButtonAction(_ sender: Any) {
        showSignUpStoryboard()
    }
    
    @objc func telephoneAction(_ gesture: UITapGestureRecognizer) {
        showTelephoneStoryboard()
    }
    
    @objc func googleAction(_ gesture: UITapGestureRecognizer) {
        showAlert()
    }
    
    @objc func facebookAction(_ gesture: UITapGestureRecognizer) {
        showAlert()
    }
    
    @objc func appleAction(_ gesture: UITapGestureRecognizer) {
        showAlert()
    }
    
    // - Animate
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureAnimation()
    }
}

// MARK: - Configure
private extension AuthViewController {
    
    func configure() {
        configureAlpha()
        configureTextFieldDelegate()
        configureTapAnotherSignUp()
    }
    
    func configureAnimation() {
        UIView.animateKeyframes(withDuration: 1.3, delay: 1, options: .calculationModeCubic, animations: {
            self.logoConstraintY.constant = 0
            self.logoWidth.constant = 374/1.5
            self.logoHeight.constant = 268/1.5
            UIView.animate(withDuration: 1.3) { [weak self] in
                self?.view.layoutIfNeeded()
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.3) {
                self.signInButtonOutlet.alpha = 1
                self.passwordTextField.alpha = 1
                self.loginTextField.alpha = 1
                self.dontHaveAccountLabel.alpha = 1
                self.signUpButtonOutlet.alpha = 1
                self.signUpWithStack.alpha = 1
                self.joinKevrockLabel.alpha = 1
                
            }
            
        }, completion: nil)
    }

    func configureAlpha() {
        loginTextField.alpha = 0
        passwordTextField.alpha = 0
        signInButtonOutlet.alpha = 0
        dontHaveAccountLabel.alpha = 0
        signUpButtonOutlet.alpha = 0
        errorLabel.alpha = 0
        signUpWithStack.alpha = 0
        joinKevrockLabel.alpha = 0
    }
    
    func configureTextFieldDelegate() {
        loginTextField.delegate = self
        passwordTextField.delegate = self
    }
    
}

// MARK: - Tap Gesture
private extension AuthViewController {
    
    func configureTapAnotherSignUp() {
        let teleGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(telephoneAction(_:)))
        teleGestureRecognizer.numberOfTapsRequired = 1
        teleGestureRecognizer.numberOfTouchesRequired = 1
        phoneImage.addGestureRecognizer(teleGestureRecognizer)
        phoneImage.isUserInteractionEnabled = true
        
        let googleGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(googleAction(_:)))
        googleGestureRecognizer.numberOfTapsRequired = 1
        googleGestureRecognizer.numberOfTouchesRequired = 1
        googleImage.addGestureRecognizer(googleGestureRecognizer)
        googleImage.isUserInteractionEnabled = true
        
        let facebookGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(facebookAction(_:)))
        facebookGestureRecognizer.numberOfTapsRequired = 1
        facebookGestureRecognizer.numberOfTouchesRequired = 1
        facebookImage.addGestureRecognizer(facebookGestureRecognizer)
        facebookImage.isUserInteractionEnabled = true
        
        let appleGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(appleAction(_:)))
        appleGestureRecognizer.numberOfTapsRequired = 1
        appleGestureRecognizer.numberOfTouchesRequired = 1
        appleImage.addGestureRecognizer(appleGestureRecognizer)
        appleImage.isUserInteractionEnabled = true
    }
    
}

// MARK: - Show Auth Logic
private extension AuthViewController {
    
    func authAndSignIn() {
        Auth.auth().signIn(withEmail: loginTextField.text ?? "login empty", password: passwordTextField.text ?? "password empty") { result, error in
            if error != nil {
                self.errorLabel.alpha = 1
                self.errorLabel.text = "Wrong email or password. Try again"
            } else {
                self.showMainStoryboard()
            }
        }
        
    }
    
}

// MARK: - UITextFieldDelegate
extension AuthViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            authAndSignIn()
        }
        return true
    }
    
}

// MARK: - Show Storyboards
private extension AuthViewController {

    func showMainStoryboard() {
        let tabBarVC = TabBarViewController()
        tabBarVC.modalPresentationStyle = .overFullScreen
        present(tabBarVC, animated: true, completion: nil)
    }

    func showSignUpStoryboard() {
        let signUpVC = UIStoryboard(name: "SignUpStoryboard", bundle: nil).instantiateInitialViewController() as! SignUpViewController
        navigationController?.pushViewController(signUpVC, animated: true)
    }

    func showTelephoneStoryboard() {
        let telephoneVC = UIStoryboard(name: "TelephoneStoryboard", bundle: nil).instantiateInitialViewController() as! TelephoneViewController
        navigationController?.pushViewController(telephoneVC, animated: true)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Feature is currently unavailable", message: "We try to be better for you. Just relax", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
}
