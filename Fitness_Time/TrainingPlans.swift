//
//  TrainingPlans.swift
//  Fitness_Time
//
//  Created by Gabriel on 4.09.2021.
//

import UIKit
import CoreData

class TrainingPlans: UIViewController, UINavigationBarDelegate {
    
    var tableView: UITableView!
    var cellID = "Cell"
    var viewHeight: CGFloat!
    var change = [NSManagedObject]()

    var trainingProgramms: [Programm] = CoreDataStack().loadProgramms().reversed()
    var trainingProgrammsUnchanged: [Programm] = CoreDataStack().loadProgramms().reversed()
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        
      return searchController.isActive && (!isSearchBarEmpty)
        
    }
    
    let sections: [String] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    //Add new programm elements
    
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
        label.text = "New Programm".Localized()
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
        button.addTarget(self, action: #selector(addProgramm), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    let TopSeparatorForTitle: UIView = {
       
        let slideIndicator = UIView()
        slideIndicator.backgroundColor = UIColor.lightGray.withAlphaComponent(0.65)
        slideIndicator.translatesAutoresizingMaskIntoConstraints = false

        return slideIndicator
    }()
    
    let programmNameTextField: UITextField = {
       
        let textView = UITextField()
        textView.backgroundColor = UIColor.clear
        textView.font = UIFont.systemFont(ofSize: 17.5, weight: .semibold)
        textView.textAlignment = .right
        textView.textColor = UIColor.white
        textView.keyboardType = .numberPad
        textView.text = ""
        textView.isUserInteractionEnabled = true
        textView.attributedPlaceholder = NSAttributedString(string: "Name your programm".Localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(1.0)])
        textView.addTarget(self, action: #selector(textDidChange), for: .editingChanged)

        return textView
    }()
    
    @objc func textDidChange(textField: UITextField) {
        
        if !programmNameTextField.text!.isEmpty {
            
            popUpViewSaveButton.isEnabled = !programmNameTextField.text!.isEmpty
            popUpViewSaveButton.backgroundColor = #colorLiteral(red: 0.1792228818, green: 0.8639443517, blue: 0.5618707538, alpha: 1)
            popUpViewSaveButton.isEnabled = true
            popUpViewSaveButton.clipsToBounds = false
            popUpViewSaveButton.layer.shadowColor = #colorLiteral(red: 0.1792228818, green: 0.8639443517, blue: 0.5618707538, alpha: 1).cgColor
            popUpViewSaveButton.layer.shadowOpacity = 0.35
            popUpViewSaveButton.layer.shadowRadius = 8
            popUpViewSaveButton.layer.shadowOffset = CGSize(width: 0, height: 0)
            
        } else if programmNameTextField.text!.isEmpty {
            
            popUpViewSaveButton.isEnabled = false
            popUpViewSaveButton.backgroundColor = #colorLiteral(red: 0.1792228818, green: 0.8639443517, blue: 0.5618707538, alpha: 1).withAlphaComponent(0.5)
            popUpViewSaveButton.clipsToBounds = true
            
        }
        
        
    }
    
    let programmNameStaticLabel: UILabel = {
           
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 16.5, weight: .medium)
        label.text = "Programm Name:".Localized()
        label.textAlignment = .left
        label.textColor = UIColor.white
            
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHeight = view.frame.height
        
        DataManager.shared.firstVC = self
        
        setView()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter the week".Localized()
        searchController.searchBar.backgroundColor = UIColor.clear
        searchController.searchBar.barTintColor = UIColor.white
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.delegate = self
        searchController.searchBar.showsCancelButton = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.keyboardType = .default
        searchController.searchBar.returnKeyType = .done
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField// Accessing Text Field in SearchBar to change typing text color
        textFieldInsideSearchBar?.textColor = UIColor.white
        
        definesPresentationContext = true
        
        tableView = UITableView()
        tableView.register(TrainingPlansCell.self, forCellReuseIdentifier: cellID)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsHorizontalScrollIndicator = true
        tableView.backgroundColor = UIColor.clear
        tableView.indicatorStyle = .default
        tableView.isPagingEnabled = false
        tableView.separatorStyle = .singleLine
        tableView.tableHeaderView = searchController.searchBar
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(popUpView)
        self.popUpView.frame = CGRect(x: 20, y: self.view.center.y + self.view.frame.height, width: self.view.frame.width - 40, height: self.view.frame.width + 50)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        setView()
        
    }
    
    func setView() {
        
        view.backgroundColor = UIColor.black
        view.clipsToBounds = true
        
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = UIColor.black
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.title = "Training Programms".Localized()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.barStyle = .black
        navigationItem.hidesBackButton = true
        
        let addPlan = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(animatePopUp))

        navigationItem.rightBarButtonItem = addPlan
        
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .darkContent
    }
    
    @objc func addProgramm() {
        
        //MARK: -Deleting all programms to rewrite dates
        ///
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Programm")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try CoreDataStack.persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: CoreDataStack.context)
        } catch let error as NSError {
            print(error)
        }
        ///
        
        let calendar = Calendar.current
        let weekRange = calendar.range(of: .weekOfYear, in: .year, for: Date())
        let currentWeek = calendar.component(.weekOfYear, from: Date()) - 2
        let weeks = Array(currentWeek ... (weekRange!.upperBound) - 2)
        let currentYear = calendar.component(.year, from: Date())
        
        let arrayOfPhotos = ["1", "2", "3", "4", "5", "6", "7", "8"]
        let firstProgrammId = Int((trainingProgrammsUnchanged.first?.programm_id)!)
        do {
        
            let context = CoreDataStack.context
            let newProgramm = Programm(context: context)
            newProgramm.programm_name = programmNameTextField.text
            newProgramm.programm_date = trainingProgrammsUnchanged.first?.programm_date
            newProgramm.programm_id = String(firstProgrammId!)
            newProgramm.programm_image = arrayOfPhotos.randomElement()
            newProgramm.programm_number_of_workouts = "0"
            newProgramm.programm_duration_weeks = "1"
        
            try CoreDataStack.context.save()

        } catch {
            print(error.localizedDescription)
        }
        
        //MARK: -Reuploading all the old plans with adjusted date
        
        do {
            
            for i in 0..<(trainingProgrammsUnchanged.count) {
                
                let context = CoreDataStack.context
                let newProgramm = Programm(context: context)
                newProgramm.setValue(trainingProgrammsUnchanged[i].programm_duration_weeks, forKey: "programm_duration_weeks")
                newProgramm.setValue(String(Int(trainingProgrammsUnchanged[i].programm_id!)! + 1), forKey: "programm_id")
                newProgramm.setValue(trainingProgrammsUnchanged[i].programm_image, forKey: "programm_image")
                newProgramm.setValue(trainingProgrammsUnchanged[i].programm_name, forKey: "programm_name")
                newProgramm.setValue(trainingProgrammsUnchanged[i].programm_number_of_workouts, forKey: "programm_number_of_workouts")
                newProgramm.setValue("Year \(currentYear) | Week \(weeks[i + 1])", forKey: "programm_date")
                
                let workouts = trainingProgrammsUnchanged[i].workouts?.array as! [Workout]

                for w in 0..<(workouts.count) {
                
                    let newWorkout = Workout(context: context)
                    
                    newWorkout.setValue(workouts[w].workout_id, forKey: "workout_id")
                    newWorkout.setValue(workouts[w].workout_image, forKey: "workout_image")
                    newWorkout.setValue(workouts[w].workout_duration, forKey: "workout_duration")
                    newWorkout.setValue(workouts[w].workout_completed, forKey: "workout_completed")
                    newWorkout.setValue(workouts[w].workout_target_muscles, forKey: "workout_target_muscles")

                    let daysToAdd = (weeks[i + 1] - currentWeek) * 7
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
                    
                    newWorkout.setValue("Day \(days[w]) | \(strings[w])", forKey: "workout_date")
                    
                    newProgramm.addToWorkouts(newWorkout)

                    let exercises = workouts[w].exercises?.array as! [Exercises]

                    for e in 0..<(exercises.count) {
                        
                        let newExercise = Exercises(context: context)
                        newExercise.setValue(exercises[e].exercise_name, forKey: "exercise_name")
                        newExercise.setValue(exercises[e].exercise_reps, forKey: "exercise_reps")
                        newExercise.setValue(exercises[e].exercise_weight, forKey: "exercise_weight")
                        newExercise.setValue(exercises[e].workoutId, forKey: "workoutId")
                        
                        newWorkout.addToExercises(newExercise)
                        
                    }
                    
                }
                                                                        
            }
            
            try CoreDataStack.context.save()

        } catch {
            print(error.localizedDescription)
        }
        
        trainingProgramms = CoreDataStack().loadProgramms().reversed()
        trainingProgrammsUnchanged = CoreDataStack().loadProgramms().reversed()
        tableView.reloadData()
        
        animatePopOut()
        
    }
    
    //MARK: -POPUP For new programm
    
    
    @objc func animatePopUp() {
        
        self.view.addSubview(blurViewController)
        self.view.addSubview(popUpView)
        self.popUpView.addSubview(popUpViewTitleLabel)
        self.popUpView.addSubview(popUpViewCancelButton)
        self.popUpView.addSubview(popUpViewSaveButton)
        self.popUpView.addSubview(TopSeparatorForTitle)
        self.popUpView.addSubview(programmNameStaticLabel)
        self.popUpView.addSubview(programmNameTextField)


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
        
        programmNameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        programmNameTextField.trailingAnchor.constraint(equalTo: popUpView.trailingAnchor, constant: -15).isActive = true
        programmNameTextField.leadingAnchor.constraint(equalTo: programmNameStaticLabel.trailingAnchor, constant: 10).isActive = true
        programmNameTextField.topAnchor.constraint(equalTo: TopSeparatorForTitle.bottomAnchor, constant: 35).isActive = true
        programmNameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        programmNameStaticLabel.translatesAutoresizingMaskIntoConstraints = false
        
        programmNameStaticLabel.leftAnchor.constraint(equalTo: popUpView.leftAnchor, constant: 15).isActive = true
        programmNameStaticLabel.topAnchor.constraint(equalTo: TopSeparatorForTitle.bottomAnchor, constant: 35).isActive = true
        programmNameStaticLabel.bottomAnchor.constraint(equalTo: programmNameTextField.bottomAnchor).isActive = true
        programmNameStaticLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        programmNameStaticLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.325).isActive = true
        
        
        UIView.animate(withDuration: 0.3) {
            
            self.blurViewController.backgroundColor = UIColor.black.withAlphaComponent(0.25)
            self.popUpView.alpha = 1
            self.tabBarController?.tabBar.alpha = 0
            self.popUpView.transform = CGAffineTransform.identity
            
            self.popUpView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: self.view.frame.width + 50)
            self.popUpView.center = self.view.center
            
        }
        
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
            self.programmNameStaticLabel.removeFromSuperview()
            self.programmNameTextField.removeFromSuperview()

            self.blurViewController.removeAllConstraints()
            self.popUpViewTitleLabel.removeAllConstraints()
            self.popUpViewCancelButton.removeAllConstraints()
            self.popUpViewSaveButton.removeAllConstraints()
            self.TopSeparatorForTitle.removeAllConstraints()
            self.programmNameStaticLabel.removeAllConstraints()
            self.programmNameTextField.removeAllConstraints()
            
        }
        
    }
    
    
}

