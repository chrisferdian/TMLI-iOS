//
//  ProductUserProvider.swift
//  TMLI-iOS
//
//  Created by Chris Ferdian on 26/04/20.
//  Copyright © 2020 Netzme. All rights reserved.
//

import CoreData
import RxSwift
import RxCocoa

class ProductUserProvider {
    
    fileprivate let usersFromCoreDate: BehaviorRelay<[ProductUser]> = BehaviorRelay(value: [])
    var managedObjectContext : NSManagedObjectContext
    
    init() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        usersFromCoreDate.accept([ProductUser]())
        managedObjectContext = delegate.persistentContainer.viewContext
        
        usersFromCoreDate.accept(fetchData())
    }
    
    // MARK: - fetching users from Core Data and update observable users
    private func fetchData() -> [ProductUser] {
        let productsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductUser")
        productsFetchRequest.returnsObjectsAsFaults = false
        
        do {
            return try managedObjectContext.fetch(productsFetchRequest) as! [ProductUser]
        } catch {
            return []
        }
    }
    
    // MARK: - return observable users
    public func fetchObservableData() -> Observable<[ProductUser]> {
        usersFromCoreDate.accept(fetchData())
        return usersFromCoreDate.asObservable()
    }
    
    // MARK: - add new user from Core Data
    public func addNewData(withUser productUser: ProductUser) {
        do {
            try managedObjectContext.save()
            usersFromCoreDate.accept(fetchData())
        } catch {
            fatalError("error saving data")
        }
    }
    
    // MARK: - remove specified user from Core Data
    public func removeUser(withIndex index: Int) {
        managedObjectContext.delete(usersFromCoreDate.value[index])
        
        do {
            try managedObjectContext.save()
            usersFromCoreDate.accept(fetchData())
        } catch {
            fatalError("error delete data")
        }
    }
    
    
    func updateUser(user: ProductUser, index: Int) {
        var temp = usersFromCoreDate.value
        temp[index] = user
        self.usersFromCoreDate.accept(temp)
        do {
            try managedObjectContext.save()
            usersFromCoreDate.accept(fetchData())
        } catch {
            fatalError("error change data")
        }
    }
}
