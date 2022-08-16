//
//  CodeValidViewController.swift
//  kevROCK
//
//  Created by Aleksei Kevra on 19.05.2022.
//

import UIKit
import FirebaseAuth

class CodeValidViewController: UIViewController {

    var verificationID: String!
    
    // - UI
    @IBOutlet weak var confirmButtonOutlet: UIButton!
    @IBOutlet weak var codeTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    @IBAction func confirmButtonAction(_ sender: Any) {
        guard let code = codeTextView.text else { return }
        
        let credetional = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
        
        Auth.auth().signIn(with: credetional) { _, error in
            if error != nil {
                let ac = UIAlertController(title: "ERROR", message: "Wrong code", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .cancel)
                ac.addAction(ok)
                self.present(ac, animated: true)
            } else {
                self.showMainStoryboard()
            }
        }
                
    }
    
}

// MARK: - Configure
private extension CodeValidViewController {
    
    func configure() {
        confirmButtonOutlet.alpha = 0.5
        confirmButtonOutlet.isEnabled = false
        codeTextView.delegate = self
    }

    func showMainStoryboard() {
        let tabBarVC = TabBarViewController()
        tabBarVC.modalPresentationStyle = .overFullScreen
        self.present(tabBarVC, animated: true, completion: nil)
    }
    
}

extension CodeValidViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentCharterCount = textView.text?.count ?? 0
        if range.length + range.location > currentCharterCount {
            return false
        }
        let newLength = currentCharterCount + text.count - range.length
        return newLength <= 6
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text?.count == 6 {
            confirmButtonOutlet.alpha = 1
            confirmButtonOutlet.isEnabled = true
        } else {
            confirmButtonOutlet.alpha = 0.5
            confirmButtonOutlet.isEnabled = false
        }
    }
    
}