//Extension for searchBar

extension TrainingPlans: UISearchResultsUpdating, UIScrollViewDelegate, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchController.searchBar.becomeFirstResponder()
        searchController.searchBar.showsCancelButton = true
        
    }
        
        func filterContentForSearchText(_ searchText: String) {
                        
            
            
            trainingProgramms = trainingProgrammsUnchanged.filter { (candy: Programm) -> Bool in
                    
                return candy.programm_date!.lowercased().contains(searchText.lowercased())
            }
          
          tableView.reloadData()
        }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        isEditing = false
        searchController.searchBar.endEditing(true)
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.resignFirstResponder()
        trainingProgramms = CoreDataStack().loadProgramms()
        tableView.reloadData()
        
    }
    
}

//Extensions for TableView

extension TrainingPlans: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if isFiltering {
            
        return trainingProgramms.count
            
        } else {
            
        return trainingProgrammsUnchanged.count
            
        }
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
        
        if isFiltering {
            
            label.text = trainingProgramms[section].programm_date
            label.textColor = UIColor.white
            label.font = UIFont.systemFont(ofSize: 20)
            label.clipsToBounds = false
            label.layer.shadowColor = UIColor.white.cgColor
            label.layer.shadowOpacity = 0.65
            label.layer.shadowRadius = 4
            label.layer.shadowOffset = CGSize(width: 0, height: 0)
            returnedView.addSubview(label)
            
            return returnedView
            
        } else {
            
            label.text = trainingProgrammsUnchanged[section].programm_date
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
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! TrainingPlansCell
        cell.layer.cornerRadius = 15
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        if isFiltering {
            
            let imageAttachmentDuration = NSTextAttachment()
            imageAttachmentDuration.image = UIImage(named: "duration")
            let imageOffsetYDuration: CGFloat = -2.0
            imageAttachmentDuration.bounds = CGRect(x: -5.0, y: imageOffsetYDuration, width: imageAttachmentDuration.image!.size.width, height: imageAttachmentDuration.image!.size.height)
            let attachmentStringDuration = NSAttributedString(attachment: imageAttachmentDuration)
            let completeTextDuration = NSMutableAttributedString(string: "")
            completeTextDuration.append(attachmentStringDuration)
            let textAfterIconDuration = NSAttributedString(string: ":  \(trainingProgramms[indexPath.section].programm_duration_weeks ?? "" ) Week".Localized())
            completeTextDuration.append(textAfterIconDuration)
            cell.durationInWeeks.attributedText = completeTextDuration
            
            let imageAttachmentNumberOfWorkouts = NSTextAttachment()
            imageAttachmentNumberOfWorkouts.image = UIImage(named: "workouts")
            let imageOffsetYNumberOfWorkouts: CGFloat = -2.0
            imageAttachmentNumberOfWorkouts.bounds = CGRect(x: -5.0, y: imageOffsetYNumberOfWorkouts, width: imageAttachmentNumberOfWorkouts.image!.size.width, height: imageAttachmentNumberOfWorkouts.image!.size.height)
            let attachmentStringNumberOfWorkouts = NSAttributedString(attachment: imageAttachmentNumberOfWorkouts)
            let completeTextNumberOfWorkouts = NSMutableAttributedString(string: "")
            completeTextNumberOfWorkouts.append(attachmentStringNumberOfWorkouts)
            
            let numberOfWorkouts = trainingProgramms[indexPath.section].workouts?.array as! [Workout]
            
            let textAfterIconNumberOfWorkouts = NSAttributedString(string: ":  \(String(numberOfWorkouts.count)) Workouts".Localized())
            completeTextNumberOfWorkouts.append(textAfterIconNumberOfWorkouts)
            cell.numberOfWorkouts.attributedText = completeTextNumberOfWorkouts
            
            cell.imageViewPlans.image = UIImage(named: trainingProgramms[indexPath.section].programm_image!)
            cell.programmName.text = trainingProgramms[indexPath.section].programm_name
            
            return cell
            
        } else {
            
            let imageAttachmentDuration = NSTextAttachment()
            imageAttachmentDuration.image = UIImage(named: "duration")
            let imageOffsetYDuration: CGFloat = -2.0
            imageAttachmentDuration.bounds = CGRect(x: -5.0, y: imageOffsetYDuration, width: imageAttachmentDuration.image!.size.width, height: imageAttachmentDuration.image!.size.height)
            let attachmentStringDuration = NSAttributedString(attachment: imageAttachmentDuration)
            let completeTextDuration = NSMutableAttributedString(string: "")
            completeTextDuration.append(attachmentStringDuration)
            let textAfterIconDuration = NSAttributedString(string: ":  \(trainingProgrammsUnchanged[indexPath.section].programm_duration_weeks ?? "" ) Week".Localized())
            completeTextDuration.append(textAfterIconDuration)
            cell.durationInWeeks.attributedText = completeTextDuration
            
            let imageAttachmentNumberOfWorkouts = NSTextAttachment()
            imageAttachmentNumberOfWorkouts.image = UIImage(named: "workouts")
            let imageOffsetYNumberOfWorkouts: CGFloat = -2.0
            imageAttachmentNumberOfWorkouts.bounds = CGRect(x: -5.0, y: imageOffsetYNumberOfWorkouts, width: imageAttachmentNumberOfWorkouts.image!.size.width, height: imageAttachmentNumberOfWorkouts.image!.size.height)
            let attachmentStringNumberOfWorkouts = NSAttributedString(attachment: imageAttachmentNumberOfWorkouts)
            let completeTextNumberOfWorkouts = NSMutableAttributedString(string: "")
            completeTextNumberOfWorkouts.append(attachmentStringNumberOfWorkouts)
            
            let numberOfWorkouts = trainingProgrammsUnchanged[indexPath.section].workouts?.array as! [Workout]
            
            let textAfterIconNumberOfWorkouts = NSAttributedString(string: ":  \(String(numberOfWorkouts.count)) Workouts".Localized())
            completeTextNumberOfWorkouts.append(textAfterIconNumberOfWorkouts)
            cell.numberOfWorkouts.attributedText = completeTextNumberOfWorkouts
            
            cell.imageViewPlans.image = UIImage(named: trainingProgrammsUnchanged[indexPath.section].programm_image!)
            cell.programmName.text = trainingProgrammsUnchanged[indexPath.section].programm_name
            
            return cell
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        let calendar = Calendar.current
        let weekRange = calendar.range(of: .weekOfYear, in: .year, for: Date())
        let currentWeek = calendar.component(.weekOfYear, from: Date()) - 2
        let weeks = Array(currentWeek ... (weekRange!.upperBound) - 2)

        if isFiltering {
            
            let vc = TrainingProgrammLobby()
            vc.titleName = trainingProgramms[indexPath.section].programm_name
            let workoutsToPush = trainingProgramms[indexPath.section].workouts?.array as! [Workout]
            vc.workouts = workoutsToPush
            vc.durationWeeks = trainingProgramms[indexPath.section].programm_duration_weeks
            vc.numberOfWorkouts = trainingProgramms[indexPath.section].programm_number_of_workouts
            vc.daysToAdd = (weeks[indexPath.section] - currentWeek) * 7
            vc.programm = trainingProgramms[indexPath.section]
            navigationController?.pushViewController(vc, animated: true)
            
        } else {
            
            let vc = TrainingProgrammLobby()
            vc.titleName = trainingProgrammsUnchanged[indexPath.section].programm_name
            let workoutsToPush = trainingProgrammsUnchanged[indexPath.section].workouts?.array as! [Workout]
            vc.workouts = workoutsToPush
            vc.durationWeeks = trainingProgrammsUnchanged[indexPath.section].programm_duration_weeks
            vc.numberOfWorkouts = trainingProgrammsUnchanged[indexPath.section].programm_number_of_workouts
            vc.daysToAdd = (weeks[indexPath.section] - currentWeek) * 7
            vc.programm = trainingProgrammsUnchanged[indexPath.section]
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return viewHeight * 0.275
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
}


extension String {
    func Localized() -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}
