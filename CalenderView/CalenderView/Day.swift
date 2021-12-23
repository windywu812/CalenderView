//
//  Day.swift
//  CalenderView
//
//  Created by Windy on 23/12/21.
//

import Foundation

struct Day: Equatable {
    let date: Date
    let dayNumber: String
    var isNextMonth: Bool = false
    var isPreviousMonth: Bool = false
}
