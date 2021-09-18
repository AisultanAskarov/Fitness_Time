//
//  ParsingProgramms.swift
//  Fitness_Time
//
//  Created by Aisultan Askarov on 7.09.2021.
//

import Foundation
import UIKit

struct TrainingProgrammsResponse {
    
    enum TrainingProgrammKeys: String, CodingKey, Decodable {
        
        case programm_name = "programm_name"
        case programm_id = "programm_id"
        case programm_image = "programm_image"
        case programm_duration_weeks = "programm_duration_weeks"
        case programm_workouts = "programm_workouts"
        case programm_number_of_workouts = "programm_number_of_workouts"

    }
    
    let programm_name: String
    let programm_id: String
    let programm_image: String
    let programm_duration_weeks: String
    let programm_workouts: [workoutStructure]
    let programm_number_of_workouts: String
    
}

struct workoutStructure {
    
    enum workoutStructureKeys: String, CodingKey, Decodable {
        
        case workout_id = "workout_id"
        case workout_completed = "workout_completed"
        case workout_duration = "workout_duration"
        case exercises = "exercises"
        case workout_target_muscles = "workout_target_muscles"
        case workout_image = "workout_image"

    }
    
    let workout_id: String
    let workout_completed: Bool
    let workout_duration: String
    let exercises: [exerciseStructure]
    let workout_target_muscles: String
    let workout_image: String

}

struct exerciseStructure {
    
    enum exerciseStructureKeys: String, CodingKey, Decodable {
        
        case name = "name"
        case reps = "reps"
        case weight = "weight"
        case workoutId = "workoutId"

    }
    
    let name: String
    let reps: String
    let weight: String
    let workoutId: Int16
    
}

extension TrainingProgrammsResponse: Decodable {
    
    init(from decode: Decoder) throws {
        
        let container = try decode.container(keyedBy: TrainingProgrammKeys.self)
        programm_name = try container.decode(String.self, forKey: .programm_name)
        programm_id = try container.decode(String.self, forKey: .programm_id)
        programm_image = try container.decode(String.self, forKey: .programm_image)
        programm_duration_weeks = try container.decode(String.self, forKey: .programm_duration_weeks)
        programm_workouts = try container.decode([workoutStructure].self, forKey: .programm_workouts)
        programm_number_of_workouts = try container.decode(String.self, forKey: .programm_number_of_workouts)
        
    }
    
}

extension workoutStructure: Decodable {
    
    init(from decode: Decoder) throws {
        
        let workoutStructureContainer = try decode.container(keyedBy: workoutStructureKeys.self)
        workout_id = try workoutStructureContainer.decode(String.self, forKey: .workout_id)
        workout_completed = try workoutStructureContainer.decode(Bool.self, forKey: .workout_completed)
        workout_duration = try workoutStructureContainer.decode(String.self, forKey: .workout_duration)
        exercises = try workoutStructureContainer.decode([exerciseStructure].self, forKey: .exercises)
        workout_target_muscles = try workoutStructureContainer.decode(String.self, forKey: .workout_target_muscles)
        workout_image = try workoutStructureContainer.decode(String.self, forKey: .workout_image)
       
    }
    
}

extension exerciseStructure: Decodable {
    
    init(from decode: Decoder) throws {
        
        let exerciseStructureContainer = try decode.container(keyedBy: exerciseStructureKeys.self)
        reps = try exerciseStructureContainer.decode(String.self, forKey: .reps)
        weight = try exerciseStructureContainer.decode(String.self, forKey: .weight)
        name = try exerciseStructureContainer.decode(String.self, forKey: .name)
        workoutId = try exerciseStructureContainer.decode(Int16.self, forKey: .workoutId)
       
    }
    
}

extension TrainingProgrammsResponse {
    
    static func programms() -> [TrainingProgrammsResponse] {
        
        guard let url = Bundle.main.url(forResource: "TrainingProgramms", withExtension: "txt"), let data = try? Data(contentsOf: url) else {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([TrainingProgrammsResponse].self, from: data)
        } catch {
            return []
        }
        
    }
    
}
