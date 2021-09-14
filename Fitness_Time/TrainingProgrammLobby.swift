//
//  TrainingProgrammLobby.swift
//  Fitness_Time
//
//  Created by Aisultan Askarov on 7.09.2021.
//

import UIKit
import CoreData

class TrainingProgrammLobby: UIViewController {

    var tableView: UITableView!
    var viewHeight: CGFloat!
    
    
    var titleName: String!
    var durationWeeks: String!
    var numberOfWorkouts: String!
    
    var programm: Programm!
    var trainingProgrammsUnchanged = CoreDataStack().loadProgramms()
    var workouts: [Workout] = []
    
    var daysToAdd: Int!
    
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
        label.text = "New Workout".Localized()
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
        button.addTarget(self, action: #selector(addWorkout), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    let TopSeparatorForTitle: UIView = {
       
        let slideIndicator = UIView()
        slideIndicator.backgroundColor = UIColor.lightGray.withAlphaComponent(0.65)
        slideIndicator.translatesAutoresizingMaskIntoConstraints = false

        return slideIndicator
    }()
    
    let workoutNameTextField: UITextField = {
       
        let textView = UITextField()
        textView.backgroundColor = UIColor.clear
        textView.font = UIFont.systemFont(ofSize: 17.5, weight: .semibold)
        textView.textAlignment = .right
        textView.textColor = UIColor.white
        textView.keyboardType = .default
        textView.text = ""
        textView.isUserInteractionEnabled = true
        textView.attributedPlaceholder = NSAttributedString(string: "Enter target muscle".Localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(1.0)])
        textView.addTarget(self, action: #selector(textDidChange), for: .editingChanged)

        return textView
    }()
    
    @objc func textDidChange(textField: UITextField) {
        
        if !workoutNameTextField.text!.isEmpty {
            
            popUpViewSaveButton.isEnabled = !workoutNameTextField.text!.isEmpty
            popUpViewSaveButton.backgroundColor = #colorLiteral(red: 0.1792228818, green: 0.8639443517, blue: 0.5618707538, alpha: 1)
            popUpViewSaveButton.isEnabled = true
            popUpViewSaveButton.clipsToBounds = false
            popUpViewSaveButton.layer.shadowColor = #colorLiteral(red: 0.1792228818, green: 0.8639443517, blue: 0.5618707538, alpha: 1).cgColor
            popUpViewSaveButton.layer.shadowOpacity = 0.35
            popUpViewSaveButton.layer.shadowRadius = 8
            popUpViewSaveButton.layer.shadowOffset = CGSize(width: 0, height: 0)
            
        } else if workoutNameTextField.text!.isEmpty {
            
            popUpViewSaveButton.isEnabled = false
            popUpViewSaveButton.backgroundColor = #colorLiteral(red: 0.1792228818, green: 0.8639443517, blue: 0.5618707538, alpha: 1).withAlphaComponent(0.5)
            popUpViewSaveButton.clipsToBounds = true
            
        }
        
        
    }
    
    let workoutNameStaticLabel: UILabel = {
           
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 16.5, weight: .medium)
        label.text = "Target Muscle:".Localized()
        label.textAlignment = .left
        label.textColor = UIColor.white
            
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewHeight = view.frame.height
        
