//
//  ZoomAnimator.swift
//
//  Created by Shawnge on 2020/2/27.
//  Copyright © 2020 Shawnge. All rights reserved.
//

import UIKit

class ZoomAnimator: NSObject {
    var isPresentation: Bool
    
    required init(isPresentation: Bool) {
        self.isPresentation = isPresentation;
        super.init()
    }
}

extension ZoomAnimator: Animator {
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
        
        let presentedFrame = transitionContext.finalFrame(for: controller)
        var dismissedFrame = CGRect.zero
        dismissedFrame.origin.x = presentedFrame.origin.x + presentedFrame.size.width / 2.0
        dismissedFrame.origin.y = presentedFrame.origin.y + presentedFrame.size.height / 2.0
        
        
        // 4
        let initialFrame = isPresentation ? dismissedFrame : presentedFrame
        let finalFrame = isPresentation ? presentedFrame : dismissedFrame
        
        // 5
        let animationDuration = transitionDuration(using: transitionContext)
        controller.view.frame = initialFrame
        UIView.animate(withDuration: animationDuration, animations: {
            controller.view.frame = finalFrame
        }) { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
}
