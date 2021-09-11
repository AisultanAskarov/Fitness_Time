//
//  WorkoutView.swift
//  Fitness_Time
//
//  Created by Aisultan Askarov on 8.09.2021.
//

import UIKit

class WorkoutView: UIViewController {

    let slideIndicator: UIView = {
       
        let slideIndicator = UIView()
        slideIndicator.backgroundColor = UIColor.lightGray
        slideIndicator.layer.cornerRadius = slideIndicator.frame.height / 2
        
        return slideIndicator
    }()
    
    let workoutName: UILabel = {
       
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 25.0, weight: .bold)
        label.text = "Chest Workout"
        label.textAlignment = .left
        label.textColor = UIColor.white
        label.clipsToBounds = false
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOpacity = 0.25
        label.layer.shadowRadius = 2
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        return label
    }()
    
    var tableView: UITableView!
    var viewHeight: CGFloat!
    
    var exercises: [Exercises] = CoreDataStack().loadExercises()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.backgroundColor = UIColor.black
        
        view.addSubview(slideIndicator)
        view.addSubview(workoutName)
        
        viewHeight = view.frame.height
            
        tableView = UITableView()
        tableView.register(exerciseCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsHorizontalScrollIndicator = true
        tableView.isUserInteractionEnabled = true
        tableView.backgroundColor = UIColor.clear
        tableView.indicatorStyle = .default
        tableView.isPagingEnabled = false
        tableView.separatorStyle = .singleLine
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: workoutName.bottomAnchor, constant: 30).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        slideIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        slideIndicator.widthAnchor.constraint(equalToConstant: 40).isActive = true
        slideIndicator.heightAnchor.constraint(equalToConstant: 2.5).isActive = true
        slideIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        slideIndicator.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        
        workoutName.translatesAutoresizingMaskIntoConstraints = false
        
        workoutName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        workoutName.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        workoutName.sizeToFit()
        workoutName.topAnchor.constraint(equalTo: view.topAnchor, constant: 35).isActive = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        
    }
    
}

extension WorkoutView: UITableViewDelegate, UITableViewDataSource {
    
  
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return exercises.count
        
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! exerciseCell
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        cell.exerciseName.text = exercises[indexPath.row].exercise_name
        cell.repsTextField.text = exercises[indexPath.row].exercise_reps
        cell.weightTextField.text = exercises[indexPath.row].exercise_weight
        cell.repsTextField.tag = indexPath.row
        cell.repsTextField.delegate = cell.self
        cell.weightTextField.tag = indexPath.row
        cell.weightTextField.delegate = cell.self
        cell.id = exercises[indexPath.row].workoutId
        cell.exercises = exercises

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        print(exercises[indexPath.row].workoutId)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return viewHeight / 12
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
}
