//
// Created by 周佳 on 2019-01-12.
// Copyright (c) 2019 AppCoda. All rights reserved.
//

import UIKit

class SlideRightTransitionAnimator: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    let duration = 0.5

    var isPresent = false

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        return self
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let fromView = transitionContext.view(forKey: .from) else {
            return
        }

        guard let toView = transitionContext.view(forKey: .to) else {
            return
        }

        let container = transitionContext.containerView

        let offScreenLeft = CGAffineTransform(translationX: -container.frame.width, y: 0)

        if isPresent {
            toView.transform = offScreenLeft
        }

        if isPresent {
            container.addSubview(fromView)
            container.addSubview(toView)
        } else {
            container.addSubview(toView)
            container.addSubview(fromView)
        }

        UIView.animate(withDuration: duration,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.8,
                options: [],
                animations: {
                    if self.isPresent {
                        toView.transform = CGAffineTransform.identity
                    } else {
                        fromView.transform = offScreenLeft
                    }
                }, completion: { finished in
                    transitionContext.completeTransition(true)
                })

    }
}
