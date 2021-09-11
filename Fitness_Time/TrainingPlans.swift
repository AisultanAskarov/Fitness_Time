//
//  TrainingPlans.swift
//  Fitness_Time
//
//  Created by Gabriel on 4.09.2021.
//

import UIKit

class TrainingPlans: UIViewController, UINavigationBarDelegate {
    
    var tableView: UITableView!
    var cellID = "Cell"
    var viewHeight: CGFloat!
    
    var trainingProgramms: [TrainingProgrammsResponse] = TrainingProgrammsResponse.programms()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        viewHeight = view.frame.height
        
        setView()
        
        tableView = UITableView()
        tableView.register(TrainingPlansCell.self, forCellReuseIdentifier: cellID)
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
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .darkContent
    }
    
}

//Extensions for TableView

extension TrainingPlans: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return trainingProgramms.count
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Week \(trainingProgramms[section].programm_id)"
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 55))
        returnedView.backgroundColor = .clear
        let label = UILabel(frame: CGRect(x: 20, y: 25, width: view.frame.width, height: 25))
        
        let calendar = Calendar.current
        let weekRange = calendar.range(of: .weekOfYear, in: .year, for: Date())
        let currentWeek = calendar.component(.weekOfYear, from: Date()) - 2
        let weeks = Array(currentWeek ... (weekRange!.upperBound) - 2)
        let currentYear = calendar.component(.year, from: Date())

        label.text = "Year \(currentYear) | Week \(weeks[section])"
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! TrainingPlansCell
        cell.layer.cornerRadius = 15
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        //Setting cells properties
        
        //MARK: - ALL the imageAttachments are used to set icons before duration, numberOfWorkouts and Level of programm
        let imageAttachmentDuration = NSTextAttachment()
        imageAttachmentDuration.image = UIImage(named: "duration")
        let imageOffsetYDuration: CGFloat = -2.0
        imageAttachmentDuration.bounds = CGRect(x: -5.0, y: imageOffsetYDuration, width: imageAttachmentDuration.image!.size.width, height: imageAttachmentDuration.image!.size.height)
        let attachmentStringDuration = NSAttributedString(attachment: imageAttachmentDuration)
        let completeTextDuration = NSMutableAttributedString(string: "")
        completeTextDuration.append(attachmentStringDuration)
        let textAfterIconDuration = NSAttributedString(string: ":  \(trainingProgramms[indexPath.section].programm_duration_weeks ) Week")
        completeTextDuration.append(textAfterIconDuration)
        cell.durationInWeeks.attributedText = completeTextDuration
        
        let imageAttachmentNumberOfWorkouts = NSTextAttachment()
        imageAttachmentNumberOfWorkouts.image = UIImage(named: "workouts")
        let imageOffsetYNumberOfWorkouts: CGFloat = -2.0
        imageAttachmentNumberOfWorkouts.bounds = CGRect(x: -5.0, y: imageOffsetYNumberOfWorkouts, width: imageAttachmentNumberOfWorkouts.image!.size.width, height: imageAttachmentNumberOfWorkouts.image!.size.height)
        let attachmentStringNumberOfWorkouts = NSAttributedString(attachment: imageAttachmentNumberOfWorkouts)
        let completeTextNumberOfWorkouts = NSMutableAttributedString(string: "")
        completeTextNumberOfWorkouts.append(attachmentStringNumberOfWorkouts)
        let textAfterIconNumberOfWorkouts = NSAttributedString(string: ":  \(trainingProgramms[indexPath.section].programm_number_of_workouts ) Workouts")
        completeTextNumberOfWorkouts.append(textAfterIconNumberOfWorkouts)
        cell.numberOfWorkouts.attributedText = completeTextNumberOfWorkouts
        
        cell.imageViewPlans.image = UIImage(named: trainingProgramms[indexPath.section].programm_image)
        cell.programmName.text = trainingProgramms[indexPath.section].programm_name
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        let calendar = Calendar.current
        let weekRange = calendar.range(of: .weekOfYear, in: .year, for: Date())
        let currentWeek = calendar.component(.weekOfYear, from: Date()) - 2
        let weeks = Array(currentWeek ... (weekRange!.upperBound) - 2)
        
        let vc = TrainingProgrammLobby()
        vc.titleName = trainingProgramms[indexPath.row].programm_name
        vc.workouts = trainingProgramms[indexPath.row].programm_workouts
        vc.durationWeeks = trainingProgramms[indexPath.row].programm_duration_weeks
        vc.numberOfWorkouts = trainingProgramms[indexPath.row].programm_number_of_workouts
        vc.daysToAdd = (weeks[indexPath.section] - currentWeek) * 7
        navigationController?.pushViewController(vc, animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return viewHeight * 0.275
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
}

