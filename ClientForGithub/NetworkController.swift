//
//  NetworkController.swift
//  ClientForGithub
//
//  Created by cm2y on 1/19/15.
//  Copyright (c) 2015 cm2y. All rights reserved.
//

import UIKit

class NetworkController{
 
  
  //singleton
  class var sharedNetworkController : NetworkController {
    struct Static {
      static let instance : NetworkController = NetworkController()
    }
    return Static.instance
  }
  
 
  
  var urlSession : NSURLSession
  let clientID = "hasBeenReset"
  let clientSecret = "hasBeenResetToo"
  let accessTokenUserDefaultsKey = "accessToken"
  var accessToken : String?
  let imageQueue = NSOperationQueue()

  
  init(){
    
    let ephemeralConfig = NSURLSessionConfiguration.ephemeralSessionConfiguration()
    
    self.urlSession = NSURLSession(configuration: ephemeralConfig)
    
  }
  
  
  //MARK: Github Access - Step 1
  func requestAccessToken() {
    
    let url = "https://github.com/login/oauth/authorize?client_id=\(self.clientID)&scope=user,repo"
    
    UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    
    
  }
  
  
  
  //MARK: Github access - Step 2 , parse out the code from the URL
  
  func handleCallbackURL(url : NSURL) {
    
    let code = url.query
    
    //set up the url
    let bodyString = "\(code!)&client_id=\(self.clientID)&client_secret=\(self.clientSecret)"
    let bodyData = bodyString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
    let length = bodyData!.length
    
    //create the post request
    let postRequest = NSMutableURLRequest(URL: NSURL(string: "https://github.com/login/oauth/access_token")!)
    postRequest.HTTPMethod = "POST"
    postRequest.setValue("\(length)", forHTTPHeaderField: "Content-Length")
    postRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    postRequest.HTTPBody = bodyData
    
    
    //create the data task
    let dataTask = self.urlSession.dataTaskWithRequest(postRequest, completionHandler: { (data, response, error) -> Void in
      if error == nil {
        if let httpResponse = response as? NSHTTPURLResponse {
          switch httpResponse.statusCode {
          case 200...299:
            let tokenResponse = NSString(data: data, encoding: NSASCIIStringEncoding)
            println(tokenResponse)
            
            let accessTokenComponent = tokenResponse?.componentsSeparatedByString("&").first as String
            let accessToken = accessTokenComponent.componentsSeparatedByString("=").last
            
            
            //add the Access Token to the session
            NSUserDefaults.standardUserDefaults().setObject(accessToken!, forKey: self.accessTokenUserDefaultsKey)
            NSUserDefaults.standardUserDefaults().synchronize()
            
          default:
            println("default case")
          }
        }
      }
      
    })
    dataTask.resume()
    
  }
  
  
  
  
  
  
  //MARK: Network Calls to Server
  
  
  //method to fetch results from github for search term
  func searchGitHubRepositoriesForSearchTermAndParse(searchTerm : String, callback : ([GitHubUser]?, String) -> (Void)){
    
    //create Github url
    let githubURL = NSURL(string: "https://api.github.com/search/repositories?q=\(searchTerm)")
    
    //create the request
    let request = NSMutableURLRequest(URL: githubURL!)
    
    
    //create the data task and send it
    let dataTask = self.urlSession.dataTaskWithRequest(request, completionHandler: {
      
      (data, response, error) -> Void in
      
      if error == nil {
        //println("response string \(response)")
        
        if let httpResponse = response as? NSHTTPURLResponse {
          
          
          switch httpResponse.statusCode {
            
         case 200...299:
            println("Good Server response \(httpResponse)")
            
            let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as [String : AnyObject]
            
            //Tokenise out the array of users
            for object in jsonDictionary {
              
              if let itemsArray = jsonDictionary["items"] as? [[String : AnyObject]] {
                
                //println("Grabbing \(itemsArray.count) repos")
                
                var GitHubUsers = [GitHubUser]()
                
                
                for item in itemsArray {

                  let aGitHubUser = GitHubUser(jsonDictionary: item)

                 
                  GitHubUsers.append(aGitHubUser)
                  
                }
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                  callback(GitHubUsers,"")
                })
                
              }
              
            }
            
            
            
          default:
            
            println("default")
            
          }
          
        }
      }else{
        
        println("Error wasn't nil: response string \(error)")
        
      }
      
      
    })
    
    //call resume to send request
    dataTask.resume()
    
  }// eo searchRepositoriesForSearchTermAndParse
  
  
  
  
  
  
    //lazy loads the image for a gihub repo URL
  func fetchAvatarImageForRepoOwner(url : String, completionHandler : (UIImage) -> (Void)) {
    //println("Fetching Avatar image from github")
    
    let url = NSURL(string: url)
    
    self.imageQueue.addOperationWithBlock { () -> Void in
      let imageData = NSData(contentsOfURL: url!)
      let image = UIImage(data: imageData!)
      
      NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
        completionHandler(image!)
      })
    }
  }

  
  
    //grab users for collection view
  func fetchUsersForSearchTerm(searchTerm : String, callback : ([GitHubUser]?, String?) -> (Void)) {
    
    
    
    let url = NSURL(string: "https://api.github.com/search/users?q=\(searchTerm)")
    
    let at: (AnyObject?) = (NSUserDefaults.standardUserDefaults().objectForKey(self.accessTokenUserDefaultsKey))!
    
    let AccesTokenStringValue: String = ("\(at!)")
        //println("retrieved AccesTokenStringValue = \(AccesTokenStringValue)")

    
      //set up query
    let request = NSMutableURLRequest(URL: url!)
    
    request.setValue("token \(AccesTokenStringValue)", forHTTPHeaderField: "Authorization")
    
    
      //send it
    
    let dataTask = self.urlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      if error == nil {
        
        
        
        if let httpResponse = response as? NSHTTPURLResponse {
          switch httpResponse.statusCode {
          case 200...299:
            
            if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String : AnyObject] {

              if let itemsArray = jsonDictionary["items"] as? [[String : AnyObject]] {
            

                var GitHubUsers = [GitHubUser]()
                
                
                for item in itemsArray {
                  
                  
                  let aGitHubUser = GitHubUser(jsonDictionary: item)
                  
                  
                    //update each GitHubUser's object with their avatar image's url
                  if ( aGitHubUser.gitHubUserAvatarImage == nil ) {
                  
                    
                        aGitHubUser.setGitHubUserAvatarImage(aGitHubUser.gitHubUserAvatarURL)
                    
                      //add the updated object back to the deck
                      GitHubUsers.append(aGitHubUser)
                    
                  }
                  
                  
                }
                
                    //add to subprocess
                 NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                  callback(GitHubUsers,"")
                  
                  
                })

                
              }
            }
            
          default:
            println("default case on user search, status code: \(httpResponse.statusCode)")
          }
        }
        
      } else {
        println(error.localizedDescription)
      }
    })
    dataTask.resume()
  }
  
  
  
  
  
}//eo class


