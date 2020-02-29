//
//  ViewController.swift
//  PopoverDemo
//
//  Created by Shawnge on 2020/2/27.
//  Copyright © 2020 Cloud Link Co. .Ltd. All rights reserved.
//

import UIKit
import Popover

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func slideTop(_ sender: Any) {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.yellow
        popover(vc, preferredContentSize: CGSize(width: UIScreen.main.bounds.size.width, height: 400), transition: .slide(.top), enableAutoDismiss: true, animated: true, completion: nil)
    }
    
    @IBAction func slideBottom(_ sender: Any) {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.purple
        popover(vc, preferredContentSize: CGSize(width: UIScreen.main.bounds.size.width, height: 400), transition: .slide(.bottom), enableAutoDismiss: true, animated: true, completion: nil)
    }
    
    @IBAction func zoom(_ sender: Any) {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.green
        popover(vc, preferredContentSize: CGSize(width: 300, height: 400), transition: .zoom, enableAutoDismiss: true, animated: true, completion: nil)
    }
    
    @IBAction func fade(_ sender: Any) {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.blue
        popover(vc, preferredContentSize: CGSize(width: 300, height: 400), transition: .fade, enableAutoDismiss: true, animated: true, completion: nil)
    }
    
    @IBAction func Custom(_ sender: Any) {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.systemPink
        popover(vc, preferredContentSize: CGSize(width: 300, height: 400), transition: .custom(TestAnimator.self), enableAutoDismiss: true, animated: true, completion: nil)
    }
}

extension ViewController: PopoverPresentation {}

