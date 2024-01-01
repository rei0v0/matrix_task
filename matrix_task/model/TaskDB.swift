//
//  todo_model.swift
//  matrix_todo
//
//  Created by 濵川怜 on 2023/10/17.
//

import SwiftUI
import RealmSwift

class Task: Object,Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String = ""
    @Persisted var type: Int = 1
    @Persisted var checkList = RealmSwift.List<CheckItem>()
    @Persisted var detail: String?
    @Persisted var startDeadline : Date?
    @Persisted var middleDeadline : Date?
    @Persisted var finalDeadline : Date?
}

class CheckItem: Object,Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String = ""
    @Persisted var isCompleted: Bool = false
}

class TaskDB: ObservableObject {
    
    
    static let shared = TaskDB()
 
    private var token: NotificationToken?
    private var taskDBResults = try? Realm().objects(Task.self)
    private var checkItemResults = try? Realm().objects(CheckItem.self)
    
    @Published var allTasks: [Task] = []
    @Published var allCheckItems: [CheckItem] = []


    @Published var title = ""
    @Published var type = 1
    @Published var checkList:[CheckItem] = []
    @Published var detail = ""
    @Published var startDeadline:Date? = nil
    @Published var middleDeadline:Date? = nil
    @Published var finalDeadline:Date? = nil
    
    
    
    init() {
        token = taskDBResults?.observe { [weak self] _ in
            self?.allTasks = self?.taskDBResults?.map { $0 } ?? []
            self?.allCheckItems = self?.checkItemResults?.map { $0 } ?? []
        }
    }
    deinit {
        token?.invalidate()
    }
    
    func reset() {
        self.title = ""
        self.type = 1
        self.checkList = []
        self.detail = ""
        self.startDeadline = nil
        self.middleDeadline = nil
        self.finalDeadline = nil
    }
    
    func updateCheckItem(itemId:ObjectId){
        let realm = try! Realm()
        let checkItem = self.allCheckItems.first(where: {$0.id == itemId})
        if(checkItem != nil){
            do{
              try realm.write{
                  checkItem!.isCompleted.toggle()
              }
            }catch {
              print("Error \(error)")
            }
        }
        
    }
        
    func addData(){
        let newTask = Task()
        newTask.title = self.title
        newTask.type = self.type
        newTask.detail = self.detail
        newTask.startDeadline = self.startDeadline
        newTask.middleDeadline = self.middleDeadline
        newTask.finalDeadline = self.finalDeadline
        
        for checkItem in self.checkList {
            newTask.checkList.append(checkItem)
        }
        
        guard let dbRef = try? Realm() else {return}
        
        try? dbRef.write{
            dbRef.add(newTask)
        }
    }
    func updateData(task:Task){
        let realm = try! Realm()
        do{
          try realm.write{
              
              realm.add(task, update: .modified)
          }
        }catch {
          print("Error \(error)")
        }
    }
    
    func removeData(targetTask : Task) {
        let realm = try! Realm()
        
        for targetCheckItem in targetTask.checkList{
            do{
              try realm.write{
                realm.delete(targetCheckItem)
              }
            }catch {
              print("Error \(error)")
            }
        }
        do{
          try realm.write{
            realm.delete(targetTask)
          }
        }catch {
          print("Error \(error)")
        }
    }
    
    func tasksForSelectedIndex(_ index: Int) -> [Task] {
            switch index {
            case 0:
                return self.allTasks.filter({$0.type == 0})
            case 1:
                return self.allTasks.filter({$0.type == 1})
            case 2:
                return self.allTasks.filter({$0.type == 2})
            case 3:
                return self.allTasks.filter({$0.type == 3})
            default:
                return [] // 無効なインデックスの場合は空のリストを返す
        }
    }
    
    func getCheckItmes(taskId: ObjectId) -> [CheckItem] {
        let task = allTasks.first(where:{$0.id == taskId})
        if (task != nil) {
            return Array(task!.checkList)
        }else{
            return []
        }
    }
    
}


