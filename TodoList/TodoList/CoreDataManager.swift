//
//  CoreDataManager.swift
//  TodoList
//
//  Created by lzz on 2018/11/28.
//  Copyright © 2018 com.gaofeng. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager: NSObject {
    
    static let shared  = CoreDataManager(modelName:"Model")
    
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                debugPrint("Unclear error\(error)")
            }
        })
        
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    //update data
    func saveContext() {
        guard managedContext.hasChanges else { return }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            debugPrint("Unclear error\(error)")
        }
        
    }
    
    //insert data
    func insertTask(name:String,date:Date,status:Int16,type:Int16,longitude:Double,latitude:Double,address:String){
        let task = NSEntityDescription.insertNewObject(forEntityName: "Task", into: managedContext) as! Task
        task.name = name
        task.time = date
        task.status = status
        task.type = type
        task.longitude = longitude
        task.latitude = latitude
        task.address = address
        saveContext()
    }
    
    //insert data
    func insertTask(name:String,date:Date,status:Int16,type:Int16){
        let task = NSEntityDescription.insertNewObject(forEntityName: "Task", into: managedContext) as! Task
        task.name = name
        task.time = date
        task.status = status
        task.type = type
        saveContext()
    }
    
    //get all task
    func getAllTask() -> [Task] {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        do {
            let result = try managedContext.fetch(fetchRequest)
            return result
        } catch {
            fatalError();
        }
    }
    
    //query task by name
    func getTaskByName(name: String) -> [Task] {
        let fetRequest: NSFetchRequest = Task.fetchRequest();
        fetRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            let result: [Task] = try managedContext.fetch(fetRequest)
            return result
        } catch {
            fatalError();
        }
    }
    
    
    //query task by NSObjectID
    func getTaskById(objectID: NSManagedObjectID) -> [Task] {
        let fetRequest: NSFetchRequest = Task.fetchRequest();
        fetRequest.predicate = NSPredicate(format: "task.objectID == %@", objectID)
        do {
            let result: [Task] = try managedContext.fetch(fetRequest)
            return result
        } catch {
            fatalError();
        }
    }
    
    //modify task by NSObjectID
    func modifyTaskByID(objectID: NSManagedObjectID,newName:String,newTime:Date,newType:Int16) {
        do{
            let task = try managedContext.existingObject(with: objectID) as? Task
            task?.name = newName
            task?.time = newTime
            task?.type = newType
        }catch{
            fatalError()
        }
        saveContext()
    }
    
    //delete task by objectID
    func deleteTask(objectID: NSManagedObjectID){
        do{
            let task = try managedContext.existingObject(with: objectID)
            managedContext.delete(task)
        }catch {
            fatalError()
        }
        saveContext()
    }
    
    //delete all tasks
    func deleteAllTasks() {
        let result = getAllTask()
        for task in result {
            managedContext.delete(task)
        }
        saveContext()
    }
}
