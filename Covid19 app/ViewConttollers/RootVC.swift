//
//  RootVC.swift
//  Covid19 app
//
//  Created by David T on 6/7/21.
//

import UIKit

final class RootVC: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainVC = MainViewController()
        viewControllers = [mainVC]
    }
}
