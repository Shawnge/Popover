//
//  UIViewController+Popover.swift
//
//  Created by Shawnge on 2020/2/27.
//  Copyright © 2020 Shawnge. All rights reserved.
//

import UIKit

public struct AssociatedKeys {
    static var popoverManager: UInt8 = 0
}

public protocol PopoverPresentation: NSObjectProtocol {}
extension PopoverPresentation where Self: UIViewController {
    private var popoverManager: PopoverManager? {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.popoverManager) as? PopoverManager else {
                return nil
            }
            return value
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.popoverManager, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func popover(_ viewControllerToPresent: UIViewController,
                        preferredContentSize: CGSize = UIScreen.main.bounds.size,
                        transition: PopoverTransition = .slide(.bottom),
                        enableAutoDismiss: Bool = true,
                        animated flag: Bool = true,
                        completion: (() -> Void)? = nil) {
        self.popoverManager = PopoverManager(transition: transition, enableAutoDismiss: enableAutoDismiss, presented: viewControllerToPresent)
        viewControllerToPresent.modalPresentationStyle = .custom
        viewControllerToPresent.preferredContentSize = preferredContentSize
        viewControllerToPresent.transitioningDelegate = self.popoverManager
        present(viewControllerToPresent, animated: flag, completion: completion)
    } 
}
