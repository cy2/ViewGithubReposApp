//
//  SearchRepositoryViewController.swift
//  ClientForGithub
//
//  Created by cm2y on 1/19/15.
//  Copyright (c) 2015 cm2y. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    @IBOutlet weak var selectedUserImage: UIImageView!
  
  var selectedUser : GitHubUser!

  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("person selected is \(selectedUser.gitHubUserName)")
        
        self.selectedUserImage.image = selectedUser.getGitHubUserAvatarImage()
        
        //add labels for other info about user
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
