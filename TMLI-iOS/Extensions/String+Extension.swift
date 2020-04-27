//
//  String+Extension.swift
//  TMLI-iOS
//
//  Created by Chris Ferdian on 27/04/20.
//  Copyright © 2020 Netzme. All rights reserved.
//

import UIKit

extension String {

    func toDate(withFormat format: String = "dd-MM-yyyy")-> Date?{

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)

        return date

    }
    
    func hasPrefix<Prefix>(_ prefix: Prefix, caseSensitive: Bool) -> Bool where Prefix : StringProtocol {

        if caseSensitive { return self.hasPrefix(prefix) }
        return self.lowercased().hasPrefix(prefix.lowercased())
    }
}

extension Date {

    func toString(withFormat format: String = "EEEE, d MMMM yyyy") -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)

        return str
    }
}
