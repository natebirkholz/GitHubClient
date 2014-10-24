//
//  AnimationDelegate.swift
//  GitHubClient
//
//  Created by Nathan Birkholz on 10/23/14.
//  Copyright (c) 2014 Nate Birkholz. All rights reserved.
//

import UIKit

class AnimationDelegate: NSObject, UINavigationControllerDelegate {
    
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    // This is called whenever during all navigation operations
    
    // Only return a custom animator for two view controller types
        if fromVC == UserViewController() && toVC == UserProfileViewController()  {
            let userViewController = fromVC as UserViewController
        let animator = MoveImageToVCAnimator()
        animator.origin = userViewController.origin
        
        return animator
        }
        else if fromVC == UserProfileViewController() && toVC == UserViewController() {

            let userProfileViewController = fromVC as UserProfileViewController
        let animator = RemoveImageFromVCAnimator()
        animator.origin = userProfileViewController.reverseOrigin
        
        return animator
        }
    
    // All other types use default transition
    return nil
    }
}