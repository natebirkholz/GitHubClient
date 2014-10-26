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

        if let vcFromTest = fromVC as? UserViewController {
            if let vcToTest = toVC as? UserProfileViewController {
                println("inside")
                let userViewController = fromVC as UserViewController
                let animator = MoveImageToVCAnimator()
                animator.origin = userViewController.origin
                return animator
            } else {
                return nil
            }
        }

        if let vcFromTest = fromVC as? UserProfileViewController {
            if let vcToTest = toVC as? UserViewController {
                let userProfileViewController = fromVC as UserProfileViewController
                let animator = RemoveImageFromVCAnimator()
                animator.origin = userProfileViewController.reverseOrigin
                return animator
            } else {
                return nil
            }
        }

//    The below code used to work, now it doesn't. Why?
//        if fromVC == UserViewController() && toVC == UserProfileViewController()  {
//            println("inside")
//            let userViewController = fromVC as UserViewController
//        let animator = MoveImageToVCAnimator()
//        animator.origin = userViewController.origin
//        return animator
//        } else if fromVC == UserProfileViewController() && toVC == UserViewController() {
//            let userProfileViewController = fromVC as UserProfileViewController
//            let animator = RemoveImageFromVCAnimator()
//            animator.origin = userProfileViewController.reverseOrigin
//            return animator
//        }

    return nil
    }
}