        DataManagerBetweenWorkoutAndExercises.shared.firstVC = self
        
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
        
        
        let addPlan = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(animatePopUp))

        navigationItem.rightBarButtonItem = addPlan
        
        view.addSubview(popUpView)
        self.popUpView.frame = CGRect(x: 20, y: self.view.center.y + self.view.frame.height, width: self.view.frame.width - 40, height: self.view.frame.width + 50)
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
        navigationItem.title = titleName.Localized()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.barStyle = .black
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .darkContent
    }
    
    @objc func addWorkout() {
        
        let calendar = Calendar.current
        let weekRange = calendar.range(of: .weekOfYear, in: .year, for: Date())
        let currentWeek = calendar.component(.weekOfYear, from: Date()) - 2
        let weeks = Array(currentWeek ... (weekRange!.upperBound) - 2)

        let arrayOfPhotos = ["1", "2", "3", "4", "5", "6", "7", "8"]
        
        let daysToAdd = (weeks[0] - currentWeek) * 7
        let calendarForDayOfTheWeek = Calendar.current
        let daysRange = calendarForDayOfTheWeek.range(of: .day, in: .year, for: Date())
        let currentDay = calendarForDayOfTheWeek.ordinality(of: .day, in: .year, for: Date())! + daysToAdd
        let days = Array(currentDay ... (daysRange!.upperBound))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "eeee"
        
        let calendar1 = Calendar.current
        let today1 = calendar1.startOfDay(for: Date())
        let weekdays1 = calendar1.range(of: .weekday, in: .weekOfYear, for: today1)!
        let days1 = (weekdays1.lowerBound ..< weekdays1.upperBound)
            .compactMap { calendar1.date(byAdding: .day, value: $0, to: today1) }
        
        let strings = days1.map { formatter.string(from: $0) }
        
        let lastID = Int((workouts.last?.workout_id ?? "0"))! + 1
        
        do {
        
            let context = CoreDataStack.context
            let newWorkout = Workout(context: context)
            if workouts.count <= 0 {
            newWorkout.workout_id = "1"
            newWorkout.workout_date = "Day \(days[0]) | \(strings[0])"
            } else if workouts.count > 0 {
                newWorkout.workout_id = String(lastID)
                newWorkout.workout_date = "Day \(days[lastID]) | \(strings[lastID])"
            }
            newWorkout.workout_completed = false
            newWorkout.workout_image = arrayOfPhotos.randomElement()
            newWorkout.workout_target_muscles = workoutNameTextField.text
            newWorkout.workout_duration = "0"
                    
            for workout in workouts {
                
                for i in 0..<(workouts.count) {
                    
                    let id = Int(workout.workout_id!)! + 1
                    workouts[i].workout_id = String(id)
                    workouts[i].workout_date = "Day \(days[i + 1]) | \(strings[i + 1])"
                    
                }
                
            }
            
            programm.addToWorkouts(newWorkout)
        
            try CoreDataStack.context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        let vc = TrainingProgrammLobby()
        DataManager.shared.firstVC.trainingProgramms = CoreDataStack().loadProgramms().reversed()
        DataManager.shared.firstVC.trainingProgrammsUnchanged = CoreDataStack().loadProgramms().reversed()
        let workoutsToGet = DataManager.shared.firstVC.trainingProgramms[Int(programm.programm_id!)! - 1].workouts?.array as! [Workout]
        vc.workouts = workoutsToGet.reversed()
        tableView.reloadData()
        
        animatePopOut()
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    //MARK: -POPUP For new programm
    
    
    @objc func animatePopUp() {
        
        self.view.addSubview(blurViewController)
        self.view.addSubview(popUpView)
        self.popUpView.addSubview(popUpViewTitleLabel)
        self.popUpView.addSubview(popUpViewCancelButton)
        self.popUpView.addSubview(popUpViewSaveButton)
        self.popUpView.addSubview(TopSeparatorForTitle)
        self.popUpView.addSubview(workoutNameStaticLabel)
        self.popUpView.addSubview(workoutNameTextField)


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
        
        workoutNameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        workoutNameTextField.trailingAnchor.constraint(equalTo: popUpView.trailingAnchor, constant: -15).isActive = true
        workoutNameTextField.leadingAnchor.constraint(equalTo: workoutNameStaticLabel.trailingAnchor, constant: 10).isActive = true
        workoutNameTextField.topAnchor.constraint(equalTo: TopSeparatorForTitle.bottomAnchor, constant: 35).isActive = true
        workoutNameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        workoutNameStaticLabel.translatesAutoresizingMaskIntoConstraints = false
        
        workoutNameStaticLabel.leftAnchor.constraint(equalTo: popUpView.leftAnchor, constant: 15).isActive = true
        workoutNameStaticLabel.topAnchor.constraint(equalTo: TopSeparatorForTitle.bottomAnchor, constant: 35).isActive = true
        workoutNameStaticLabel.bottomAnchor.constraint(equalTo: workoutNameTextField.bottomAnchor).isActive = true
        workoutNameStaticLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        workoutNameStaticLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.315).isActive = true
        
        let toolBar =  UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        toolBar.barStyle = .default
        toolBar.sizeToFit()

        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonAction))
        toolBar.items = [doneButton]
        toolBar.isUserInteractionEnabled = true
        workoutNameTextField.inputAccessoryView = toolBar
        
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
        workoutNameTextField.endEditing(true)
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
            self.workoutNameStaticLabel.removeFromSuperview()
            self.workoutNameTextField.removeFromSuperview()

            self.blurViewController.removeAllConstraints()
            self.popUpViewTitleLabel.removeAllConstraints()
            self.popUpViewCancelButton.removeAllConstraints()
            self.popUpViewSaveButton.removeAllConstraints()
            self.TopSeparatorForTitle.removeAllConstraints()
            self.workoutNameStaticLabel.removeAllConstraints()
            self.workoutNameTextField.removeAllConstraints()
            
        }
        
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
        cell.targetMuscles.text = "Target Muscles: \(workouts[indexPath.section].workout_target_muscles ?? "")".Localized()
        cell.numberOfExercises.text = "Total Exercises: \(workouts[indexPath.section].exercises!.count)".Localized()
        cell.workoutImage.image = UIImage(named: workouts[indexPath.section].workout_image!)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        let presentVC = WorkoutView()
        presentVC.exercises = workouts[indexPath.section].exercises?.array as! [Exercises]
        presentVC.workoutId = Int(workouts[indexPath.section].workout_id!)
        presentVC.workout = workouts[indexPath.section]
        presentVC.workoutName.text = "\(workouts[indexPath.section].workout_target_muscles ?? "") Workout"
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
