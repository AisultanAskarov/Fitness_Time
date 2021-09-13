//
//  CoreDataStack.swift
//  Fitness Time
//
//  Created by Gabriel on 4.09.2021.
//

import Foundation
import CoreData
import UIKit


class CoreDataStack {
  
 
    static let sharedManager = CoreDataStack()
    
    static let persistentContainer: NSPersistentContainer = {
      let container = NSPersistentContainer(name: "Fitness_Time")
      container.loadPersistentStores { (_, error) in
        if let error = error as NSError? {
          fatalError("Unresolved error \(error), \(error.userInfo)")
        }
      }
      return container
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Login> = {
        
        let fetchRequest: NSFetchRequest<Login> = Login.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "email", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self as? NSFetchedResultsControllerDelegate

        return fetchedResultsController
        
    }()
    
  static var context: NSManagedObjectContext { return persistentContainer.viewContext }

    // MARK: - Pulling Email From Core Data
    
    func loadEmail() -> [Login] {
        
        var login : [Login] = []
        let context = CoreDataStack.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Login> = Login.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "email", ascending: false)]
        
        do {
            let email = try context.fetch(fetchRequest)
            if(email.count > 0) {
                login = email
            }
        } catch {
            print("Something happened while trying to retrieve tasks...")
        }
        return login
    }
    
    func loadExercises() -> [Exercises] {
        
        var _runs : [Exercises] = []
        let context = CoreDataStack.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Exercises> = Exercises.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "workoutId", ascending: false)]

        do {
            let sessions = try context.fetch(fetchRequest)
            if(sessions.count > 0) {
                _runs = sessions
            }
        } catch {
            print("Something happened while trying to retrieve tasks...")
        }
        return _runs
    }
    
    func loadProgramms() -> [Programm] {
        
        var _runs : [Programm] = []
        let context = CoreDataStack.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Programm> = Programm.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "programm_id", ascending: false)]

        do {
            let sessions = try context.fetch(fetchRequest)
            if(sessions.count > 0) {
                _runs = sessions
            }
        } catch {
            print("Something happened while trying to retrieve tasks...")
        }
        return _runs
    }
    
    func loadWorkouts() -> [Workout] {
        
        var _runs : [Workout] = []
        let context = CoreDataStack.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Workout> = Workout.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "workout_date", ascending: true)]

        do {
            let sessions = try context.fetch(fetchRequest)
            if(sessions.count > 0) {
                _runs = sessions
            }
        } catch {
            print("Something happened while trying to retrieve tasks...")
        }
        return _runs
    }
    
    // MARK: - Core Data Saving

    class func saveContext () {
        let context = persistentContainer.viewContext
    
    guard context.hasChanges else {
      return
    }
        
    do {
      try context.save()
        try CoreDataStack().fetchedResultsController.performFetch()
    } catch {
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
  }
    
    
}
