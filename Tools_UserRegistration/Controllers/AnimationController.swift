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
        
        animationSpin3D(x: 0, y: 1, with: transitionContext, viewToAnimateTo: viewToAnimateTo, viewToAnimateFrom: viewToAnimateFrom)
        
//        animationSpin(with: transitionContext, viewToAnimateTo: viewToAnimateTo, viewToAnimateFrom: viewToAnimateFrom)
    }
    
    //The guts of the animation for dismissal
    private func dismissAnimation(with transitionContext: UIViewControllerContextTransitioning,
                                  viewToAnimateTo: UIView, viewToAnimateFrom: UIView) {

        animationSpin3D(x: 0, y: 1, with: transitionContext, viewToAnimateTo: viewToAnimateFrom, viewToAnimateFrom: viewToAnimateTo)
        
//        animationSpin(with: transitionContext, viewToAnimateTo: viewToAnimateFrom, viewToAnimateFrom: viewToAnimateTo)
    }
}



// MARK: - Custom Animations

extension AnimationController {
    /**
     An animation that rotates the view 180 degrees about the xyz-axes, while transitioning into the next view.
     - parameters:
        - transitionContext: the UIViewControllerContextTransitioning
        - viewToAnimateTo: the destination view of the animation
        - viewToAnimateFrom: the source view of the animation
        - x: x-axis of rotation
        - y: y-axis of rotation
        - z: z-axis of rotation
     */
    private func animationSpin3D(x: CGFloat, y: CGFloat, with transitionContext: UIViewControllerContextTransitioning,
                                 viewToAnimateTo: UIView, viewToAnimateFrom: UIView) {
        
        let duration = transitionDuration(using: transitionContext)
        viewToAnimateTo.clipsToBounds = true
        viewToAnimateTo.layer.transform = CATransform3DMakeRotation(.pi / 2, x, y, 0)
        viewToAnimateTo.alpha = 1.0
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeLinear) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: duration / 2) {
                viewToAnimateFrom.layer.transform = CATransform3DMakeRotation(.pi / 2, x, y, 0)
            }
            
            UIView.addKeyframe(withRelativeStartTime: duration / 2, relativeDuration: duration / 2) {
                viewToAnimateTo.layer.transform = CATransform3DMakeRotation(0, x, y, 0)
            }
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
    
    /**
     An animation that rotates the view 180 degrees while transitioning into the next view.
     - parameters:
        - transitionContext: the UIViewControllerContextTransitioning
        - viewToAnimateTo: the destination view of the animation
        - viewToAnimateFrom: the source view of the animation
     */
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
    
    /**
     An animation that slides up/down into the next view.
     - parameters:
        - transitionContext: the UIViewControllerContextTransitioning
        - viewToAnimateTo: the destination view of the animation
        - viewToAnimateFrom: the source view of the animation
        - reverse: boolean to denote whether to slide up or down in the animation
     */
    private func animationSlideUp(with transitionContext: UIViewControllerContextTransitioning,
                                  viewToAnimateTo: UIView, viewToAnimateFrom: UIView, reverse: Bool = false) {
        
        viewToAnimateTo.clipsToBounds = true
        viewToAnimateTo.alpha = 1.0
        viewToAnimateTo.transform = CGAffineTransform(translationX: 0, y: viewToAnimateTo.frame.height * (reverse ? -1 : 1))
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3.0, options: .curveEaseOut) {
            viewToAnimateTo.transform = CGAffineTransform(translationX: 0, y: 0)
            viewToAnimateFrom.transform = CGAffineTransform(translationX: 0, y: viewToAnimateTo.frame.height * (reverse ? 1 : -1))
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
    
    /**
     An animation that dissolves into the next view.
     - parameters:
        - transitionContext: the UIViewControllerContextTransitioning
        - viewToAnimateTo: the destination view of the animation
        - viewToAnimateFrom: the source view of the animation
     */
    private func animationDissolve(with transitionContext: UIViewControllerContextTransitioning,
                                   viewToAnimateTo: UIView, viewToAnimateFrom: UIView) {
        
        viewToAnimateTo.clipsToBounds = true
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseIn) {
            viewToAnimateTo.alpha = 1.0
            viewToAnimateFrom.alpha = 0.0
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
    
    /**
     An animation that dissolves and bounces into the next view.
     - parameters:
        - transitionContext: the UIViewControllerContextTransitioning
        - viewToAnimateTo: the destination view of the animation
        - viewToAnimateFrom: the source view of the animation
     */
    private func animationBounce(with transitionContext: UIViewControllerContextTransitioning,
                                 viewToAnimateTo: UIView, viewToAnimateFrom: UIView) {
        
        let scaleMagnitude: CGFloat = 0.9
        let duration = transitionDuration(using: transitionContext)
        let dissolveDuration = duration / 8
        var dissolveDurationDelay: TimeInterval { 0.5 - dissolveDuration / 2 }
        
        viewToAnimateTo.clipsToBounds = true
        viewToAnimateTo.transform = CGAffineTransform(scaleX: scaleMagnitude, y: scaleMagnitude)
        
        UIView.animate(withDuration: duration / 2, delay: 0, options: .curveEaseOut, animations: {
            viewToAnimateFrom.transform = CGAffineTransform(scaleX: scaleMagnitude, y: scaleMagnitude)
        }, completion: nil)

        UIView.animate(withDuration: duration / 2, delay: duration / 2,
                       usingSpringWithDamping: 0.2, initialSpringVelocity: 2.0, options: .curveEaseInOut) {
            viewToAnimateFrom.alpha = 0.0
            viewToAnimateTo.alpha = 1.0
            viewToAnimateTo.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
    
    /**
     An animation that grows/shrinks from the bottom-right corner
     - parameters:
        - transitionContext: the UIViewControllerContextTransitioning
        - viewToAnimateTo: the destination view of the animation
        - viewToAnimateFrom: the source view of the animation
     */
    private func animationGrow(with transitionContext: UIViewControllerContextTransitioning,
                               viewToAnimateTo: UIView, viewToAnimateFrom: UIView) {

        let viewSize = viewToAnimateFrom.frame
        viewToAnimateTo.clipsToBounds = true
        viewToAnimateTo.transform = CGAffineTransform(scaleX: 0, y: 0)
        viewToAnimateTo.transform = CGAffineTransform(translationX: viewSize.width - viewToAnimateTo.frame.width, y: viewSize.height - viewToAnimateTo.frame.height)
        viewToAnimateTo.alpha = 1.0
        viewToAnimateFrom.alpha = 0

        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut) {
            viewToAnimateTo.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            viewToAnimateTo.transform = CGAffineTransform(translationX: 0, y: 0)
//            viewToAnimateFrom.transform = CGAffineTransform(scaleX: 0, y: 0)
//            viewToAnimateFrom.alpha = 0.0
        } completion: { _ in
            viewToAnimateFrom.alpha = 0
//            viewToAnimateFrom.transform = CGAffineTransform(scaleX: 0, y: 0)
//            viewToAnimateFrom.transform = CGAffineTransform(translationX: viewSize.width, y: viewSize.height)
            transitionContext.completeTransition(true)
        }
    }
}
