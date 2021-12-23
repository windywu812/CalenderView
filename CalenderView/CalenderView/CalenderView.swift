//
//  CalenderView.swift
//  CalenderView
//
//  Created by Windy on 23/12/21.
//

import UIKit

class CalendarView: UIView {
    
    var didSelectDate: ((Day?) -> ())?
    var style: CalenderStyle = CalenderStyle()
    
    private var collectionView: UICollectionView!
    private var monthLabel: UILabel!
    private var selectedDate: Day? {
        didSet {
            didSelectDate?(selectedDate)
        }
    }
    private var currentMonthIndex: Int = 0 {
        didSet {
            generateCalender()
            collectionView.reloadData()
        }
    }
    private var currentMonth: Date!
    private var days: [Day] = []
    private var isInitial: Bool = true
    private let calendar = Calendar(identifier: .gregorian)
    
    private var addButton: UIButton!
    private var minusButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setupLabel()
        setupCV()
        setupContraints()
        generateCalender()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func generateCalender() {
     
        let initialDate = calendar.date(byAdding: .month, value: currentMonthIndex, to: Date())!
        currentMonth = initialDate
        
        let components = calendar.dateComponents([.year, .month], from: initialDate)
        
        let firstDayOfMonth = calendar.date(from: components)!
        let firstDayOfWeekday = calendar.dateComponents([.weekday], from: firstDayOfMonth).weekday ?? 0
        let totalDayInMonth = calendar.range(of: .day, in: .month, for: initialDate)?.count ?? 0
                
        days.removeAll()
        var offset: Int = 35

        for i in 1..<firstDayOfWeekday {
            let date = Date.addingDateIntervalByDay(day: -(firstDayOfWeekday - i), date: firstDayOfMonth)
            let day = Day(
                date: Date.addingDateIntervalByMonth(month: 0, date: date),
                dayNumber: date.getTheDayIndex,
                isPreviousMonth: true
            )
            days.append(day)
            offset -= 1
        }
        
        for i in 0..<totalDayInMonth {
            let date = Date.addingDateIntervalByDay(day: i, date: firstDayOfMonth)
            let day = Day(
                date: date,
                dayNumber: date.getTheDayIndex
            )
            days.append(day)
            offset -= 1
        }
        
        if offset > 0 {
            for i in 0..<offset {
                let date = Date.addingDateIntervalByDay(day: i, date: firstDayOfMonth)
                let day = Day(
                    date: Date.addingDateIntervalByMonth(month: 1, date: date),
                    dayNumber: date.getTheDayIndex,
                    isNextMonth: true
                )
                days.append(day)
                offset -= 1
            }
        }
        
        monthLabel.text = "\(initialDate.monthSymbols) \(initialDate.year)"
        
        if isInitial {
            selectedDate = days.filter({ $0.date.shortDateFormat == Date().shortDateFormat }).first
            isInitial = false
        }
        
        selectedDate = days.filter({ $0.date.shortDateFormat == selectedDate?.date.shortDateFormat }).first
    }
    
    private func setupLabel() {
        monthLabel = UILabel()
        monthLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(monthLabel)
      
        addButton = UIButton(type: .system)
        minusButton = UIButton(type: .system)

        if #available(iOS 13.0, *) {
            addButton.setImage(UIImage(systemName: "chevron.right.square.fill"), for: .normal)
            minusButton.setImage(UIImage(systemName: "chevron.backward.square.fill"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
        
        addButton.addTarget(self, action: #selector(handleTapPlus(sender:)), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(handleTapMinus(sender:)), for: .touchUpInside)
    }
    
    private func setupContraints() {
        
        let stack = UIStackView(arrangedSubviews: [minusButton, monthLabel, addButton])
        stack.distribution = .equalCentering
        stack.alignment = .center
        stack.axis = .horizontal
        addSubview(stack)
        
        minusButton.tintColor = .gray
        addButton.tintColor = .gray
        
        NSLayoutConstraint.activate([
            minusButton.widthAnchor.constraint(equalToConstant: 44),
            minusButton.heightAnchor.constraint(equalToConstant: 44),

            addButton.widthAnchor.constraint(equalToConstant: 44),
            addButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            stack.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupCV() {
      
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CalenderCell.self, forCellWithReuseIdentifier: CalenderCell.reuseIdentifier)
        collectionView.register(CalenderHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CalenderHeaderCell.identifier)
        
        addSubview(collectionView)
    }
    
    @objc
    private func handleTapPlus(sender: UIBarButtonItem) {
        self.currentMonthIndex += 1
        self.selectedDate = nil
    }
    
    @objc
    private func handleTapMinus(sender: UIBarButtonItem) {
        self.currentMonthIndex -= 1
        self.selectedDate = nil
    }
            
}

extension CalendarView: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let day = days[indexPath.row]
        selectedDate = day
                
        if day.isNextMonth {
            self.currentMonthIndex += 1
        } else if day.isPreviousMonth {
            self.currentMonthIndex -= 1
        }
        
        collectionView.reloadData()
    }
    
}

extension CalendarView: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalenderCell.reuseIdentifier,
            for: indexPath) as! CalenderCell
        let day = days[indexPath.row]
        cell.configureCell(day: day, isSelected: day == selectedDate, style: style)
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: CalenderHeaderCell.identifier,
            for: indexPath) as! CalenderHeaderCell
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return days.count
    }
    
}

extension CalendarView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(
            width: collectionView.bounds.width / 7,
            height: collectionView.bounds.height / 6)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(
            width: collectionView.bounds.width,
            height: 32)
    }
    
}
