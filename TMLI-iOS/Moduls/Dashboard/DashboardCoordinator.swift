//
//  DashboardCoordinator.swift
//  TMLI-iOS
//
//  Created by Chris Ferdian on 16/04/20.
//  Copyright © 2020 Netzme. All rights reserved.
//

import UIKit

class DashboardCoordinator : BaseCoordinator {

    var navigationController: UINavigationController?

    init(navigationController :UINavigationController?) {
        self.navigationController = navigationController
    }

    override func start() {
        let viewController = DashboardViewController()
        viewController.delegate = self
        viewController.viewModel = DashboardViewModel()

        navigationController?.pushViewController(viewController, animated: true)
    }

    func showDetail(in navigationController: UINavigationController?, userProduct: ProductUser?) {
        let newCoordinator = DetailCoordinator(navigationController: navigationController)
        newCoordinator.parameters = userProduct
        self.store(coordinator: newCoordinator)
        newCoordinator.start()
    }
}

extension DashboardCoordinator: DashboardViewControllerDelegate {
    func userDidRequestItemDetail(userProduct: ProductUser?, index: Int?) {
        self.showDetail(in: navigationController, userProduct: userProduct)
    }
}
