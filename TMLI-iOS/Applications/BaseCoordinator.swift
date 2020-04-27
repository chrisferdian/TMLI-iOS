//
//  BaseCoordinator.swift
//  TMLI-iOS
//
//  Created by Chris Ferdian on 16/04/20.
//  Copyright © 2020 Netzme. All rights reserved.
//

import Foundation

class BaseCoordinator : Coordinator {
    var childCoordinators : [Coordinator] = []
    var isCompleted: (() -> ())?

    func start() {
        fatalError("Children should implement `start`.")
    }
}
