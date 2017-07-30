//
//  Post.swift
//  Instagram Clone
//
//  Created by Myke on 30/07/2017.
//  Copyright © 2017 Myke. All rights reserved.
//

import Foundation
class Post {
    var caption: String
    var photoURL: String
    
    init(captionText: String, photoURLString: String) {
       caption = captionText
       photoURL = photoURLString
    }
}
