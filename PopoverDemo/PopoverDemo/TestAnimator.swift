//
//  TestAnimator.swift
//  PopoverDemo
//
//  Created by Shawnge on 2020/2/29.
//  Copyright © 2020 Cloud Link Co. .Ltd. All rights reserved.
//

import UIKit
import Popover

class TestAnimator: NSObject, Animator {
    
    var isPresentation: Bool
    
    required init(isPresentation: Bool) {
        self.isPresentation = isPresentation
    }
    
    static func frameOfPresentedViewInContainerView(from frame: CGRect, with transition: PopoverTransition, _ containerView: UIView) -> CGRect {
        var frame = frame;
        frame.origin.x = (containerView.frame.width - frame.size.width) / 2.0
        frame.origin.y = (containerView.frame.height - frame.size.height) / 2.0
        return frame;
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let key = isPresentation ? UITransitionContextViewControllerKey.to
            : UITransitionContextViewControllerKey.from
        
        let controller = transitionContext.viewController(forKey: key)!
        
        if isPresentation {
            transitionContext.containerView.addSubview(controller.view)
        }
        
        let initialAlpha: CGFloat = isPresentation ? 0.0 : 1.0
        let finalAlpha: CGFloat = isPresentation ? 1.0 : 0.0
        
        let animationDuration = transitionDuration(using: transitionContext)
        controller.view.alpha = initialAlpha
        UIView.animate(withDuration: animationDuration, animations: {
            controller.view.alpha = finalAlpha
        }) { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
