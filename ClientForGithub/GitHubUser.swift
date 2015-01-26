//
//  GitHubRepo.swift
//  ClientForGithub
//
//  Created by cm2y on 1/19/15.
//  Copyright (c) 2015 cm2y. All rights reserved.
//

import Foundation
import UIKit

class GitHubUser {
  
  
  
  //let gitHubUserId : String
  
  let gitHubUserName : String
  
  //let gitHubUserRepo : NSDictionary
  
  let gitHubUserRepoDescription: String
  
  let gitHubUserRepoLocationURL: String
  
  let gitHubUserAvatarURL : String
  
  var gitHubUserAvatarImage : UIImage?
  
  
  
  
  init(jsonDictionary : [String : AnyObject]) {

    
    if( jsonDictionary["name"] == nil){
      
      self.gitHubUserName = ""
      
    }else{
      self.gitHubUserName = jsonDictionary["name"] as String
    }
    
    
    
    //if description is not in the json return an empty string
    
    if( jsonDictionary["login"] == nil){
      
      self.gitHubUserName = ""
      
    }else{
      self.gitHubUserName = jsonDictionary["login"] as String
      
    }
    

    
      //if description is not in the json return an empty string
    
    if( jsonDictionary["description"] == nil){
    
      self.gitHubUserRepoDescription = ""
    
    }else{
        self.gitHubUserRepoDescription = jsonDictionary["description"] as String
    
    }
    
    

    
    if( jsonDictionary["description"] == nil){
      
      self.gitHubUserRepoLocationURL = ""
      
    }else{
      self.gitHubUserRepoLocationURL = jsonDictionary["html_url"] as String
      
    }
    
    
    
    if( jsonDictionary["avatar_url"] == nil){
      
      self.gitHubUserAvatarURL = ""
      
    }else{
      self.gitHubUserAvatarURL = jsonDictionary["avatar_url"] as String
    }
    
  
    
    //self.gitHubUserRepo = jsonDictionary["owner"] as NSDictionary
    //self.gitHubUserId = String(gitHubUserRepo["id"] as Int)
    //self.gitHubUserAvatarURL = String(gitHubUserRepo["avatar_url"] as String)
    
    
    
  }
  

  
  
  func setGitHubUserAvatarImage(grabbedImageURL: String ) {

    let userAvatarURLStr = self.gitHubUserAvatarURL
    
    //assign the image value to the cell
    if let userAvatarURL = NSURL(string: userAvatarURLStr) {
      
      //convert url to data object
      if let imageData = NSData(contentsOfURL: userAvatarURL) {
        
        let gitHubUserAvatarImage = UIImage(data: imageData)
        self.gitHubUserAvatarImage = gitHubUserAvatarImage
        
      }
      
    }
    
    
  }

  
  
  
  func getGitHubUserAvatarImage() -> UIImage{
    
    return self.gitHubUserAvatarImage!
  }

  

}















/*

{
String: "id": 3081286,
String: "name": "Tetris",
String: "full_name": "dtrupenn/Tetris",


[String] "owner": {

"login": "dtrupenn",
"id": 872147,
"avatar_url": "https://secure.gravatar.com/avatar/e7956084e75f239de85d3a31bc172ace?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png",
"gravatar_id": "e7956084e75f239de85d3a31bc172ace",
"url": "https://api.github.com/users/dtrupenn",
"received_events_url": "https://api.github.com/users/dtrupenn/received_events",
"type": "User"
},



Bool: "private": false,
String: "html_url": "https://github.com/dtrupenn/Tetris",
String: "description": "A C implementation of Tetris using Pennsim through LC4",
Bool: "fork": false,
String: "url": "https://api.github.com/repos/dtrupenn/Tetris",
String: "created_at": "2012-01-01T00:31:50Z",
String: "updated_at": "2013-01-05T17:58:47Z",
String: "pushed_at": "2012-01-01T00:37:02Z",
String: "homepage": "",
Int: "size": 524,
Int: "stargazers_count": 1,
Int: "watchers_count": 1,
String: "language": "Assembly",
int: "forks_count": 0,
Int: "open_issues_count": 0,
String: "master_branch": "master",
String: "default_branch": "master",
String: "score": 10.309712



},





*/


