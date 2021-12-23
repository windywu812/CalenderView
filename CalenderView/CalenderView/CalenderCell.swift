//
//  CalenderCell.swift
//  TU-Clone
//
//  Created by Windy on 06/08/21.
//

import UIKit

class CalenderCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = String(describing: CalenderCell.self)
    
    private var style: CalenderStyle!
    private var day: Day!
    private var label: UILabel!
    private var backgroundLabel: UIView!
    
    func configureCell(day: Day, isSelected: Bool, style: CalenderStyle) {
        self.day = day
        self.style = style
        label.text = day.dayNumber
        label.textColor = !self.day.isNextMonth && !self.day.isPreviousMonth ? style.activeDate.textColor : style.outOfRangeDate
        setupLabelState(isSelected: isSelected)
    }
    
    override var isSelected: Bool {
        didSet {
            setupLabelState(isSelected: isSelected)
        }
    }
    
    private func setupLabelState(isSelected: Bool) {
        UIView.animate(withDuration: 0.2) {
            if isSelected {
                let style = self.style.activeDate
                self.backgroundLabel.layer.backgroundColor = style.backgroundColor.cgColor
                self.label.textColor = style.textColor
            } else {
                guard !self.day.isNextMonth && !self.day.isPreviousMonth else { return }
                let style = self.style.inActiveDate
                self.label.textColor = style.textColor
                self.backgroundLabel.layer.backgroundColor = style.backgroundColor.cgColor
                
                if self.day.date.shortDateFormat == Date().shortDateFormat {
                    self.label.textColor = self.style.activeDate.backgroundColor
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        label.textColor = style.inActiveDate.textColor
        backgroundLabel.backgroundColor = style.inActiveDate.backgroundColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundLabel = UIView()
        backgroundLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundLabel)
        
        label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            backgroundLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            backgroundLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            backgroundLabel.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            backgroundLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
        ])
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundLabel.layer.cornerRadius = bounds.height * 0.8 / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
