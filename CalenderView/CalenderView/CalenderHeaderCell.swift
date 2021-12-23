//
//  CalenderHeaderCell.swift
//  CalenderView
//
//  Created by Windy on 23/12/21.
//

import UIKit

class CalenderHeaderCell: UICollectionReusableView {
    
    static let identifier: String = String(describing: CalenderHeaderCell.self)
    
    private var mainStack: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        mainStack = UIStackView()
        mainStack.axis = .horizontal
        mainStack.distribution = .equalCentering
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        Calendar.current.shortWeekdaySymbols.forEach { day in
            let label = UILabel()
            label.text = day
            label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            label.widthAnchor.constraint(equalToConstant: bounds.width / 7).isActive = true
            mainStack.addArrangedSubview(label)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
