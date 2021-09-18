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
    
    let addExerciseButton: UIButton = {
        
        let button = UIButton()
        
        button.backgroundColor = UIColor.clear
        button.setTitle("+", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.gray.withAlphaComponent(0.5), for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 40.0, weight: .thin)
        button.titleLabel?.textAlignment = .center
        button.isUserInteractionEnabled = true
        button.isEnabled = true
        button.addTarget(self, action: #selector(animatePopUp), for: .touchUpInside)
        
        return button
    }()
    
    var tableView: UITableView!
    var viewHeight: CGFloat!
    
    var workoutId: Int!
    var workout: Workout!
    var exercises: [Exercises] = []
    
    let blurViewController: UIView = {
       
        let visualEffectView = UIView()
        visualEffectView.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
                
        return visualEffectView
    }()
    
    @objc let popUpView: UIView = {
       
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        view.layer.cornerRadius = 15
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.clipsToBounds = false
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 7.5
        view.layer.shadowColor = UIColor.black.cgColor
        
        return view
    }()
    
    let popUpViewTitleLabel: UILabel = {
       
        let label = UILabel()
        label.text = "New Exercise".Localized()
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
            
        return label
    }()
    
    let popUpViewCancelButton: UIButton = {
       
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 0
        button.setImage(UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20.5, weight: .bold)), for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(animatePopOut), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    let popUpViewSaveButton: UIButton = {
       
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.1792228818, green: 0.8639443517, blue: 0.5618707538, alpha: 1)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.gray, for: .highlighted)
        button.layer.cornerRadius = 0
        button.setTitle("Add".Localized(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.5, weight: .medium)
        button.addTarget(self, action: #selector(addExercise), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    let TopSeparatorForTitle: UIView = {
       
        let slideIndicator = UIView()
        slideIndicator.backgroundColor = UIColor.lightGray.withAlphaComponent(0.65)
        slideIndicator.translatesAutoresizingMaskIntoConstraints = false

        return slideIndicator
    }()
    
    let exerciseNameTextField: UITextField = {
       
        let textView = UITextField()
        textView.backgroundColor = UIColor.clear
        textView.font = UIFont.systemFont(ofSize: 17.5, weight: .semibold)
        textView.textAlignment = .right
        textView.textColor = UIColor.white
        textView.keyboardType = .default
        textView.text = ""
        textView.isUserInteractionEnabled = true
        textView.attributedPlaceholder = NSAttributedString(string: "Enter exercise".Localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(1.0)])
        textView.addTarget(self, action: #selector(textDidChange), for: .editingChanged)

        return textView
    }()
    
    let exerciseNameStaticLabel: UILabel = {
           
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 16.5, weight: .medium)
        label.text = "Exercise:".Localized()
        label.textAlignment = .left
        label.textColor = UIColor.white
            
        return label
    }()
    
    @objc func textDidChange(textField: UITextField) {
        
        if !exerciseNameTextField.text!.isEmpty {
            
            popUpViewSaveButton.isEnabled = !exerciseNameTextField.text!.isEmpty
            popUpViewSaveButton.backgroundColor = #colorLiteral(red: 0.1792228818, green: 0.8639443517, blue: 0.5618707538, alpha: 1)
            popUpViewSaveButton.isEnabled = true
            popUpViewSaveButton.clipsToBounds = false
            popUpViewSaveButton.layer.shadowColor = #colorLiteral(red: 0.1792228818, green: 0.8639443517, blue: 0.5618707538, alpha: 1).cgColor
            popUpViewSaveButton.layer.shadowOpacity = 0.35
            popUpViewSaveButton.layer.shadowRadius = 8
            popUpViewSaveButton.layer.shadowOffset = CGSize(width: 0, height: 0)
            
        } else if exerciseNameTextField.text!.isEmpty {
            
            popUpViewSaveButton.isEnabled = false
            popUpViewSaveButton.backgroundColor = #colorLiteral(red: 0.1792228818, green: 0.8639443517, blue: 0.5618707538, alpha: 1).withAlphaComponent(0.5)
            popUpViewSaveButton.clipsToBounds = true
            
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.backgroundColor = UIColor.black
        
        view.addSubview(slideIndicator)
        view.addSubview(workoutName)
        view.addSubview(addExerciseButton)
        
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
        
        addExerciseButton.translatesAutoresizingMaskIntoConstraints = false
        
        addExerciseButton.sizeToFit()
        addExerciseButton.centerYAnchor.constraint(equalTo: workoutName.centerYAnchor).isActive = true
        addExerciseButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true

        view.addSubview(popUpView)
        self.popUpView.frame = CGRect(x: 20, y: self.view.center.y + self.view.frame.height, width: self.view.frame.width - 40, height: self.view.frame.width + 50)
        
    }
    
    @objc func addExercise() {
        
        do {
        
            let context = CoreDataStack.context
            let newExercise = Exercises(context: context)
            newExercise.exercise_name = exerciseNameTextField.text
            newExercise.exercise_reps = "0"
            newExercise.exercise_weight = "0"
            newExercise.workoutId = 1
            
            workout.addToExercises(newExercise)
        
            try CoreDataStack.context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        let vc = TrainingProgrammLobby()
        DataManager.shared.firstVC.trainingProgramms = CoreDataStack().loadProgramms().reversed()
        DataManager.shared.firstVC.trainingProgrammsUnchanged = CoreDataStack().loadProgramms().reversed()
        let workoutsToGet = DataManager.shared.firstVC.trainingProgramms[Int(DataManagerBetweenWorkoutAndExercises.shared.firstVC.programm.programm_id!)! - 1].workouts?.array as! [Workout]
        vc.workouts = workoutsToGet.reversed()
        DataManagerBetweenWorkoutAndExercises.shared.firstVC.tableView.reloadData()

        dismiss(animated: true, completion: nil)
        
        animatePopOut()
        
    }
    
    @objc func animatePopUp() {
        
        self.view.addSubview(blurViewController)
        self.view.addSubview(popUpView)
        self.popUpView.addSubview(popUpViewTitleLabel)
        self.popUpView.addSubview(popUpViewCancelButton)
        self.popUpView.addSubview(popUpViewSaveButton)
        self.popUpView.addSubview(TopSeparatorForTitle)
        self.popUpView.addSubview(exerciseNameStaticLabel)
        self.popUpView.addSubview(exerciseNameTextField)


        popUpViewSaveButton.backgroundColor = #colorLiteral(red: 0.1792228818, green: 0.8639443517, blue: 0.5618707538, alpha: 1).withAlphaComponent(0.5)
        popUpViewSaveButton.isEnabled = false
        
        blurViewController.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        blurViewController.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        blurViewController.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        blurViewController.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        blurViewController.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            
        popUpViewTitleLabel.topAnchor.constraint(equalTo: popUpView.topAnchor, constant: 20).isActive = true
        popUpViewTitleLabel.leadingAnchor.constraint(equalTo: popUpView.leadingAnchor).isActive = true
        popUpViewTitleLabel.trailingAnchor.constraint(equalTo: popUpView.trailingAnchor).isActive = true
        popUpViewTitleLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        popUpViewCancelButton.topAnchor.constraint(equalTo: popUpView.topAnchor, constant: 20).isActive = true
        popUpViewCancelButton.rightAnchor.constraint(equalTo: popUpView.rightAnchor, constant: -20).isActive = true
        popUpViewCancelButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        popUpViewCancelButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        popUpViewSaveButton.bottomAnchor.constraint(equalTo: popUpView.bottomAnchor, constant: -20).isActive = true
        popUpViewSaveButton.leadingAnchor.constraint(equalTo: popUpView.leadingAnchor, constant: 40).isActive = true
        popUpViewSaveButton.trailingAnchor.constraint(equalTo: popUpView.trailingAnchor, constant: -40).isActive = true
        popUpViewSaveButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        popUpViewSaveButton.layer.cornerRadius = 27.5
        
        TopSeparatorForTitle.leadingAnchor.constraint(equalTo: popUpView.leadingAnchor).isActive = true
        TopSeparatorForTitle.trailingAnchor.constraint(equalTo: popUpView.trailingAnchor).isActive = true
        TopSeparatorForTitle.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
        TopSeparatorForTitle.topAnchor.constraint(equalTo: popUpViewTitleLabel.bottomAnchor, constant: 20).isActive = true
        
        exerciseNameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        exerciseNameTextField.trailingAnchor.constraint(equalTo: popUpView.trailingAnchor, constant: -15).isActive = true
        exerciseNameTextField.leadingAnchor.constraint(equalTo: exerciseNameStaticLabel.trailingAnchor, constant: 10).isActive = true
        exerciseNameTextField.topAnchor.constraint(equalTo: TopSeparatorForTitle.bottomAnchor, constant: 35).isActive = true
        exerciseNameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        exerciseNameStaticLabel.translatesAutoresizingMaskIntoConstraints = false
        
        exerciseNameStaticLabel.leftAnchor.constraint(equalTo: popUpView.leftAnchor, constant: 15).isActive = true
        exerciseNameStaticLabel.topAnchor.constraint(equalTo: TopSeparatorForTitle.bottomAnchor, constant: 35).isActive = true
        exerciseNameStaticLabel.bottomAnchor.constraint(equalTo: exerciseNameTextField.bottomAnchor).isActive = true
        exerciseNameStaticLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        exerciseNameStaticLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.315).isActive = true
        
        let toolBar =  UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        toolBar.barStyle = .default
        toolBar.sizeToFit()

        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(doneButtonAction))
        toolBar.items = [doneButton]
        toolBar.isUserInteractionEnabled = true
        exerciseNameTextField.inputAccessoryView = toolBar
        
        UIView.animate(withDuration: 0.3) {
            
            self.blurViewController.backgroundColor = UIColor.black.withAlphaComponent(0.25)
            self.popUpView.alpha = 1
            self.tabBarController?.tabBar.alpha = 0
            self.popUpView.transform = CGAffineTransform.identity
            
            self.popUpView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: self.view.frame.width + 50)
            self.popUpView.center = self.view.center
            
        }
        
    }
    
    @objc func doneButtonAction() {
        exerciseNameTextField.endEditing(true)
    }
    
    @objc func animatePopOut() {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.popUpView.frame = CGRect(x: 20, y: self.view.center.y + self.view.frame.height, width: self.view.frame.width - 40, height: self.view.frame.width + 50)

        }) { (success: Bool) in
            
            self.blurViewController.backgroundColor = UIColor.clear
            self.popUpView.removeFromSuperview()
            self.blurViewController.removeFromSuperview()
            self.popUpViewTitleLabel.removeFromSuperview()
            self.popUpViewCancelButton.removeFromSuperview()
            self.popUpViewSaveButton.removeFromSuperview()
            self.TopSeparatorForTitle.removeFromSuperview()
            self.exerciseNameStaticLabel.removeFromSuperview()
            self.exerciseNameTextField.removeFromSuperview()

            self.blurViewController.removeAllConstraints()
            self.popUpViewTitleLabel.removeAllConstraints()
            self.popUpViewCancelButton.removeAllConstraints()
            self.popUpViewSaveButton.removeAllConstraints()
            self.TopSeparatorForTitle.removeAllConstraints()
            self.exerciseNameStaticLabel.removeAllConstraints()
            self.exerciseNameTextField.removeAllConstraints()
            
        }
        
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
        cell.exercise = exercises[indexPath.row]

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
