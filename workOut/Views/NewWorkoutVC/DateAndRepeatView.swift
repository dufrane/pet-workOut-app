//
//  DateAndRepeatView.swift
//  workOut
//
//  Created by Dmytro Vasylenko on 24.09.2022.
//

import UIKit

class DateAndRepeatView: UIView {

    private let datePicker: UIDatePicker = {
       let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.setValue(UIColor.specialDarkGreen, forKeyPath: "textColor")
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()

    private let repeatSwitch: UISwitch = {
        let repeatSwitch = UISwitch()
        repeatSwitch.isOn = true
        repeatSwitch.onTintColor = .specialGreen
        repeatSwitch.translatesAutoresizingMaskIntoConstraints = false
       return repeatSwitch
    }()
    
    private let dateLabel = UILabel(text: "Date",
                                    font: .robotoMedium18(),
                                    textColor: .specialGray)
    
    private let repeatLabel = UILabel(text: "Repeat every 7 days",
                                      font: .robotoMedium18(),
                                      textColor: .specialGray)
    
    private var dateStackView = UIStackView()
    private var repeatStackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .specialBrown
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false
        
        dateStackView = UIStackView(arrangedSubviews: [dateLabel,
                                                       datePicker],
                                    axis: .horizontal,
                                    spacing: 30)
        addSubview(dateStackView)
        
        repeatStackView = UIStackView(arrangedSubviews: [repeatLabel, repeatSwitch],
                                      axis: .horizontal,
                                      spacing: 10)
        addSubview(repeatStackView)
    }
    
    private func getDateAndRepeat() -> (Date, Bool) {
        (datePicker.date, repeatSwitch.isOn)
    }
    
    public func setDateAndRepeat() -> (Date, Bool) {
        getDateAndRepeat()
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            dateStackView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            dateStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            dateStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            dateStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            repeatStackView.topAnchor.constraint(equalTo: dateStackView.bottomAnchor, constant: 5),
            repeatStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            repeatStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
    }
}
