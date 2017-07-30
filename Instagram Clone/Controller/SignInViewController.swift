//
//  SignInViewController.swift
//  Instagram Clone
//
//  Created by Myke on 27/07/2017.
//  Copyright © 2017 Myke. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let botomLayerEmail = CALayer()
        botomLayerEmail.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6 )
        botomLayerEmail.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        emailTextField.layer.addSublayer(botomLayerEmail)
        
        let botomLayerPassword = CALayer()
        botomLayerPassword.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6 )
        botomLayerPassword.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        passwordTextField.layer.addSublayer(botomLayerPassword)
        
        signInBtn.isUserInteractionEnabled = false
        
        handleTextField()
        
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "signInToTabbarVC", sender: nil)
        }
        
    }
    
    func handleTextField() {
        
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        
    }
    
    @objc func textFieldDidChange() {
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            signInBtn.setTitleColor(.lightText, for: .normal)
            signInBtn.isUserInteractionEnabled = false
            return
        }
        
        signInBtn.setTitleColor(.white, for: .normal)
        signInBtn.isUserInteractionEnabled = true
    }
    
    @IBAction func signInActionBtn(_ sender: Any) {
        view.endEditing(true)
        ProgressHUD.show("Waiting...", interaction: false)
        AuthService.signInMethod(email: emailTextField.text!, password: passwordTextField.text!, onSuccess: {
            ProgressHUD.showSuccess("Success!")
            self.performSegue(withIdentifier: "signInToTabbarVC", sender: nil)
            
        }, onError: { error in
            ProgressHUD.showError(error!)
            
        })
        
        
    }
}
