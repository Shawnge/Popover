//
//  PopoverPresentationController.swift
//
//  Created by Shawnge on 2018/8/1.
//  Copyright © 2018 TY Co. .Ltd. All rights reserved.
//

import UIKit

class PopoverPresentationController: UIPresentationController {
    private let transition: PopoverTransition
    private let enableAutoDismiss: Bool
    fileprivate var dimmingView: UIView
    
    init(presentedViewController: UIViewController, presentingViewController: UIViewController?, transition: PopoverTransition, enableAutoDismiss: Bool = true) {
        self.transition = transition
        self.enableAutoDismiss = enableAutoDismiss
        self.dimmingView = UIView()
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupDimmingView()
    }
    
    override func presentationTransitionWillBegin() {
        
        // 1
        containerView?.insertSubview(dimmingView, at: 0)
        
        // 2
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimmingView]|",
                                           options: [], metrics: nil, views: ["dimmingView": dimmingView]))
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[dimmingView]|",
                                           options: [], metrics: nil, views: ["dimmingView": dimmingView]))
        
        //3
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func size(forChildContentContainer container: UIContentContainer,
                       withParentContainerSize parentSize: CGSize) -> CGSize {
        return self.presentedViewController.preferredContentSize;
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        
        //1
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController,
                          withParentContainerSize: containerView!.bounds.size)
        
        //2
        switch self.transition {
        case .slide(_):
            frame = SlideAnimator.frameOfPresentedViewInContainerView(from: frame, with: self.transition, containerView!)
        case .zoom:
            frame = ZoomAnimator.frameOfPresentedViewInContainerView(from: frame, with: self.transition, containerView!)
        case .fade:
            frame = FadeAnimator.frameOfPresentedViewInContainerView(from: frame, with: self.transition, containerView!)
        case .custom(let animator):
            frame = animator.frameOfPresentedViewInContainerView(from: frame, with: self.transition, containerView!)
        }
        return frame
    }
}

private extension PopoverPresentationController {
    func setupDimmingView() {
        dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.alpha = 0.0
        if enableAutoDismiss {
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
            dimmingView.addGestureRecognizer(recognizer)
        }
    }
    
    @objc dynamic func handleTap(recognizer: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true)
    }
}
