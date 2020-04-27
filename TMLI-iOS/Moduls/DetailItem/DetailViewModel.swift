//
//  DetailViewModel.swift
//  TMLI-iOS
//
//  Created by Chris Ferdian on 24/04/20.
//  Copyright © 2020 Netzme. All rights reserved.
//

import RxCocoa
import RxSwift
import CoreData

class DetailViewModel {
    var user: ProductUser?
    let disposable = DisposeBag()
    fileprivate var productProvider = ProductUserProvider()
    
    
    /**
     - UserInfo
     */
    var userName = BehaviorRelay(value: "")
    var userDoB = BehaviorRelay(value: "")
    
    /**
     - Product
     */
    var productSelection = BehaviorRelay(value: "")
    
    /**
     - Product Info
     */
    var activityType = BehaviorRelay(value: "")
    var activityDate = BehaviorRelay(value: "")
    var startTime = BehaviorRelay(value: "")
    var endTime = BehaviorRelay(value: "")
    var place = BehaviorRelay(value: "")
    var productCode = BehaviorRelay(value: "")
    var reason = BehaviorRelay(value: "")
    var planToStart = BehaviorRelay(value: "")
    var price = BehaviorRelay(value: "")
    var howLong = BehaviorRelay(value: "")
    var notes = BehaviorRelay(value: "")
    
    var index = 0
    
    init(with userProduct: ProductUser?, index: Int?) {
        self.user = userProduct
        if userProduct != nil {
            guard let user = userProduct else { return }
            self.index = index ?? 0
            userName.accept(user.name ?? "")
            userDoB.accept(user.dob?.toString(withFormat: "dd/MM/yyyy") ?? "")
            productSelection.accept(user.product ?? "")
            activityType.accept(user.productType ?? "")
            activityDate.accept(user.date?.toString(withFormat: "dd/MM/yyyy") ?? "")
            startTime.accept(user.startTime?.toString(withFormat: "dd/MM/yyyy") ?? "")
            endTime.accept(user.endTime?.toString(withFormat: "dd/MM/yyyy") ?? "")
            place.accept(user.place ?? "")
            productCode.accept(user.productCode ?? "")
            reason.accept(user.reason ?? "")
            planToStart.accept(user.planToStart?.toString(withFormat: "dd/MM/yyyy") ?? "")
            price.accept(String(format:"%f", user.price))
            howLong.accept(user.howLong ?? "")
            notes.accept(user.notes ?? "")
        }
    }
    
    // MARK: - add new user from Core Data
    public func addUser() {
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "ProductUser", into: productProvider.managedObjectContext) as! ProductUser
        newUser.date = activityDate.value.toDate()
        newUser.dob = userDoB.value.toDate()
        newUser.endTime = endTime.value.toDate(withFormat: "HH:mm")
        newUser.howLong = howLong.value
        newUser.name = userName.value
        newUser.notes = notes.value
        newUser.place = place.value
        newUser.planToStart = planToStart.value.toDate()
        newUser.price = Double(price.value) ?? 0
        newUser.product = productSelection.value
        newUser.productCode = productCode.value
        newUser.productType = activityType.value
        newUser.reason = reason.value
        newUser.startTime = startTime.value.toDate(withFormat: "HH:mm")
        productProvider.addNewData(withUser: newUser)
    }
    
    func updateUser() {
        user?.date = activityDate.value.toDate()
        user?.dob = userDoB.value.toDate()
        user?.endTime = endTime.value.toDate(withFormat: "HH:mm")
        user?.howLong = howLong.value
        user?.name = userName.value
        user?.notes = notes.value
        user?.place = place.value
        user?.planToStart = planToStart.value.toDate()
        user?.price = Double(price.value) ?? 0
        user?.product = productSelection.value
        user?.productCode = productCode.value
        user?.productType = activityType.value
        user?.reason = reason.value
        user?.startTime = startTime.value.toDate(withFormat: "HH:mm")
        productProvider.updateUser(user: user!, index: index)
    }
}
