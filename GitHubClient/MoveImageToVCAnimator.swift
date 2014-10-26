//
//  MoveImageToVCAnimator.swift
//  GitHubClient
//
//  Created by Nathan Birkholz on 10/23/14.
//  Copyright (c) 2014 Nate Birkholz. All rights reserved.
//

import UIKit

class MoveImageToVCAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var origin: CGRect?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 1.0
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // Find references for the two views controllers we're moving between
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as UserViewController
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UserProfileViewController
        
        // Grab the container view from the context
        let containerView = transitionContext.containerView()
        let breakThis = fromViewController.imageFrame!
        
        // Position the toViewController in its starting position
        toViewController.view.frame = self.origin!
        toViewController.imageView.frame = fromViewController.imageFrame!
//            toViewController.imageView.bounds

        // Add the toViewController's view ontzo the containerView
        containerView.addSubview(toViewController.view)
        
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            // During animation, expand the toViewController's view frame
            // to match the original view controllers
            // This will cause the toViewController to fill the screen

            toViewController.view.frame = fromViewController.view.frame
            toViewController.imageView.frame = toViewController.view.frame
            }) { (finished) -> Void in
                // When finished, hide our fromViewController
                fromViewController.view.alpha = 0.0
                // And tell the transitionContext we're done
                transitionContext.completeTransition(finished)
        }
    }

    func CGRectFlipped(rect: CGRect, bounds: CGRect) -> CGRect {
        var flip = CGRectMake(CGRectGetMinX(rect), CGRectGetMaxY(bounds)-CGRectGetMaxY(rect), CGRectGetWidth(rect), CGRectGetHeight(rect)) as CGRect

        return flip
    }


}
