//
//  StatisticViewController.swift
//  workOut
//
//  Created by Dmytro Vasylenko on 22.09.2022.
//

import UIKit
import RealmSwift

struct DifferenceWorkout {
    let name: String
    let lastReps: Int
    let firstReps: Int
}

class StatisticViewController: UIViewController {
    
    private let statisticLabel: UILabel = {
        let label = UILabel()
        label.text = "STATISTIC"
        label.font = .robotoMedium24()
        label.textColor = .specialGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Week", "Month"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .specialGreen
        segmentedControl.selectedSegmentTintColor = .specialYellow
        let font = UIFont(name: "Roboto-Medium", size: 16)
        segmentedControl.setTitleTextAttributes([.font : font as Any,
                                                 .foregroundColor : UIColor.white],
                                                for: .normal)
        segmentedControl.setTitleTextAttributes([.font : font as Any,
                                                 .foregroundColor : UIColor.specialGray],
                                                for: .selected)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(segmentedChange), for: .valueChanged)
        return segmentedControl
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .none
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let exercisesLabel = UILabel(text: "Exercises")
    
    private let idStatisticTableViewCell = "idStatisticTableViewCell"
    
    private let localRealm = try! Realm()
    private var workoutArray: Results<WorkoutModel>!
    
    private var differenceArray = [DifferenceWorkout]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        setDelegates()
    }
    
    private func setupViews() {
        
        view.backgroundColor = .specialBackground
        
        view.addSubview(statisticLabel)
        view.addSubview(segmentedControl)
        view.addSubview(exercisesLabel)
        view.addSubview(tableView)
        tableView.register(StatisticTableViewCell.self,
                           forCellReuseIdentifier: idStatisticTableViewCell)
    }
    
    private func setDelegates() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc private func segmentedChange() {
        
        let dateToday = Date().localDate()
        differenceArray = [DifferenceWorkout]()
        
        if segmentedControl.selectedSegmentIndex == 0 {
            let dateStart = dateToday.offsetDays(days: 7)
            getDifferenceModel(dateStart: dateStart)
        } else {
            let dateStart = dateToday.offsetMonth(month: 1)
            getDifferenceModel(dateStart: dateStart)
        }
        tableView.reloadData()
    }
    
    private func getWorkoutsName() -> [String] {
        
        var nameArray = [String]()
        workoutArray = localRealm.objects(WorkoutModel.self)
        
        for workoutModel in workoutArray {
            if !nameArray.contains(workoutModel.workoutName){
                nameArray.append(workoutModel.workoutName)
            }
        }
        return nameArray
    }
    
    private func getDifferenceModel(dateStart: Date) {
        
        let dateEnd = Date().localDate()
        let nameArray = getWorkoutsName()
        
        for name in nameArray {
            
            let predicateDifference = NSPredicate(format: "workoutName = '\(name)' AND workoutDate BETWEEN %@", [dateStart, dateEnd])
            workoutArray = localRealm.objects(WorkoutModel.self).filter(predicateDifference).sorted(byKeyPath: "workoutDate")
            
            guard let last = workoutArray.last?.workoutReps,
                  let first = workoutArray.first?.workoutReps else { return
            }
            
            let differenceWorkout = DifferenceWorkout(name: name, lastReps: last, firstReps: first)
            
            differenceArray.append(differenceWorkout)
        }
    }
}

// MARK: - UITableViewDataSource

extension StatisticViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: idStatisticTableViewCell,
                                                       for: indexPath) as? StatisticTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
}

//MARK: - UITableViewDelegate

extension StatisticViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        55
    }
}

extension StatisticViewController {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            statisticLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            statisticLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: statisticLabel.bottomAnchor, constant: 10),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            exercisesLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            exercisesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            exercisesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: exercisesLabel.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}


