//
//  FromMoviesListToMovieDetails.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 24/11/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import UIKit

protocol MoviesListImageSource: UIViewControllerTransitioningDelegate {
    var imageTransitionFrom: UIImageView! { get }
}

protocol MovieDetailsImageDestination {
    var imageTransitionTo: UIImageView! { get }
}

class FromMoviesListToMovieDetails: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = ((transitionContext.viewController(forKey: .from) as? UITabBarController)?.selectedViewController  as? UINavigationController)?.topViewController as? UIViewController & MoviesListImageSource,
            let toVC = transitionContext.viewController(forKey: .to) as? UIViewController & MovieDetailsImageDestination,
            let sourceImageViewSnapshot = fromVC.imageTransitionFrom.snapshotView(afterScreenUpdates: false) else {
                return
        }
        
        toVC.imageTransitionTo.isHidden = true
        fromVC.imageTransitionFrom.isHidden = true
        
        let transitionContainer = transitionContext.containerView
        
        transitionContainer.addSubview(toVC.view)
        toVC.view.alpha =  0.0

        let originImageFrame = fromVC.imageTransitionFrom.convert(fromVC.imageTransitionFrom.bounds, to: nil)
        let destinationImageFrame = toVC.imageTransitionTo.convert(toVC.imageTransitionTo.bounds, to: nil)
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
                    toVC.view.alpha = 1.0
                })
        }) { _ in
            fromVC.imageTransitionFrom.isHidden = false
            toVC.imageTransitionTo.isHidden = false
            sourceImageViewSnapshot.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }

}

extension UIViewController {
    
    @objc(animationControllerForPresentedController:presentingController:sourceController:) func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presented is MovieDetailsImageDestination {
            return FromMoviesListToMovieDetails()
        }
        
        return nil
    }
    
    @objc(animationControllerForDismissedController:) func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed is MovieDetailsImageDestination {
            return FromMovieDetailsToMoviesList()
        }
        
        return nil
    }
    
}
