//
//  TimerWorkoutViewController.swift
//  workOut
//
//  Created by Dmytro Vasylenko on 05.10.2022.
//

import UIKit

class TimerWorkoutViewController: UIViewController {
    
    private let newWorkoutLabel: UILabel = {
        let label = UILabel()
        label.text = "START WORKOUT"
        label.font = .robotoMedium24()
        label.textColor = .specialGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var  closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "closeButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let ellipseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ellipse")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "1:35"
        label.textColor = .specialGray
        label.font = .robotoBold48()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var  finishButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .specialGreen
        button.layer.cornerRadius = 10
        button.setTitle("FINISH", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .robotoBold16()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let timerWorkoutParametersView = TimerWorkoutParametersView()
    
    private let detailsLabel = UILabel(text: "Details")
    
    var workoutModel = WorkoutModel()
    private let customAlert = CustomAlert()
    
    private var durationTimer = 0
    private var numberOfSet = 0
    private var shapeLayer = CAShapeLayer()
    private var timer = Timer()
    
    override func viewDidLayoutSubviews() {
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
        animationCircular()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        setDelegates()
        addTaps()
        setWorkoutParameters()
    }
    
    private func setDelegates() {
        timerWorkoutParametersView.cellNextSetTimerDelegate = self
    }
    
    private func setupViews() {
        view.backgroundColor = .specialBackground
        
        view.addSubview(newWorkoutLabel)
        view.addSubview(closeButton)
        view.addSubview(ellipseImageView)
        view.addSubview(timerLabel)
        view.addSubview(detailsLabel)
        view.addSubview(timerWorkoutParametersView)
        view.addSubview(finishButton)
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
        timer.invalidate()
    }
    
    @objc private func finishButtonTapped() {
        if numberOfSet == workoutModel.workoutSets {
            dismiss(animated: true)
            RealmManager.shared.updateStatusWorkoutModel(model: workoutModel)
        } else {
            alertOkCancel(title: "Warning",
                          message: "Finish your workout") {
                self.dismiss(animated: true)
            }
        }
    }
    
    private func addTaps() {
        let tapLabel = UITapGestureRecognizer(target: self, action: #selector(startTimer))
        timerLabel.isUserInteractionEnabled = true
        timerLabel.addGestureRecognizer(tapLabel)
    }
    
    @objc private func startTimer() {
        timerWorkoutParametersView.editingButton.isEnabled = false
        timerWorkoutParametersView.nextSetsButton.isEnabled = false
        
        if numberOfSet == workoutModel.workoutSets {
            alertOk(title: "Error", message: "Finish your workout")
        } else {
            basicAnimation()
            timer = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(timerAction),
                                         userInfo: nil,
                                         repeats: true)
        }
    }
    
    @objc private func timerAction() {
        durationTimer -= 1
        print(durationTimer)
        
        if durationTimer == 0 {
            timer.invalidate()
            durationTimer = workoutModel.workoutTimer
            
            numberOfSet += 1
            timerWorkoutParametersView.numberOfSetsLabel.text = "\(numberOfSet)/\(workoutModel.workoutSets)"
            
            timerWorkoutParametersView.editingButton.isEnabled = true
            timerWorkoutParametersView.nextSetsButton.isEnabled = true
        }
        
        let (min, sec) = durationTimer.convertSeconds()
        timerLabel.text = "\(min):\(sec.setZeroForSecond())"
    }
    
    private func setWorkoutParameters() {
        timerWorkoutParametersView.workoutNameLabel.text = workoutModel.workoutName
        timerWorkoutParametersView.numberOfSetsLabel.text = "\(numberOfSet)/\(workoutModel.workoutSets)"
        
        let(min, sec) = workoutModel.workoutTimer.convertSeconds()
        timerWorkoutParametersView.numberOfTimerLabel.text = "\(min) min \(sec) sec"
        timerLabel.text = "\(min):\(sec.setZeroForSecond())"
        durationTimer = workoutModel.workoutTimer
    }
}

//MARK: - NextSetTimerProtocol

extension TimerWorkoutViewController: NextSetTimerProtocol {
    
    func nextSetTimerTapped() {
        if numberOfSet < workoutModel.workoutSets {
            numberOfSet += 1
            timerWorkoutParametersView.numberOfSetsLabel.text = "\(numberOfSet)/\(workoutModel.workoutSets)"
        } else {
            alertOk(title: "Error", message: "Finish your workout")
        }
    }
    
    func editingTimerTapped() {
        customAlert.alertCustom(viewController: self,
                                repsOrTimer: "Timer of set") { [self] sets, timerOfSet in
            if sets != "" && timerOfSet != "" {
                guard let numberOfSets = Int(sets) else { return }
                guard let numberOfTimer = Int(timerOfSet) else { return }
                let (min, sec) = numberOfTimer.convertSeconds()
                timerWorkoutParametersView.numberOfSetsLabel.text = "\(numberOfSet)/\(sets)"
                timerWorkoutParametersView.numberOfTimerLabel.text = "\(min) min \(sec) sec"
                timerLabel.text = "\(min):\(sec.setZeroForSecond())"
                durationTimer = numberOfTimer
                RealmManager.shared.updateSetsTimerWorkoutModel(
                    model: workoutModel,
                    sets: numberOfSets,
                     timer: numberOfTimer)
            }
        }
    }
}

extension TimerWorkoutViewController {
    
    private func animationCircular() {
        
        let center = CGPoint(x: ellipseImageView.frame.width / 2,
                             y: ellipseImageView.frame.height / 2)
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        
        let circularPath = UIBezierPath(arcCenter: center,
                                        radius: ellipseImageView.frame.width / 2 - 10,
                                        startAngle: startAngle,
                                        endAngle: endAngle,
                                        clockwise: false)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.lineWidth = 21
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = .round
        shapeLayer.strokeColor = UIColor.specialGreen.cgColor
        ellipseImageView.layer.addSublayer(shapeLayer)
    }
    
    private func basicAnimation() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 0
        basicAnimation.duration = CFTimeInterval(durationTimer)
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = true
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }
}



//MARK: - SetConstraints
extension TimerWorkoutViewController {
    
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
            ellipseImageView.topAnchor.constraint(equalTo: newWorkoutLabel.bottomAnchor, constant: 20),
            ellipseImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ellipseImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            ellipseImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)
        ])
        
        NSLayoutConstraint.activate([
            timerLabel.leadingAnchor.constraint(equalTo: ellipseImageView.leadingAnchor, constant: 40),
            timerLabel.trailingAnchor.constraint(equalTo: ellipseImageView.trailingAnchor, constant: -40),
            timerLabel.centerYAnchor.constraint(equalTo: ellipseImageView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            detailsLabel.topAnchor.constraint(equalTo: ellipseImageView.bottomAnchor, constant: 20),
            detailsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            detailsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            timerWorkoutParametersView.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 5),
            timerWorkoutParametersView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            timerWorkoutParametersView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            timerWorkoutParametersView.heightAnchor.constraint(equalToConstant: 230)
        ])
        
        NSLayoutConstraint.activate([
            finishButton.topAnchor.constraint(equalTo: timerWorkoutParametersView.bottomAnchor, constant: 20),
            finishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            finishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            finishButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
}

