//
//  AnimationController.swift
//  Tools_UserRegistration
//
//  Created by Eddie Char on 9/3/21.
//

import UIKit

class AnimationController: NSObject {
    private let animationDuration: Double
    private let animationType: AnimationType
    
    enum AnimationType {
        case present, dismiss
    }
    
    init(animationDuration: Double, animationType: AnimationType) {
        self.animationDuration = animationDuration
        self.animationType = animationType
    }
}

extension AnimationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(exactly: animationDuration) ?? 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //check that this VC and the destination VC are valid. Otherwise, flag completeTransition false.
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from) else {
            transitionContext.completeTransition(false)
            return
        }
        
        toViewController.view.alpha = 0
        
        switch animationType {
        case .present:
            transitionContext.containerView.addSubview(toViewController.view)
            presentAnimation(with: transitionContext, viewToAnimateTo: toViewController.view, viewToAnimateFrom: fromViewController.view)
        case .dismiss:
            transitionContext.containerView.addSubview(toViewController.view)
            transitionContext.containerView.addSubview(fromViewController.view)
            dismissAnimation(with: transitionContext, viewToAnimateTo: fromViewController.view, viewToAnimateFrom: toViewController.view)
        }

    }
    
    //The guts of the animation for presenting
    private func presentAnimation(with transitionContext: UIViewControllerContextTransitioning,
                                  viewToAnimateTo: UIView, viewToAnimateFrom: UIView) {
        
        animationSlideUp(with: transitionContext, viewToAnimateTo: viewToAnimateTo, viewToAnimateFrom: viewToAnimateFrom)
    }
    
    //The guts of the animation for dismissal
    private func dismissAnimation(with transitionContext: UIViewControllerContextTransitioning,
                                  viewToAnimateTo: UIView, viewToAnimateFrom: UIView) {

        animationSlideUp(with: transitionContext, viewToAnimateTo: viewToAnimateFrom, viewToAnimateFrom: viewToAnimateTo, reverse: true)
    }
    
    
    // MARK: - Custom Animations
    
    private func animationSpin(with transitionContext: UIViewControllerContextTransitioning,
                               viewToAnimateTo: UIView, viewToAnimateFrom: UIView) {
        
        viewToAnimateTo.clipsToBounds = true
        viewToAnimateTo.transform = CGAffineTransform(rotationAngle: .pi)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut) {
            viewToAnimateTo.transform = CGAffineTransform(rotationAngle: 0)
            viewToAnimateTo.alpha = 1.0
            viewToAnimateFrom.transform = CGAffineTransform(rotationAngle: .pi)
            viewToAnimateFrom.alpha = 0.0
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
    
    private func animationSlideUp(with transitionContext: UIViewControllerContextTransitioning,
                                  viewToAnimateTo: UIView, viewToAnimateFrom: UIView, reverse: Bool = false) {
        
        viewToAnimateTo.clipsToBounds = true
        viewToAnimateTo.alpha = 1.0
        viewToAnimateTo.transform = CGAffineTransform(translationX: 0, y: viewToAnimateTo.frame.height * (reverse ? -1 : 1))
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseIn) {
            viewToAnimateTo.transform = CGAffineTransform(translationX: 0, y: 0)
            viewToAnimateFrom.transform = CGAffineTransform(translationX: 0, y: viewToAnimateTo.frame.height * (reverse ? 1 : -1))
        } completion: { _ in
            transitionContext.completeTransition(true)
        }

    }
}
