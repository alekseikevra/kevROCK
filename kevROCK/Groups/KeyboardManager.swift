//
//  KeyboardManager.swift
//  HealthApp
//
//  Created by Denis Anatsky on 28.04.22.
//

import UIKit

protocol KeyboardManagerProtocol: AnyObject {
    func keyboardWillShow(height: CGFloat, duration: Double, curve: UInt)
    func keyboardWillHide(duration: Double, curve: UInt)
}

extension KeyboardManagerProtocol {
    func keyboardWillShow(height: CGFloat, duration: Double, curve: UInt) {}
    func keyboardWillHide(duration: Double, curve: UInt) {}
}

final class KeyboardManager {
    // - Shared
    static let shared = KeyboardManager()
    
    weak var delegate: KeyboardManagerProtocol?
    
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if
            let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration: Double = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curve: UInt = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            delegate?.keyboardWillShow(height: keyboardHeight, duration: duration, curve: curve)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        if
            let duration: Double = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curve: UInt = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        {
            delegate?.keyboardWillHide(duration: duration, curve: curve)
        }
    }
}
