//
//  TelephoneViewController.swift
//  kevROCK
//
//  Created by Aleksei Kevra on 19.05.2022.
//

import UIKit
import FirebaseAuth
import FlagPhoneNumber


class TelephoneViewController: UIViewController, UITextFieldDelegate {
    
    var phoneNumber: String?
    var listController: FPNCountryListViewController!
    
    // - UI
    @IBOutlet weak var getTheCodeOutlet: UIButton!
    @IBOutlet weak var phoneNumberTextField: FPNTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // - Action
    @IBAction func getTheCodeButtonAction(_ sender: Any) {
        guard phoneNumber == phoneNumber else { return }
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber!, uiDelegate: nil) { verificationID, error in
            
            if error != nil {
                print(error?.localizedDescription ?? "is empry")
            } else {
                self.showCodeValid(verificationID: verificationID!)
            }
        }
    }
    
}

extension TelephoneViewController: FPNTextFieldDelegate {
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        if isValid {
            getTheCodeOutlet.alpha = 1
            getTheCodeOutlet.isEnabled = true
            phoneNumber = textField.getFormattedPhoneNumber(format: .International)
        } else {
            getTheCodeOutlet.alpha = 0.5
            getTheCodeOutlet.isEnabled = false
        }
    }
    
    func fpnDisplayCountryList() {
        let navigationController = UINavigationController(rootViewController: listController)
        listController.title = "Choose your country"
        phoneNumberTextField.text = ""
        self.present(navigationController, animated: true)
    }
        
}

// MARK: - Configure
private extension TelephoneViewController {
    
    func configure() {
        getTheCodeOutlet.alpha = 0.5
        getTheCodeOutlet.isEnabled = false
        
        phoneNumberTextField.displayMode = .list
        phoneNumberTextField.delegate = self

        listController = FPNCountryListViewController(style: .grouped)
        listController?.setup(repository: phoneNumberTextField.countryRepository)
        listController.didSelect = { country in
            self.phoneNumberTextField.setFlag(countryCode: country.code)
        }
        
    }
    
    func showCodeValid(verificationID: String) {
        let storyboard = UIStoryboard(name: "CodeValid", bundle: nil)
        let dvc = storyboard.instantiateViewController(withIdentifier: "CodeValidViewController") as! CodeValidViewController
        dvc.verificationID = verificationID
        self.present(dvc, animated: true, completion: nil)
    }
}
