//
//  ToUserDetailAnimationController.swift
//  ClientForGithub
//
//  Created by cm2y on 1/23/15.
//  Copyright (c) 2015 cm2y. All rights reserved.
//
import UIKit



  //a class to create a custom animation: create the transition delegate that retuns the vc and does the animation
class ToUserDetailAnimationController : NSObject, UIViewControllerAnimatedTransitioning {
    
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
    //how long the animation should take
    return 0.4
  
  }
  
    
    
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    
    //grab references to the FROM VC
    let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as SearchUsersViewController
    
    //grab references to the TO VC
    let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UserDetailViewController
    
    //create the container view
    let containerView = transitionContext.containerView()
    
    
      //setting up the starting position of the image
        let selectedIndexPath = fromVC.collectionView.indexPathsForSelectedItems()!.first as NSIndexPath
    
        //find the cell
        let cell = fromVC.collectionView.cellForItemAtIndexPath(selectedIndexPath) as UserCell
    
        //create a carbon copy of the image to replicate it at it's starting position
        let snapshotOfCell = cell.imageView.snapshotViewAfterScreenUpdates(false)// show now = false
    
        //hide the origional image, so they dont apprear overlapped
        cell.imageView.hidden = true
    
        //give the snapshot view a frame
        snapshotOfCell.frame = containerView.convertRect(cell.imageView.frame, fromView: cell.imageView.superview)
    
        //make our toVC start on screen, but with alpha 0
        toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
    
        //fade in
        toVC.view.alpha = 0
    
        toVC.selectedUserImage.hidden = true
    
        containerView.addSubview(toVC.view)
    
        containerView.addSubview(snapshotOfCell)
 
    
    //telling autolayout to make a pass
    toVC.view.setNeedsLayout()
    toVC.view.layoutIfNeeded()
    
    
    let duration = self.transitionDuration(transitionContext)
    
    UIView.animateWithDuration(duration, animations: { () -> Void in
      toVC.view.alpha = 1.0
      
      let frame = containerView.convertRect(toVC.selectedUserImage.frame, fromView: toVC.view)
      snapshotOfCell.frame = frame
      
      }) { (finished) -> Void in
        
        //clean up
        toVC.selectedUserImage.hidden = false
        cell.imageView.hidden = false
        snapshotOfCell.removeFromSuperview()
        transitionContext.completeTransition(true)
    }
    
    
    
}



}
