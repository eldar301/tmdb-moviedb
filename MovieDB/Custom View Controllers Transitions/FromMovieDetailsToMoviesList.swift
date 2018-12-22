//
//  FromMovieDetailsToMoviesList.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 24/11/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import UIKit

class FromMovieDetailsToMoviesList: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = ((transitionContext.viewController(forKey: .to) as? UITabBarController)?.selectedViewController  as? UINavigationController)?.topViewController as? UIViewController & MoviesListImageSource,
            let fromVC = transitionContext.viewController(forKey: .from) as? UIViewController & MovieDetailsImageDestination,
            let sourceImageViewSnapshot = fromVC.imageTransitionTo.snapshotView(afterScreenUpdates: false) else {
                return
        }
        
        toVC.imageTransitionFrom.isHidden = true
        fromVC.imageTransitionTo.isHidden = true
        
        let transitionContainer = transitionContext.containerView
        
        transitionContainer.insertSubview(transitionContext.viewController(forKey: .to)!.view, belowSubview: fromVC.view)
        
        fromVC.view.alpha =  1.0
        
        let originImageFrame = fromVC.imageTransitionTo.convert(fromVC.imageTransitionTo.bounds, to: nil)
        let destinationImageFrame = toVC.imageTransitionFrom.convert(toVC.imageTransitionFrom.bounds, to: nil)
        transitionContainer.addSubview(sourceImageViewSnapshot)
        sourceImageViewSnapshot.frame = originImageFrame
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0.0,
            options: .calculationModeCubicPaced,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.7, animations: {
                    sourceImageViewSnapshot.frame = destinationImageFrame
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                    fromVC.view.alpha = 0.0
                })
        }) { _ in
            toVC.imageTransitionFrom.isHidden = false
            fromVC.imageTransitionTo.isHidden = false
            sourceImageViewSnapshot.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
}
