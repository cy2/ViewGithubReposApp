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
    
    super.viewDidLoad()

    self.collectionView.dataSource = self
    self.searchBar.delegate = self
    self.navigationController?.delegate = self
    
    
  }
  
  
  
  //UITableViewDataSource
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

    return GitHubUsers.count
    
    
  }
  

    //shows a collection of avatar images for users
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    

    
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("USER_CELL", forIndexPath: indexPath) as UserCell
    
        //clear the image view out to begin with
        cell.imageView.image = nil
    
    
    if (GitHubUsers.count > 0 ){
    
    
        var gitHubUser = GitHubUsers[indexPath.row]
    
          //Grab the image using the url reference stored in the gitHubUser object")
        NetworkController.sharedNetworkController.fetchAvatarImageForRepoOwner(gitHubUser.gitHubUserAvatarURL, completionHandler: { (retrievedImage) -> (Void) in
  
          
  
          //update the image view in the cell with the retrieved image
          cell.imageView.image = retrievedImage
  
        })
      
      
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
      
      if ( errorDescription == "" ) {
        
        self.GitHubUsers = GitHubUsers!
        
        
        let count = self.GitHubUsers.count
        
        
        //for each repo, set the reference to grab the image for the collection view
        for var i = 0; i < count; i++ {
          
          //grab a repo
          var aGitHubUser = self.GitHubUsers[i]
          
          //update the avatar image reference
          aGitHubUser.setGitHubUserAvatarImage(aGitHubUser.gitHubUserAvatarURL)
          
          //add it back to the list of repos
          self.GitHubUsers[i] = aGitHubUser
          
          
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
      
      //leaving Search Users VC
      let fromVC = segue.sourceViewController as SearchUsersViewController
      
      //going to UserDetailViewController
      let toVC = segue.destinationViewController as UserDetailViewController
      
      //grab which cell was clicked
      var selectedIndexPath = fromVC.collectionView.indexPathsForSelectedItems()!.first as NSIndexPath
      
      //pass it to the toVC
      toVC.selectedUser = self.GitHubUsers[selectedIndexPath.row]
        println("selected user is \(self.GitHubUsers[selectedIndexPath.row] )")
      
    }
  }
  
  

  
    //make sure to validate query strings going to github server
  func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    return text.validate()
  }
  
  
  
  
  
}//eo classs

