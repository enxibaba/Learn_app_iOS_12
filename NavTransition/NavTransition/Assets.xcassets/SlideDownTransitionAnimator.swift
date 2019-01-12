//
// Created by 周佳 on 2019-01-12.
// Copyright (c) 2019 AppCoda. All rights reserved.
//

import UIKit

class SlideDownTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning,
        UIViewControllerTransitioningDelegate {
    //设置转场时间为0.5
    let duration = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        //获取fromView、toView、contaier
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            return
        }

        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            return
        }

        let contaier = transitionContext.containerView

        let offScreenUp = CGAffineTransform(translationX: 0, y: -contaier.frame.height)

        let offScreenDown = CGAffineTransform(translationX: 0, y: contaier.frame.height)

        //首先让toView离开Contaier
        toView.transform = offScreenUp
        //将2个视图加入到contaier
        contaier.addSubview(fromView)
        contaier.addSubview(toView)

        UIView.animate(withDuration: duration,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.8,
                options: [], animations: {

            fromView.transform = offScreenDown
            fromView.alpha = 0.5
            toView.transform = CGAffineTransform.identity
            toView.alpha = 1.0

        },completion: { finished in

            transitionContext.completeTransition(true)
        })
    }
    

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}
