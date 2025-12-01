//
//  DateFunc.swift
//  WalletBuddies
//
//  Created by lending on 11/16/25.
//

import Foundation

extension Date {
    var startOfMonth: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components)!
    }
    var endOfMonth: Date {
        let calendar = Calendar.current
        var comps = DateComponents()
        comps.month = 1
        comps.day = -1
        return calendar.date(byAdding: comps, to: self.startOfMonth)!
    }
}
