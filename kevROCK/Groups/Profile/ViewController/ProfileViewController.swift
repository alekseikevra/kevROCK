//
//  ProfileViewController.swift
//  kevROCK
//
//  Created by Aleksei Kevra on 24.05.2022.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseStorage
import FirebaseFirestore

class ProfileViewController: UIViewController {
    
    // - UI
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    // - Variables
    private let storageRef = Storage.storage().reference()
    private let databaseRef = Database.database().reference()
    private let uid = Auth.auth().currentUser?.uid
    private let nameProfile = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfile()
        download()
        showName()
    }
    
    @IBAction func uploadImageButtonAction(_ sender: Any) {
        pickerImage()
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        saveChanges()
    }
    
    @IBAction func logOutButtonAction(_ sender: Any) {
        logOut()
    }
    
}

// MARK: - Configure
extension ProfileViewController {
    
    func logOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let authVC = UIStoryboard(name: "AuthStoryboard", bundle: nil).instantiateInitialViewController() as! UINavigationController
            authVC.modalPresentationStyle = .overFullScreen
            self.present(authVC, animated: false, completion: nil)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func download() {
        let islandRef = storageRef.child("ProfileAvatars").child(uid ?? "fail nil")
        islandRef.getData(maxSize: 1 * 6024 * 6024) { data, error in
            if let error = error {
                print("Error download\(error.localizedDescription)")
            } else {
                guard let imageData = data else {
                    return }
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData)
                    self.profileImage.image = image
                    self.profileImage.layer.cornerRadius = self.profileImage.frame.width/2.0
                    self.profileImage.clipsToBounds = true
                }
            }
        }
    }
    
    func setupProfile() {
        if let uid = Auth.auth().currentUser?.uid{
            databaseRef.child("users1").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? [String: AnyObject]
                {
                    self.userNameLabel.text = dict["username"] as? String
                    if let profileImageURL = dict["pic"] as? String
                    {
                        let url = URL(string: profileImageURL)
                        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                            if error != nil{
                                print(error!)
                                return
                            }
                            DispatchQueue.main.async {
                                self.profileImage?.image = UIImage(data: data!)
                            }
                        }).resume()
                    }
                }
            })
        }
    }
    
    func saveChanges() {
        let storedImage = storageRef.child("ProfileAvatars").child(uid ?? "no id fail")
        if let uploadData = self.profileImage.image?.pngData()
        {
            storedImage.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil{
                    print(error!)
                    return
                }
                storedImage.downloadURL(completion: { (url, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    if let urlText = url?.absoluteString{
                        self.databaseRef.child("users").child((Auth.auth().currentUser?.uid) ?? "fail").updateChildValues(["pic" : urlText], withCompletionBlock: { (error, ref) in
                            if error != nil{
                                print(error!)
                                return
                            }
                        })                    }
                })
            })
        }
    }
    
    func showName() {
        let db = Firestore.firestore()
        if let userId = Auth.auth().currentUser?.uid {
            db.collection("users").getDocuments() { (snapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        if let currentUserDoc = snapshot?.documents.first(where: { ($0["uid"] as? String) == userId }) {
                            let firstName = currentUserDoc["firstname"] ?? "error firstname"
                            let lastName = currentUserDoc["lastname"] ?? "errorLastName"
                            self.userNameLabel.text = "\(firstName) \(lastName)"
                        }
                    }
                }
            }
        }
    }
}


// MARK: - ImagePicker
extension ProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func pickerImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        profileImage.image = image
        dismiss(animated: true)
        profileImage.layer.cornerRadius = profileImage.frame.width/2.0
        profileImage.clipsToBounds = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}


    

