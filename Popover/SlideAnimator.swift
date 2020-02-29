//
//  SlideAnimator.swift
//
//  Created by Shawnge on 2018/8/1.
//  Copyright © 2018 TY Co. .Ltd. All rights reserved.
//

import UIKit

class SlideAnimator: NSObject {
    fileprivate var direction: PopoverDirection
    var isPresentation: Bool
    
    convenience init(direction: PopoverDirection, isPresentation: Bool) {
        self.init(isPresentation: isPresentation)
        self.direction = direction
    }
    
    required init(isPresentation: Bool) {
        self.direction = .top
        self.isPresentation = isPresentation
    }
}

extension SlideAnimator: Animator {
    static func frameOfPresentedViewInContainerView(from frame: CGRect, with transition: PopoverTransition, _ containerView: UIView) -> CGRect {
        var frame = frame
        switch transition {
        case .slide(let direction):
            switch direction {
            case .top:
                frame.origin.y = 0;
            case .bottom:
                frame.origin.y = containerView.frame.height - frame.size.height;
            }
        default:
            print("use origin frame")
        }
        return frame
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
        var dismissedFrame = presentedFrame
        switch direction {
        case .top:
            dismissedFrame.origin.y = -presentedFrame.height
        case .bottom:
            dismissedFrame.origin.y = transitionContext.containerView.frame.size.height
        }
        
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
