//
//  TrainingProgrammLobby.swift
//  Fitness_Time
//
//  Created by Aisultan Askarov on 7.09.2021.
//

import UIKit

class TrainingProgrammLobby: UIViewController {

    var tableView: UITableView!
    var viewHeight: CGFloat!
    
    
    var titleName: String!
    var durationWeeks: String!
    var numberOfWorkouts: String!
    
    var workouts: [Workout] = []
    
    var daysToAdd: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewHeight = view.frame.height
        
        setView()
        
        tableView = UITableView()
        tableView.register(WorkoutsCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsHorizontalScrollIndicator = true
        tableView.backgroundColor = UIColor.clear
        tableView.indicatorStyle = .default
        tableView.isPagingEnabled = false
        tableView.separatorStyle = .singleLine
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

    }
    
    func setView() {
        
        view.backgroundColor = UIColor.black
        view.clipsToBounds = true

        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = UIColor.black
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = titleName
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.barStyle = .black
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .darkContent
    }
    
}

//Extensions for TableView

extension TrainingProgrammLobby: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return workouts.count
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 55))
        returnedView.backgroundColor = .clear
        let label = UILabel(frame: CGRect(x: 20, y: 25, width: view.frame.width, height: 25))
        label.text = workouts[section].workout_date
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 20)
        label.clipsToBounds = false
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOpacity = 0.65
        label.layer.shadowRadius = 4
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        returnedView.addSubview(label)
        
        return returnedView
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WorkoutsCell
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        cell.workoutLabel.text = "\(workouts[indexPath.section].workout_target_muscles ?? "") Workout"
        cell.targetMuscles.text = "Target Muscles: \(workouts[indexPath.section].workout_target_muscles ?? "")"
        cell.numberOfExercises.text = "Total Exercises: \(workouts[indexPath.section].exercises!.count)"
        cell.workoutImage.image = UIImage(named: workouts[indexPath.section].workout_image!)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        let presentVC = WorkoutView()
        presentVC.exercises = workouts[indexPath.section].exercises?.array as! [Exercises]
        presentVC.modalPresentationStyle = .popover
        presentVC.hidesBottomBarWhenPushed = true
        self.present(presentVC, animated: true, completion: nil)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return viewHeight / 4.75
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
