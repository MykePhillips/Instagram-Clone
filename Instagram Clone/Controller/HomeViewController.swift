//
//  HomeViewController.swift
//  Instagram Clone
//
//  Created by Myke on 27/07/2017.
//  Copyright © 2017 Myke. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController {
    @IBOutlet weak var homeTableView: UITableView!
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPosts()
        

    }
  
    func loadPosts() {
        Database.database().reference().child("photos").observe(.childAdded) { (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let captionText = dict["caption"] as! String
                let photoURLString = dict["photoUrl"] as! String
                let post = Post(captionText: captionText, photoURLString: photoURLString)
                self.posts.append(post)
                print(self.posts)
                self.homeTableView.reloadData()
                
            }
        }
    }
   
    @IBAction func logOutBtn(_ sender: Any) {
   
    do {
            try Auth.auth().signOut()
            
            }catch let logOutError {
                print(logOutError)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        
        self.present(signInVC, animated: true, completion: nil)
        
        }
    
        
    }

extension HomeViewController: UITableViewDataSource {
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        
        cell.textLabel?.text = posts[indexPath.row].caption
       
        
        return cell
    }
    
    
    
}
