//
//  TrainingPlansCell.swift
//  Fitness_Time
//
//  Created by Aisultan Askarov on 7.09.2021.
//

import UIKit

class TrainingPlansCell: UITableViewCell {
    
    let backgroundViewPlans: UIView = {
       
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        view.layer.cornerRadius = 15
        
        return view
    }()
    
    let imageViewPlans: UIImageView = {
       
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "1")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        return imageView
    }()
    
    let dimBackGround: UIView = {
       
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        return view
    }()
    
    let programmName: UILabel = {
       
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 23.0, weight: .bold)
        label.text = "Mad Spartan"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.clipsToBounds = false
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOpacity = 0.25
        label.layer.shadowRadius = 2
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        return label
    }()
    
    let durationInWeeks: UILabel = {
       
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 15.5, weight: .medium)
        label.text = "⏱: 1 week"
        label.textAlignment = .center
        label.textColor = UIColor.white
        
        return label
    }()
    
    let numberOfWorkouts: UILabel = {
       
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 15.5, weight: .medium)
        label.text = "💪: 40"
        label.textAlignment = .center
        label.textColor = UIColor.white
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(backgroundViewPlans)
        addSubview(imageViewPlans)
        addSubview(dimBackGround)
        addSubview(programmName)
        addSubview(durationInWeeks)
        addSubview(numberOfWorkouts)

        backgroundViewPlans.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundViewPlans.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        backgroundViewPlans.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        backgroundViewPlans.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        backgroundViewPlans.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        
        imageViewPlans.translatesAutoresizingMaskIntoConstraints = false
        
        imageViewPlans.topAnchor.constraint(equalTo: backgroundViewPlans.topAnchor).isActive = true
        imageViewPlans.bottomAnchor.constraint(equalTo: backgroundViewPlans.bottomAnchor, constant: -50).isActive = true
        imageViewPlans.leadingAnchor.constraint(equalTo: backgroundViewPlans.leadingAnchor).isActive = true
        imageViewPlans.trailingAnchor.constraint(equalTo: backgroundViewPlans.trailingAnchor).isActive = true
        
        programmName.translatesAutoresizingMaskIntoConstraints = false
        
        programmName.topAnchor.constraint(equalTo: imageViewPlans.topAnchor).isActive = true
        programmName.bottomAnchor.constraint(equalTo: imageViewPlans.bottomAnchor, constant: 0).isActive = true
        programmName.leadingAnchor.constraint(equalTo: imageViewPlans.leadingAnchor).isActive = true
        programmName.trailingAnchor.constraint(equalTo: imageViewPlans.trailingAnchor).isActive = true
        
        dimBackGround.translatesAutoresizingMaskIntoConstraints = false
        
        dimBackGround.topAnchor.constraint(equalTo: imageViewPlans.topAnchor).isActive = true
        dimBackGround.bottomAnchor.constraint(equalTo: imageViewPlans.bottomAnchor).isActive = true
        dimBackGround.leadingAnchor.constraint(equalTo: imageViewPlans.leadingAnchor).isActive = true
        dimBackGround.trailingAnchor.constraint(equalTo: imageViewPlans.trailingAnchor).isActive = true
        
        durationInWeeks.translatesAutoresizingMaskIntoConstraints = false
        
        durationInWeeks.heightAnchor.constraint(equalToConstant: 50).isActive = true
        durationInWeeks.topAnchor.constraint(equalTo: imageViewPlans.bottomAnchor, constant: 0).isActive = true
        durationInWeeks.rightAnchor.constraint(equalTo: imageViewPlans.centerXAnchor, constant: 0).isActive = true
        durationInWeeks.widthAnchor.constraint(equalToConstant: (frame.width / 2)).isActive = true
        
        numberOfWorkouts.translatesAutoresizingMaskIntoConstraints = false
        
        numberOfWorkouts.heightAnchor.constraint(equalToConstant: 50).isActive = true
        numberOfWorkouts.topAnchor.constraint(equalTo: imageViewPlans.bottomAnchor, constant: 0).isActive = true
        numberOfWorkouts.leftAnchor.constraint(equalTo: imageViewPlans.centerXAnchor, constant: 0).isActive = true
        numberOfWorkouts.widthAnchor.constraint(equalToConstant: (frame.width / 2)).isActive = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
