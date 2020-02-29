//
//  PopoverInteractiveTransition.swift
//
//  Created by Shawnge on 2018/11/6.
//  Copyright © 2018 TY Co. .Ltd. All rights reserved.
//

import UIKit

class PopoverInteractiveTransition: UIPercentDrivenInteractiveTransition {
    var transitionInProgress = false
    
    private var presentedViewController: UIViewController
    private var direction: PopoverDirection
    private var shouldCompletion = false
    
    init(presented: UIViewController, direction: PopoverDirection) {
        self.presentedViewController = presented
        self.direction = direction
        super.init()
        self.completionCurve = .linear
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        presentedViewController.view.addGestureRecognizer(gesture)
    }
    
    @objc func panGestureAction(_ sender: UIPanGestureRecognizer) {
        let point = sender.translation(in: sender.view)
        switch sender.state {
        case .began:
            transitionInProgress = true
            presentedViewController.dismiss(animated: true, completion: nil)
        case .changed:
            var percent: Float = 0.0
            switch direction {
            case .top:
                if point.y <= 0.0 {
                    percent = fminf(fmaxf(Float(abs(point.y) / (sender.view?.bounds.height ?? presentedViewController.view.bounds.height)), 0.0), 1.0)
                }
            case .bottom:
                percent = fminf(fmaxf(Float(point.y / (sender.view?.bounds.height ?? presentedViewController.view.bounds.height)), 0.0), 1.0)
            }
            shouldCompletion = percent > 0.382
            self.update(CGFloat(percent))
        case .ended:
            transitionInProgress = false
            if !shouldCompletion {
                self.cancel()
            } else {
                self.finish()
            }
        case .cancelled:
            transitionInProgress = false
            self.cancel()
        default:
            print("default")
        }
    }
}
