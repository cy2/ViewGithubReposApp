//
//  SearchRepositoryViewController.swift
//  ClientForGithub
//
//  Created by cm2y on 1/19/15.
//  Copyright (c) 2015 cm2y. All rights reserved.
//

import UIKit



  //This View allows a user to search Github and bring back all repositories by search term
class SearchRepositoryViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate, UITableViewDelegate{
  
  
  @IBOutlet weak var searchRepositoryVCtableView: UITableView!
  
  @IBOutlet weak var searchRepositoryVCsearchBar: UISearchBar!
  

  var networkController : NetworkController!
  
  var GitHubUsers : [GitHubUser]?
  
  let imageQueue = NSOperationQueue()
  
  
  
  
  override func viewDidLoad() {
    println("SearchRepositoryViewController: viewDidLoad()")
  
    super.viewDidLoad()
    
    self.searchRepositoryVCtableView.dataSource = self
    self.searchRepositoryVCtableView.delegate = self
    
    self.searchRepositoryVCsearchBar.delegate = self
    self.searchRepositoryVCsearchBar.text = "Tetris"
    
    
    //create a singleton network controller and add it to the app deligate
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    self.networkController = appDelegate.networkController
    
    
  }
  
    //UITableViewDataSource
  func tableView(searchRepositoryVCtableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
    
    println("Loading \(GitHubUsers?.count) cells for table view")
    if let GitHubUsers = self.GitHubUsers {
      return GitHubUsers.count
    } else {
      return 1
    }
  
  
  }
  
  
  func tableView(searchRepositoryVCtableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = searchRepositoryVCtableView.dequeueReusableCellWithIdentifier("REPO_CELL", forIndexPath: indexPath) as RepoCell
    
    
    if (GitHubUsers != nil ){
    
    
      var GitHubUsers = self.GitHubUsers!
    
      //grab the repo
      var GitHubUser = GitHubUsers[indexPath.row]
      println("grabbing one repo")

      cell.gitHubUserName.text = GitHubUser.gitHubUserName
      println("GitHubUser.gitHubUserName \(GitHubUser.gitHubUserName)")
      
      cell.gitHubRepoDescription.text = GitHubUser.gitHubUserRepoDescription
      println("gitHubUser.RepoDescription \(GitHubUser.gitHubUserRepoDescription)")
    
    }
      
    return cell

  }
 
  
  //UISearchBarDelegate
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    
    //grab search term
    println("\(searchBar.text) was entered in search bar")
    
    
    self.networkController.searchGitHubRepositoriesForSearchTermAndParse(searchBar.text, callback: { (GitHubUsers, errorDescription) -> (Void) in
      
      if ( errorDescription == "" ) {
      
        self.GitHubUsers = GitHubUsers!
        println("Got \( self.GitHubUsers?.count ) repos")
        
        self.searchRepositoryVCtableView.reloadData()
      
      }
    
   })

  
  }
  
  
  
  
  //method to call any time you click on a cell
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    
    print ("cell clicked")
    
    
    if let GitHubUsers = self.GitHubUsers {
 
      
      //create the web view controller
      let webVC = self.storyboard?.instantiateViewControllerWithIdentifier("WEB_VC") as WebViewController
      
      
      webVC.networkController = self.networkController
      
      //give it a copy of the tweet at the selected row
      var gitHubUserRepo = GitHubUsers[indexPath.row]
      var repoURL = gitHubUserRepo.gitHubUserRepoLocationURL
      println("repoURL = \(repoURL)")
      
      webVC.url = repoURL
      //send redirect
      self.navigationController?.pushViewController(webVC, animated: true)
      
    
    }
    
    
    


    
  }
  
  func searchBar(searchRepositoryVCsearchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    return text.validate()
  }
  
  

}//eo classs