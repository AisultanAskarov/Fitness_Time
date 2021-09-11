//
//  WorkoutsCell.swift
//  Fitness_Time
//
//  Created by Aisultan Askarov on 7.09.2021.
//

import UIKit

class WorkoutsCell: UITableViewCell {
    
    let cellsBackgroundView: UIView = {
       
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    let workoutLabel: UILabel = {
           
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 21.0, weight: .semibold)
        label.text = ""
        label.textAlignment = .left
        label.textColor = UIColor.white
            
        return label
    }()
    
    let targetMuscles: UILabel = {
           
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.text = ""
        label.textAlignment = .left
        label.textColor = UIColor.white
            
        return label
    }()
    
    let numberOfExercises: UILabel = {
           
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.text = ""
        label.textAlignment = .left
        label.textColor = UIColor.white
            
        return label
    }()
    
    let workoutImage: UIImageView = {
       
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(cellsBackgroundView)
        addSubview(workoutImage)
        addSubview(workoutLabel)
        addSubview(targetMuscles)
        addSubview(numberOfExercises)
        
        cellsBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        cellsBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        cellsBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        cellsBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        cellsBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        
        workoutImage.translatesAutoresizingMaskIntoConstraints = false
        
        workoutImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        workoutImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        workoutImage.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        workoutImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        
        workoutLabel.translatesAutoresizingMaskIntoConstraints = false
        
        workoutLabel.leadingAnchor.constraint(equalTo: cellsBackgroundView.leadingAnchor, constant: 20).isActive = true
        workoutLabel.trailingAnchor.constraint(equalTo: cellsBackgroundView.trailingAnchor, constant: -20).isActive = true
        workoutLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        workoutLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -45).isActive = true
        
        targetMuscles.translatesAutoresizingMaskIntoConstraints = false
        
        targetMuscles.leftAnchor.constraint(equalTo: cellsBackgroundView.leftAnchor, constant: 20).isActive = true
        targetMuscles.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25).isActive = true
        targetMuscles.sizeToFit()
        
        numberOfExercises.translatesAutoresizingMaskIntoConstraints = false
        
        numberOfExercises.leftAnchor.constraint(equalTo: targetMuscles.rightAnchor, constant: 15).isActive = true
        numberOfExercises.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25).isActive = true
        numberOfExercises.sizeToFit()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
