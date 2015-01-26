//
//  SearchRepositoryViewController.swift
//  ClientForGithub
//
//  Created by cm2y on 1/19/15.
//  Copyright (c) 2015 cm2y. All rights reserved.
//


import UIKit

class SearchUsersViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate, UINavigationControllerDelegate {
  
  @IBOutlet weak var searchBar: UISearchBar!
  
  @IBOutlet weak var collectionView: UICollectionView!

  
  
  var networkController : NetworkController!
  
  var GitHubUsers = [GitHubUser]()
  
  let imageQueue = NSOperationQueue()
  
  
  
  
  override func viewDidLoad() {
    println("SearchUsersViewController: viewDidLoad()")
    
    super.viewDidLoad()

    self.collectionView.dataSource = self
    self.searchBar.delegate = self
    self.navigationController?.delegate = self
    
    
  }
  
  
  
  //UITableViewDataSource
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

    println("Loading \(GitHubUsers.count) cells for table view")
    return GitHubUsers.count
    
    
  }
  

  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    
    println("reloading page data")
    
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("USER_CELL", forIndexPath: indexPath) as UserCell
    
        //clear it out to begin with
        cell.imageView.image = nil
    
    
    var gitHubUser = GitHubUsers[indexPath.row]
    
      //if there's no image grab it
      if ( gitHubUser.gitHubUserAvatarImage == nil ) {

        println("there's no image, must grab it from url:  = \(gitHubUser.gitHubUserAvatarURL)")
        
        NetworkController.sharedNetworkController.fetchAvatarImageForRepoOwner(gitHubUser.gitHubUserAvatarURL, completionHandler: { (retrievedImage) -> (Void) in
  
          
  
          //update the cell value, upate the image value in the object and update the object in the array
          cell.imageView.image = retrievedImage
  
  
          gitHubUser.gitHubUserAvatarImage = retrievedImage
          self.GitHubUsers[indexPath.row] = gitHubUser
  
  
        })
  
      }//else show it
      else {
        println("gitHubUser.gitHubUserAvatarImage = \(gitHubUser.gitHubUserAvatarImage)")
        
        cell.imageView.image = gitHubUser.gitHubUserAvatarImage
        
      }

    
    return cell
  
  }
    
  
  
  
  //UISearchBarDelegate
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    
      //grab the user name
    println("\(searchBar.text) was entered in search bar")
    
      //return the repo user objects for that user name
    NetworkController.sharedNetworkController.fetchUsersForSearchTerm(searchBar.text, callback: { (GitHubUsers, errorDescription) -> (Void) in
      
      if ( errorDescription == nil ) {
        
        self.GitHubUsers = GitHubUsers!
        println("Got \( self.GitHubUsers.count ) repos")
        
        
        // Swift
        let count = self.GitHubUsers.count
        
        
        //for each repo, set the reference to grab the image for the collection view
        for var i = 0; i < count; i++ {
          
          //grab a repo
          var aGitHubUser = self.GitHubUsers[i]
          println("aGitHubUser\( aGitHubUser )")
          
          //update the avatar image reference
          aGitHubUser.setGitHubUserAvatarImage(aGitHubUser.gitHubUserAvatarURL)
          println("set the image reference: \( aGitHubUser.getGitHubUserAvatarImage())")
          
          //add it back to the list of repos
          self.GitHubUsers[i] = aGitHubUser
          println("Adding  \( self.GitHubUsers[i] ) back to deck")
          
          
        }

        self.collectionView.reloadData()
        
      }
      
    })
    
    
  }
  
  
 
  
  
  //become the deligate for the nav controller
  func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
    if toVC is UserDetailViewController {
      //return the animation controller
      return ToUserDetailAnimationController()
    }
    
        if fromVC is SearchUsersViewController  {
          return ToUserDetailAnimationController()
        }
    
    return nil
  }
  
  
  
    //instantiate the desitination for selected image
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    
    if segue.identifier == "SHOW_USER_DETAIL" {
      
      let fromVC = segue.sourceViewController as SearchUsersViewController
      let toVC = segue.destinationViewController as UserDetailViewController
      
      var selectedIndexPath = fromVC.collectionView.indexPathsForSelectedItems()!.first as NSIndexPath
      
      
  
      toVC.selectedUser = self.GitHubUsers[selectedIndexPath.row]
      
    }
  }
  
  
//
  
  
  func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    return text.validate()
  }
  
  
  
  
  
}//eo classs




//    //if there's no image grab it
//    if GitHubUser.gitHubUserAvatarImage == nil {
//
//      println("image url is \(GitHubUser.gitHubUserAvatarURL)")
//
//
//      NetworkController.sharedNetworkController.fetchAvatarImageForRepoOwner(GitHubUser.gitHubUserAvatarURL, completionHandler: { (retrievedImage) -> (Void) in
//
//
//        //update the cell value, upate the image value in the object and update the object in the array
//        cell.imageView.image = retrievedImage
//
//
//        GitHubUser.gitHubUserAvatarImage = retrievedImage
//        GitHubUsers[indexPath.row] = GitHubUser
//
//
//      })
//
//    }//else show it
//    else {
//      cell.imageView.image = GitHubUser.gitHubUserAvatarImage
//    }
//    //update class variable with new data
//    self.GitHubUsers = GitHubUsers
