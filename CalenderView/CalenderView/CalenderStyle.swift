//
//  CalenderStyle.swift
//  CalenderView
//
//  Created by Windy on 23/12/21.
//

import UIKit

struct CalenderStyle {
    
    var outOfRangeDate: UIColor = .systemGray
    var activeDate: ActiveDate = ActiveDate()
    var inActiveDate: InActiveDate = InActiveDate()
    
    struct ActiveDate {
        var textColor: UIColor = .systemBackground
        var backgroundColor: UIColor = .systemBlue
    }
    
    struct InActiveDate {
        var textColor: UIColor = .label
        var backgroundColor: UIColor = .systemBackground
    }
}
