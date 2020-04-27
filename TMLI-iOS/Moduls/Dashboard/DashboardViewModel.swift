//
//  DashboardViewModel.swift
//  TMLI-iOS
//
//  Created by Chris Ferdian on 27/04/20.
//  Copyright © 2020 Netzme. All rights reserved.
//

import Foundation
import RxSwift
import CoreData
import RxCocoa

class DashboardViewModel {
    
    fileprivate var users: BehaviorRelay<[ProductUser]> = BehaviorRelay(value: [])
    fileprivate var productProvider = ProductUserProvider()
    let disposeBag = DisposeBag()

    init() {
        fetchUsersAndUpdateObservableUsers()
    }
    
    func reload() {
        fetchUsersAndUpdateObservableUsers()
    }
    
    public func getUsers() -> BehaviorRelay<[ProductUser]> {
        return users
    }
    
    // MARK: - fetching Users from Core Data and update observable users
    private func fetchUsersAndUpdateObservableUsers() {
        productProvider.fetchObservableData()
            .map({ $0 })
            .subscribe(onNext : { (todos) in
                self.users.accept(todos)
            })
        .disposed(by: disposeBag)
    }
    
    
    // MARK: - remove specified todo from Core Data
    public func removeUser(withIndex index: Int) {
        productProvider.removeUser(withIndex: index)
    }
}
