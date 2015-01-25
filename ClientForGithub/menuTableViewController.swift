//
//  menuTableViewController.swift
//  ClientForGithub
//
//  Created by cm2y on 1/19/15.
//  Copyright (c) 2015 cm2y. All rights reserved.
//

import UIKit

class menuTableViewController: UITableViewController {
  
  
  //var networkController : NetworkController!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  // on load - ask Github for token
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    //once we get back to the main screen, tell the nav controller we dont want to be the delegate anymore
    self.navigationController?.delegate = nil
    
    if NetworkController.sharedNetworkController.accessToken == nil {
      NetworkController.sharedNetworkController.requestAccessToken()
    }
    
    
  
  }
  
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  
  }

  
  
}
