//
//  SignUpViewController.swift
//  Instagram Clone
//
//  Created by Myke on 27/07/2017.
//  Copyright © 2017 Myke. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController{
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.endEditing(true)
        profileImage.layer.cornerRadius = 40
        
        let botomLayerUsername = CALayer()
        botomLayerUsername.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6 )
        botomLayerUsername.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        usernameTextField.layer.addSublayer(botomLayerUsername)
        
        let botomLayerEmail = CALayer()
        botomLayerEmail.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6 )
        botomLayerEmail.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        emailTextField.layer.addSublayer(botomLayerEmail)
        
        let botomLayerPassword = CALayer()
        botomLayerPassword.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6 )
        botomLayerPassword.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        passwordTextField.layer.addSublayer(botomLayerPassword)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectProfileImageView))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        signUpBtn.isUserInteractionEnabled = true
        handleTextFielad()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func handleTextFielad() {
        usernameTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        
    }
    
    @objc func textFieldDidChange() {
        guard let username = usernameTextField.text, !username.isEmpty, let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            signUpBtn.setTitleColor(.lightText, for: .normal)
            signUpBtn.isUserInteractionEnabled = false
            return
        }
        
        signUpBtn.setTitleColor(.white, for: .normal)
        signUpBtn.isUserInteractionEnabled = true
    }
    
    @objc func handleSelectProfileImageView(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
       
  
    }
    
    @IBAction func dismiss_onClick(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
      
        ProgressHUD.show("Waiting...", interaction: false)
        if let profileImg = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
            AuthService.signUpMethod(username: usernameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, imageData: imageData, onSuccess: {
                ProgressHUD.showSuccess("Success")
                
                self.performSegue(withIdentifier: "signUpToTabbarVC", sender: nil)
               
            }, onError: { error in
                ProgressHUD.showError(error!)
            })
        } else {
            ProgressHUD.showError("Profile Image can't be empty")
        }
    }
   
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("did pick an image")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = image
            profileImage.image = image
        }
        dismiss(animated: true, completion: nil)
        
    }
    
}




