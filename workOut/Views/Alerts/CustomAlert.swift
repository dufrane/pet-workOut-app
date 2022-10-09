//
//  CustomAlert.swift
//  workOut
//
//  Created by Dmytro Vasylenko on 05.10.2022.
//

import UIKit

class CustomAlert {
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        
        return view
    }()
    
    private let alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .specialBackground
        view.layer.cornerRadius = 20
        return view
    }()
    
    private var buttonAction: ((String, String) -> Void)?
    private let scrollView = UIScrollView()
    
    private var mainView: UIView?
    
    private let setTextField = UITextField()
    private let repsTextField = UITextField()
    
    func alertCustom(viewController: UIViewController, repsOrTimer: String,
                     completion: @escaping(String, String) -> Void ) {
        
        guard let parentView = viewController.view else { return }
        mainView = parentView
        
        scrollView.frame = parentView.frame
        parentView.addSubview(scrollView)
        
        backgroundView.frame = parentView.frame
        scrollView.addSubview(backgroundView)
        
        alertView.frame = CGRect(
            x: 40,
            y: -420,
            width: parentView.frame.width - 80,
            height: 420)
        
        scrollView.addSubview(alertView)
        
        let sportsmanImageView = UIImageView(frame: CGRect(
            x: (alertView.frame.width - alertView.frame.height * 0.4) / 2,
            y: 30,
            width: alertView.frame.height * 0.4,
            height: alertView.frame.height * 0.4))
        sportsmanImageView.image = UIImage(named: "sportsmanAlert")
        sportsmanImageView.contentMode = .scaleAspectFit
        alertView.addSubview(sportsmanImageView)
        
        let editingLabel = UILabel(frame: CGRect(
            x: 10 ,
            y: alertView.frame.height * 0.4 + 50,
            width: alertView.frame.width - 20,
            height: 25))
        editingLabel.text = "Editing"
        editingLabel.textAlignment = .center
        editingLabel.font = .robotoMedium22()
        alertView.addSubview(editingLabel)
        
        let setsLabel = UILabel(text: "Sets")
        setsLabel.translatesAutoresizingMaskIntoConstraints = true
        setsLabel.frame = CGRect(
            x: 30,
            y: editingLabel.frame.maxY + 10,
            width: alertView.frame.width - 60,
            height: 20)
        alertView.addSubview(setsLabel)
        
        setTextField.frame = CGRect(
            x: 20,
            y: setsLabel.frame.maxY,
            width: alertView.frame.width - 40,
            height: 30)
        
        setTextField.backgroundColor = .specialBrown
        setTextField.borderStyle = .none
        setTextField.layer.cornerRadius = 10
        setTextField.textColor = .specialGray
        setTextField.font = .robotoBold20()
        setTextField.leftView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: 15,
            height: setTextField.frame.height))
        setTextField.leftViewMode = .always
        setTextField.clearButtonMode = .always
        setTextField.returnKeyType = .done
        setTextField.keyboardType = .numberPad
        alertView.addSubview(setTextField)
        
        let repsOrTimerLabel = UILabel(text: repsOrTimer)
        repsOrTimerLabel.translatesAutoresizingMaskIntoConstraints = true
        repsOrTimerLabel.frame = CGRect(
            x: 30,
            y: setTextField.frame.maxY + 3,
            width: alertView.frame.width - 60,
            height: 20)
        alertView.addSubview(repsOrTimerLabel)
        
        repsTextField.frame = CGRect(
            x: 20,
            y: repsOrTimerLabel.frame.maxY,
            width: alertView.frame.width - 40,
            height: 30)
        
        repsTextField.backgroundColor = .specialBrown
        repsTextField.borderStyle = .none
        repsTextField.layer.cornerRadius = 10
        repsTextField.textColor = .specialGray
        repsTextField.font = .robotoBold20()
        repsTextField.leftView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: 15,
            height: setTextField.frame.height))
        repsTextField.leftViewMode = .always
        repsTextField.clearButtonMode = .always
        repsTextField.returnKeyType = .done
        repsTextField.keyboardType = .numberPad
        alertView.addSubview(repsTextField)
        
        let okButton = UIButton(frame: CGRect(
            x: 50,
            y: repsTextField.frame.maxY + 15,
            width: alertView.frame.width - 100,
            height: 35))
        okButton.backgroundColor = .specialGreen
        okButton.setTitle("OK", for: .normal)
        okButton.titleLabel?.textColor = .white
        okButton.titleLabel?.font = .robotoMedium18()
        okButton.layer.cornerRadius = 10
        okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        alertView.addSubview(okButton)
        
        buttonAction = completion
        
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 0.8
        } completion: { done in
            if done {
                UIView.animate(withDuration: 0.3) {
                    self.alertView.center = parentView.center
                }
            }
        }
    }
    
    @objc private func okButtonTapped() {
        
        guard let setsNumber = setTextField.text else { return }
        guard let repsNumber = repsTextField.text else { return }
        buttonAction?(setsNumber, repsNumber)
        
        guard let targetView = mainView else { return }
        
        UIView.animate(withDuration: 0.3) {
            self.alertView.frame = CGRect(x: 40,
                                          y: targetView.frame.height,
                                          width: targetView.frame.width - 80, height: 420)
        } completion: { done in
            if done {
                UIView.animate(withDuration: 0.3) {
                    self.backgroundView.alpha = 0
                } completion: { done in
                    if done {
                        self.alertView.removeFromSuperview()
                        self.backgroundView.removeFromSuperview()
                        self.scrollView.removeFromSuperview()
                        self.setTextField.text = ""
                        self.repsTextField.text = ""
                        
                    }
                }
            }
        }
    }
}
