//
//  UIViewController+Extension.swift
//  TMLI-iOS
//
//  Created by Chris Ferdian on 16/04/20.
//  Copyright © 2020 Netzme. All rights reserved.
//

import UIKit

extension UIViewController {
    func setupNavigationBarRightItems(items: UIBarButtonItem...) {
        self.navigationItem.rightBarButtonItems = items
    }

    func setupNavigationBarLeftItems(items: UIBarButtonItem...) {
        self.navigationItem.leftBarButtonItems = items
    }
}
extension Date {
    var age: Int { Calendar.current.dateComponents([.year], from: self, to: Date()).year! }
}
