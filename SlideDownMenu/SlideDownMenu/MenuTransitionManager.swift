//
// Created by 周佳 on 2019-01-13.
// Copyright (c) 2019 AppCoda. All rights reserved.
//

import UIKit

class MenuTransitionManager: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    let duration = 0.5

    var ispresent = false

    var delegate: MenuTransitionManagerDelegate?


    var snapshot: UIView? {

        didSet {

            if let delegate = delegate {

                let tapGestureRecognizer = UITapGestureRecognizer(target: delegate, action: #selector(delegate.dismiss))

                snapshot?.addGestureRecognizer(tapGestureRecognizer)
            }


        }

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

        let moveDown = CGAffineTransform(translationX: 0, y: container.frame.height - 150)

        let moveUp = CGAffineTransform(translationX: 0, y: -15)

        if ispresent {
            toView.transform = moveUp
            snapshot = fromView.snapshotView(afterScreenUpdates: true)
            container.addSubview(toView)
            container.addSubview(snapshot!)
        }

        UIView.animate(withDuration: duration,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.8,
                options: [],
                animations: { [weak self] in

                    guard let self = self else {
                        return
                    }

                    if self.ispresent {
                        self.snapshot?.transform = moveDown
                        toView.transform = CGAffineTransform.identity
                    } else {
                        self.snapshot?.transform = CGAffineTransform.identity
                        fromView.transform = moveUp
                    }
                },
                completion: { finished in
                    transitionContext.completeTransition(true)

                    if !self.ispresent {
                        self.snapshot?.removeFromSuperview()
                    }
                })
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        ispresent = true
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        ispresent = false
        return self
    }
}

@objc protocol MenuTransitionManagerDelegate {
    func dismiss()
}