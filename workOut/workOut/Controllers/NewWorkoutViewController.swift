//
//  NewWorkoutViewController.swift
//  workOut
//
//  Created by Dmytro Vasylenko on 23.09.2022.
//

import UIKit

class NewWorkoutViewController: UIViewController {
    
    private let newWorkoutLabel: UILabel = {
        let label = UILabel()
        label.text = "NEW WORKOUT"
        label.font = .robotoMedium24()
        label.textColor = .specialGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "closeButton"), for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .specialBrown
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10
        textField.textColor = .specialGray
        textField.font = .robotoBold16()
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0,
                                                  width: 15,
                                                  height: textField.frame.height))
        textField.leftViewMode = .always
        textField.clearButtonMode = .always
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.tintColor = .specialGreen
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    private let testSwitch: UISwitch = {
       let testSwitch = UISwitch()
        testSwitch.isOn = true
        testSwitch.onTintColor = .specialGreen
        testSwitch.translatesAutoresizingMaskIntoConstraints = false
        return testSwitch
    }()
    
    private lazy var slider: UISlider = {
       let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 10
        slider.maximumTrackTintColor = .specialLightBrown
        slider.minimumTrackTintColor = .specialGreen
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(changeValueSlider), for: .valueChanged)
        return slider
    }()
    
    private let nameLabel = UILabel(text: "Name")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()

    }
    
    private func setupViews() {
        
        view.backgroundColor = .specialBackground
        
        view.addSubview(newWorkoutLabel)
        view.addSubview(closeButton)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        
        view.addSubview(datePicker)
        view.addSubview(testSwitch)
        view.addSubview(slider)
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func changeValueSlider() {
        print(slider.value)
    }
}

extension NewWorkoutViewController {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            newWorkoutLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            newWorkoutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.centerYAnchor.constraint(equalTo: newWorkoutLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: newWorkoutLabel.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            nameLabel.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: -20)
        ])
    
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3 ),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 38),
        ])
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            testSwitch.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            testSwitch.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            slider.topAnchor.constraint(equalTo: testSwitch.bottomAnchor, constant: 20),
            slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            slider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
    }
}
    
    
