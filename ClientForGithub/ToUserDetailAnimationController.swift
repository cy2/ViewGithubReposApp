//
//  ToUserDetailAnimationController.swift
//  ClientForGithub
//
//  Created by cm2y on 1/23/15.
//  Copyright (c) 2015 cm2y. All rights reserved.
//
import UIKit

class ToUserDetailAnimationController : NSObject, UIViewControllerAnimatedTransitioning {
  
  
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
    return 0.4
  }
  
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    //grab references to both of the view controllers
    let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as SearchUsersViewController
    
    let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UserDetailViewController
    
    let containerView = transitionContext.containerView()
    
    //find the selected cell and make a snapshot of the imageview that is going to move
    let selectedIndexPath = fromVC.collectionView.indexPathsForSelectedItems()!.first as NSIndexPath
    
    let cell = fromVC.collectionView.cellForItemAtIndexPath(selectedIndexPath) as UserCell
    
    let snapshotOfCell = cell.imageView.snapshotViewAfterScreenUpdates(false)
  
    cell.imageView.hidden = true
    
    snapshotOfCell.frame = containerView.convertRect(cell.imageView.frame, fromView: cell.imageView.superview)
    
    //make our toVC start on screen, but with alpha 0
    toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
    
    toVC.view.alpha = 0
    
    toVC.imageView.hidden = true
    
    containerView.addSubview(toVC.view)
    
    containerView.addSubview(snapshotOfCell)
    
    //telling autolayout to make a pass
    toVC.view.setNeedsLayout()
    toVC.view.layoutIfNeeded()
    
    let duration = self.transitionDuration(transitionContext)
    
    UIView.animateWithDuration(duration, animations: { () -> Void in
      toVC.view.alpha = 1.0
      
      let frame = containerView.convertRect(toVC.imageView.frame, fromView: toVC.view)
      snapshotOfCell.frame = frame
      
      }) { (finished) -> Void in
        
        //clean up
        toVC.imageView.hidden = false
        cell.imageView.hidden = false
        snapshotOfCell.removeFromSuperview()
        transitionContext.completeTransition(true)
    }
    
    
    
}



}
