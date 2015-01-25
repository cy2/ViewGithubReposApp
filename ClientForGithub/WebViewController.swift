//
//  WebViewController.swift
//  ClientForGithub
//
//  Created by cm2y on 1/23/15.
//  Copyright (c) 2015 cm2y. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
  
  var networkController : NetworkController!
  
  let webView = WKWebView()
  var url : String!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.webView.frame = self.view.frame
    self.view.addSubview(self.webView)
    

    let request = NSURLRequest(URL: NSURL(string: self.url)!)
    self.webView.loadRequest(request)
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}
