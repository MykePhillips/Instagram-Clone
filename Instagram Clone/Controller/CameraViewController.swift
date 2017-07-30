//
//  CameraViewController.swift
//  Instagram Clone
//
//  Created by Myke on 27/07/2017.
//  Copyright © 2017 Myke. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class CameraViewController: UIViewController {
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postCaptionText: UITextView!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var removeBtn: UIBarButtonItem!
    
    var selectedImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
 let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectedPhoto))
        postImage.addGestureRecognizer(tapGesture)
        postImage.isUserInteractionEnabled = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handlePost()
    }
    func handlePost() {
        if selectedImage != nil {
            self.shareBtn.isEnabled = true
            self.removeBtn.isEnabled = true
            self.shareBtn.backgroundColor = .black
        }else{
           self.shareBtn.isEnabled = false
            self.removeBtn.isEnabled = false
            self.shareBtn.backgroundColor = .lightGray
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func handleSelectedPhoto() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }

    @IBAction func shsareBtnAction(_ sender: Any) {
        
        ProgressHUD.show("Sharing...", interaction: false)
        if let profileImg = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
            let photoIDstring = NSUUID().uuidString
             let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOT_REF).child("photos").child(photoIDstring)
            storageRef.putData(imageData, metadata: nil, completion: { ( metadata, error) in
                if error != nil {
            ProgressHUD.showError(error?.localizedDescription)
                    return
                    
                }
                let photoUrl = metadata?.downloadURL()?.absoluteString
                self.sendDataToDtabase(photoUrl: photoUrl!)
                
            })
        } else {
            ProgressHUD.showError("Profile Image can't be empty")
        }
        
    }
    @IBAction func removePhoto(_ sender: Any) {
        clean()
        handlePost()
    }
    
    func clean() {
        self.postCaptionText.text = ""
        self.postImage.image = UIImage(named: "placeholderPhoto")
        self.selectedImage = nil
    }
    
    func sendDataToDtabase(photoUrl: String) {
        let ref = Database.database().reference()
        let postsReference = ref.child("photos")
        let newPostID = postsReference.childByAutoId().key
        let newPostReference = postsReference.child(newPostID)
        newPostReference.setValue(["photoUrl": photoUrl, "caption": postCaptionText.text!], withCompletionBlock: {
            (error, ref) in
            if error != nil {
                ProgressHUD.showError(error?.localizedDescription)
                return
            }
            ProgressHUD.showSuccess("Success!")
            self.clean()
            self.tabBarController?.selectedIndex = 0
        })
    }
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("did pick an image")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = image
            postImage.image = image
        }
        dismiss(animated: true, completion: nil)
        
    }
    
}
