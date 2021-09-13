//
//  TrainingPlans.swift
//  Fitness_Time
//
//  Created by Gabriel on 4.09.2021.
//

import UIKit
import CoreData

class TrainingPlans: UIViewController, UINavigationBarDelegate {
    
    
    @objc let changeLanguageButton: UIButton = {
       
        let button = UIButton()
        
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        button.titleLabel?.textAlignment = .center
        button.isUserInteractionEnabled = true
        button.isEnabled = true
        button.addTarget(self, action: #selector(changeCurrentLanguageForButton), for: .touchUpInside)
        
        return button
        
    }()
    
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
    
    var currentLanguage = CoreDataStack().loadCurrentLanguage()
    
    let sections: [String] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHeight = view.frame.height
        
        setView()
                
        if currentLanguage.first?.currentLanguage == "en" {
            
            changeLanguageButton.setTitle("DE", for: .normal)
            
        } else if currentLanguage.first?.currentLanguage == "de" {
            
            changeLanguageButton.setTitle("EN", for: .normal)
            
        }
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter the week"
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
        navigationItem.title = "Training Programms"
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.barStyle = .black
        navigationItem.hidesBackButton = true
        
        let add = UIBarButtonItem(title: currentLanguage.first?.currentLanguage, style: .plain, target: self, action: #selector(changeCurrentLanguageForButton))

        navigationItem.rightBarButtonItem = add
        
    }
    
    @objc func changeCurrentLanguageForButton() {
        
        let language = Language(context: CoreDataStack.context)
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Language")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try CoreDataStack.persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: CoreDataStack.context)
        } catch let error as NSError {
            print(error)
        }
        
        do{
        
            if currentLanguage.first?.currentLanguage == "en" {
                
                language.setValue("de", forKey: "currentLanguage")
                
            } else if currentLanguage.first?.currentLanguage == "de" {
                
                language.setValue("en", forKey: "currentLanguage")

            }
        
            try CoreDataStack.context.save()

        } catch {
            print(error.localizedDescription)
        }
                
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .darkContent
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
            let textAfterIconDuration = NSAttributedString(string: ":  \(trainingProgramms[indexPath.section].programm_duration_weeks ?? "" ) Week")
            completeTextDuration.append(textAfterIconDuration)
            cell.durationInWeeks.attributedText = completeTextDuration
            
            let imageAttachmentNumberOfWorkouts = NSTextAttachment()
            imageAttachmentNumberOfWorkouts.image = UIImage(named: "workouts")
            let imageOffsetYNumberOfWorkouts: CGFloat = -2.0
            imageAttachmentNumberOfWorkouts.bounds = CGRect(x: -5.0, y: imageOffsetYNumberOfWorkouts, width: imageAttachmentNumberOfWorkouts.image!.size.width, height: imageAttachmentNumberOfWorkouts.image!.size.height)
            let attachmentStringNumberOfWorkouts = NSAttributedString(attachment: imageAttachmentNumberOfWorkouts)
            let completeTextNumberOfWorkouts = NSMutableAttributedString(string: "")
            completeTextNumberOfWorkouts.append(attachmentStringNumberOfWorkouts)
            let textAfterIconNumberOfWorkouts = NSAttributedString(string: ":  \(trainingProgramms[indexPath.section].programm_number_of_workouts ?? "" ) Workouts")
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
            let textAfterIconDuration = NSAttributedString(string: ":  \(trainingProgrammsUnchanged[indexPath.section].programm_duration_weeks ?? "" ) Week")
            completeTextDuration.append(textAfterIconDuration)
            cell.durationInWeeks.attributedText = completeTextDuration
            
            let imageAttachmentNumberOfWorkouts = NSTextAttachment()
            imageAttachmentNumberOfWorkouts.image = UIImage(named: "workouts")
            let imageOffsetYNumberOfWorkouts: CGFloat = -2.0
            imageAttachmentNumberOfWorkouts.bounds = CGRect(x: -5.0, y: imageOffsetYNumberOfWorkouts, width: imageAttachmentNumberOfWorkouts.image!.size.width, height: imageAttachmentNumberOfWorkouts.image!.size.height)
            let attachmentStringNumberOfWorkouts = NSAttributedString(attachment: imageAttachmentNumberOfWorkouts)
            let completeTextNumberOfWorkouts = NSMutableAttributedString(string: "")
            completeTextNumberOfWorkouts.append(attachmentStringNumberOfWorkouts)
            let textAfterIconNumberOfWorkouts = NSAttributedString(string: ":  \(trainingProgrammsUnchanged[indexPath.section].programm_number_of_workouts ?? "" ) Workouts")
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
            vc.workouts = trainingProgramms[indexPath.section].workouts?.array as! [Workout]
            vc.durationWeeks = trainingProgramms[indexPath.section].programm_duration_weeks
            vc.numberOfWorkouts = trainingProgramms[indexPath.section].programm_number_of_workouts
            vc.daysToAdd = (weeks[indexPath.section] - currentWeek) * 7
            navigationController?.pushViewController(vc, animated: true)
            
        } else {
            
            let vc = TrainingProgrammLobby()
            vc.titleName = trainingProgrammsUnchanged[indexPath.section].programm_name
            vc.workouts = trainingProgrammsUnchanged[indexPath.section].workouts?.array as! [Workout]
            vc.durationWeeks = trainingProgrammsUnchanged[indexPath.section].programm_duration_weeks
            vc.numberOfWorkouts = trainingProgrammsUnchanged[indexPath.section].programm_number_of_workouts
            vc.daysToAdd = (weeks[indexPath.section] - currentWeek) * 7
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


