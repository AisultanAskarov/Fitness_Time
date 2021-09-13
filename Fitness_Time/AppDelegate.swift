//
//  AppDelegate.swift
//  Fitness_Time
//
//  Created by Gabriel on 4.09.2021.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        preloadDataFromStructArray() //Preloading workout data that user will change
        
        let attrs = [
          NSAttributedString.Key.foregroundColor: UIColor.white
        ]

        UINavigationBar.appearance().largeTitleTextAttributes = attrs
        UINavigationBar.appearance().titleTextAttributes = attrs
        UINavigationBar.appearance().prefersLargeTitles = true
                
        return true
    }
    
    
    func preloadDataFromStructArray() {
        
        let preloadedDataKey = "didPreloadData"
        let userDefaults = UserDefaults.standard
        
        if userDefaults.bool(forKey: preloadedDataKey) == false {

            let backgroundContext = CoreDataStack.persistentContainer.newBackgroundContext()
            CoreDataStack.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
            
            backgroundContext.perform {
                
                let calendar = Calendar.current
                let weekRange = calendar.range(of: .weekOfYear, in: .year, for: Date())
                let currentWeek = calendar.component(.weekOfYear, from: Date()) - 2
                let weeks = Array(currentWeek ... (weekRange!.upperBound) - 2)
                let currentYear = calendar.component(.year, from: Date())
                
                //label.text = "Year \(currentYear) | Week \(weeks[section])"
                
                let programms = TrainingProgrammsResponse.programms()
                
                    do{
                        
                        for i in 0..<(programms.count) {
                            
                            let context = CoreDataStack.context
                            let newProgramm = Programm(context: context)
                            newProgramm.setValue(programms[i].programm_duration_weeks, forKey: "programm_duration_weeks")
                            newProgramm.setValue(programms[i].programm_id, forKey: "programm_id")
                            newProgramm.setValue(programms[i].programm_image, forKey: "programm_image")
                            newProgramm.setValue(programms[i].programm_name, forKey: "programm_name")
                            newProgramm.setValue(programms[i].programm_number_of_workouts, forKey: "programm_number_of_workouts")
                            newProgramm.setValue("Year \(currentYear) | Week \(weeks[i])", forKey: "programm_date")
                            
                                                        
                            for w in 0..<(programms[i].programm_workouts.count) {
                            
                                let newWorkout = Workout(context: context)

                                newWorkout.setValue(programms[i].programm_workouts[w].workout_id, forKey: "workout_id")
                                newWorkout.setValue(programms[i].programm_workouts[w].workout_image, forKey: "workout_image")
                                newWorkout.setValue(programms[i].programm_workouts[w].workout_duration, forKey: "workout_duration")
                                newWorkout.setValue(programms[i].programm_workouts[w].workout_completed, forKey: "workout_completed")
                                newWorkout.setValue(programms[i].programm_workouts[w].workout_target_muscles, forKey: "workout_target_muscles")

                                let daysToAdd = (weeks[i] - currentWeek) * 7
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

                                for e in 0..<(programms[i].programm_workouts[w].exercises.count) {
                                    
                                    let newExercise = Exercises(context: context)
                                    newExercise.setValue(programms[i].programm_workouts[w].exercises[e].name, forKey: "exercise_name")
                                    newExercise.setValue(programms[i].programm_workouts[w].exercises[e].reps, forKey: "exercise_reps")
                                    newExercise.setValue(programms[i].programm_workouts[w].exercises[e].weight, forKey: "exercise_weight")
                                    newExercise.setValue(programms[i].programm_workouts[w].exercises[e].workoutId, forKey: "workoutId")
                                    
                                    newWorkout.addToExercises(newExercise)
                                    
                                }
                                
                            }
                                                                                    
                        }
                        
                        try backgroundContext.save()
                        userDefaults.setValue(true, forKey: preloadedDataKey)

                    } catch {
                        print(error.localizedDescription)
                    }
                
            }
                        
        }
        
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Fitness_Time")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
