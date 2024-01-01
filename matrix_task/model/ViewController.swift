//
//  ViewController.swift
//  matrix_todo
//
//  Created by 濵川怜 on 2023/11/11.
//

import SwiftUI
import RealmSwift

class ViewController: ObservableObject {
    @Published var showTaskList: Bool = false
    @Published var showDetails: Bool = false
    @Published var selectedTask: Task? = nil
    @Published var selectedTaskId: ObjectId?
    @Published var selectedType: Int = 1
}
