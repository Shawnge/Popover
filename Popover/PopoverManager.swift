//
//  PopoverManager.swift
//
//  Created by Shawnge on 2018/8/1.
//  Copyright © 2018 TY Co. .Ltd. All rights reserved.
//

import UIKit

public enum PopoverDirection {
    case top
    case bottom
}

public enum PopoverTransition {
    case slide(_ direction: PopoverDirection)
    case zoom
    case fade
    case custom(_ animator: Animator.Type)
}

public class PopoverManager: NSObject {
    private let transition: PopoverTransition;
    private let enableAutoDismiss: Bool
    private var interactionTransiton: PopoverInteractiveTransition?
    init(transition: PopoverTransition, enableAutoDismiss: Bool = true, presented: UIViewController? = nil) {
        self.transition = transition;
        self.enableAutoDismiss = enableAutoDismiss;
        
        super.init()
        
        switch transition {
        case .slide(let direction):
            if let presented = presented {
                interactionTransiton = PopoverInteractiveTransition(presented: presented, direction: direction)
            }
        default:
            print("不需要手势操作");
        }
    }
}

extension PopoverManager: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController =
            PopoverPresentationController(presentedViewController: presented, presentingViewController: presenting, transition: transition, enableAutoDismiss: enableAutoDismiss)
        return presentationController
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch self.transition {
        case .slide(let direction):
            return SlideAnimator(direction: direction, isPresentation: true)
        case .zoom:
            return ZoomAnimator(isPresentation: true)
        case .fade:
            return FadeAnimator(isPresentation: true)
        case .custom(let animator):
            return animator.init(isPresentation: true)
        }
    }
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch self.transition {
        case .slide(let direction):
            return SlideAnimator(direction: direction, isPresentation: false)
        case .zoom:
            return ZoomAnimator(isPresentation: false)
        case .fade:
            return FadeAnimator(isPresentation: false)
        case .custom(let animator):
            return animator.init(isPresentation: false)
        }
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if let transitionInProgress = self.interactionTransiton?.transitionInProgress {
            return transitionInProgress ? self.interactionTransiton : nil
        }
        return nil
    }
    
    //    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    //        return self.interactionTransiton.transitionInProgress ? self.interactionTransiton : nil
    //    }
}

extension PopoverManager: UIAdaptivePresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        //        if traitCollection.verticalSizeClass == .compact {
        //            return .overFullScreen
        //        } else {
        return .none
        //        }
    }
    //
    //    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
    //        guard style == .overFullScreen else { return nil }
    //
    //        return UIStoryboard(name: "Main", bundle: nil)
    //            .instantiateViewController(withIdentifier: "RotateViewController")
    //    }
}
