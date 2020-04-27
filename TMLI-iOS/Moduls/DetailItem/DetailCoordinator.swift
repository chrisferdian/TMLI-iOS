//
//  DashboardCoordinator.swift
//  TMLI-iOS
//
//  Created by Chris Ferdian on 16/04/20.
//  Copyright © 2020 Netzme. All rights reserved.
//

import UIKit

class DetailCoordinator : BaseCoordinator {

    var navigationController: UINavigationController?
    var parameters:ProductUser?
    var index: Int?
    
    init(navigationController :UINavigationController?) {
        self.navigationController = navigationController
    }

    override func start() {
        let viewModel = DetailViewModel(with: parameters, index: index)
        viewModel.index = index ?? 0
        let viewController = DetailViewController()
        viewController.viewModel = viewModel
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
