//
// Created by 周佳 on 2019-01-12.
// Copyright (c) 2019 AppCoda. All rights reserved.
//

import UIKit

class PopTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {

    let duration = 0.5

    var isPresent = false

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let fromView = transitionContext.view(forKey: .from) else { return }

        guard let toView = transitionContext.view(forKey: .to) else { return }

        let container = transitionContext.containerView

        let minmize = CGAffineTransform(scaleX: 0, y: 0)

        let offScreenDown = CGAffineTransform(translationX: 0, y: container.frame.height)

        let shiftDown = CGAffineTransform(translationX: 0, y: 15)

        let scaleDown = shiftDown.scaledBy(x: 0.95, y: 0.95)

        //变更toView的初始大小
        toView.transform = minmize

        //将两个视图加入container
        if isPresent {
            container.addSubview(fromView)
            container.addSubview(toView)
        } else {
            container.addSubview(toView)
            container.addSubview(fromView)
        }

        //执行动画
        UIView.animate(withDuration: duration,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.8,
                options: [],
                animations: {

                    if self.isPresent {

                        fromView.transform = scaleDown
                        fromView.alpha = 0.5
                        toView.transform = CGAffineTransform.identity

                    } else {

                        fromView.transform = offScreenDown
                        toView.alpha = 1.0
                        toView.transform = CGAffineTransform.identity

                    }


        }, completion: { finished in
            transitionContext.completeTransition(true)
        })

    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        isPresent = false
        return self
    }


}
