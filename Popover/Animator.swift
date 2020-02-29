//
//  Animator.swift
//  PopoverDemo
//
//  Created by Shawnge on 2020/2/29.
//  Copyright © 2020 Cloud Link Co. .Ltd. All rights reserved.
//

import UIKit

public protocol Animator: UIViewControllerAnimatedTransitioning {
    var isPresentation: Bool { get set }
    
    init(isPresentation: Bool)
    
    static func frameOfPresentedViewInContainerView(from frame: CGRect, with transition: PopoverTransition, _ containerView: UIView) -> CGRect
}
