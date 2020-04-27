//
//  NSObject+Extension.swift
//  TMLI-iOS
//
//  Created by Chris Ferdian on 27/04/20.
//  Copyright © 2020 Netzme. All rights reserved.
//

import Foundation

public protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

public extension ClassNameProtocol {
    static var className: String {
        return String(describing: self)
    }

    var className: String {
        return type(of: self).className
    }
}

extension NSObject: ClassNameProtocol {}
