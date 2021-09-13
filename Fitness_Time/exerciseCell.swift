//
//  exerciseCell.swift
//  Fitness_Time
//
//  Created by Aisultan Askarov on 8.09.2021.
//

import UIKit
import CoreData

class exerciseCell: UITableViewCell, UITextFieldDelegate {
    
    let exerciseName: UILabel = {
           
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 21.0, weight: .bold)
        label.text = ""
        label.textAlignment = .left
        label.textColor = UIColor.white
            
        return label
    }()
    
    let repsTextField: UITextField = {
       
        let textView = UITextField()
        textView.backgroundColor = UIColor.clear
        textView.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        textView.textAlignment = .right
        textView.textColor = UIColor.white
        textView.keyboardType = .numberPad
        textView.text = "0"
        textView.isUserInteractionEnabled = true
        
        
        return textView
    }()
    
    let repsStaticLabel: UILabel = {
           
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        label.text = "Reps:".Localized()
        label.textAlignment = .right
        label.textColor = UIColor.white
            
        return label
    }()
    
    let weightTextField: UITextField = {
       
        let textView = UITextField()
        textView.backgroundColor = UIColor.clear
        textView.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        textView.textAlignment = .right
        textView.textColor = UIColor.white
        textView.keyboardType = .numberPad
        textView.text = "0"
        textView.isUserInteractionEnabled = true
        
        return textView
    }()
    
    let weightStaticLabel: UILabel = {
           
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        label.text = "Weight:".Localized()
        label.textAlignment = .right
        label.textColor = UIColor.white
            
        return label
    }()
    
    let weightLBSStaticLabel: UILabel = {
           
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        label.text = "KG"
        label.textAlignment = .right
        label.textColor = UIColor.white
            
        return label
    }()
    
    var exercises: [Exercises] = []
    var change = [NSManagedObject]()
    var id: Int16!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.isUserInteractionEnabled = true

        addSubview(exerciseName)
        addSubview(repsStaticLabel)
        addSubview(repsTextField)
        addSubview(weightStaticLabel)
        addSubview(weightTextField)
        addSubview(weightLBSStaticLabel)

        exerciseName.translatesAutoresizingMaskIntoConstraints = false
        
        exerciseName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25).isActive = true
        exerciseName.trailingAnchor.constraint(equalTo: repsStaticLabel.leadingAnchor).isActive = true
        exerciseName.topAnchor.constraint(equalTo: topAnchor).isActive = true
        exerciseName.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        repsTextField.translatesAutoresizingMaskIntoConstraints = false
        
        repsTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        repsTextField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        repsTextField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        repsTextField.sizeToFit()
        
        repsStaticLabel.translatesAutoresizingMaskIntoConstraints = false
        
        repsStaticLabel.rightAnchor.constraint(equalTo: repsTextField.leftAnchor, constant: -7.5).isActive = true
        repsStaticLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        repsStaticLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        repsStaticLabel.sizeToFit()
        
        weightTextField.translatesAutoresizingMaskIntoConstraints = false
        
        weightTextField.rightAnchor.constraint(equalTo: weightLBSStaticLabel.leftAnchor, constant: -5).isActive = true
        weightTextField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        weightTextField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        weightTextField.sizeToFit()
        
        weightStaticLabel.translatesAutoresizingMaskIntoConstraints = false
        
        weightStaticLabel.rightAnchor.constraint(equalTo: weightTextField.leftAnchor, constant: -7.5).isActive = true
        weightStaticLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        weightStaticLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        weightStaticLabel.sizeToFit()
        
        weightLBSStaticLabel.translatesAutoresizingMaskIntoConstraints = false
        
        weightLBSStaticLabel.rightAnchor.constraint(equalTo: repsStaticLabel.leftAnchor, constant: -17.5).isActive = true
        weightLBSStaticLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        weightLBSStaticLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        weightLBSStaticLabel.sizeToFit()
        
        let toolBar =  UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 35))
        toolBar.barStyle = .default
        toolBar.sizeToFit()

        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(saveChanges))
        toolBar.items = [doneButton]
        toolBar.isUserInteractionEnabled = true
        repsTextField.inputAccessoryView = toolBar
        weightTextField.inputAccessoryView = toolBar

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func saveChanges() {
        
        repsTextField.endEditing(true)
        weightTextField.endEditing(true)
        
        
        let exercise: Exercises!
        
        do{
        
            let fetchUser: NSFetchRequest<Exercises> = Exercises.fetchRequest()
            fetchUser.predicate = NSPredicate(format: "workoutId = %@", argumentArray: [id ?? 1])

            let results = try? CoreDataStack.context.fetch(fetchUser)

            if results?.count == 0 {
               // here you are inserting
               exercise = Exercises(context: CoreDataStack.context)
            } else {
               // here you are updating
               exercise = results?.first
            }

           exercise.exercise_reps = repsTextField.text!
           exercise.exercise_weight = weightTextField.text!
        
            try CoreDataStack.context.save()

        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.text = "" //Removing 0 when user starts typing.
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //MARK: -Limiting the max number of digits.
        
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 3
        
    }
    
    enum TextFieldData: Int {
        
        case repsTextField = 0
        case weightTextField
        
    }
    

}
