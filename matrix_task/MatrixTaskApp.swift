//
//  matrix_todoApp.swift
//  matrix_todo
//
//  Created by 濵川怜 on 2023/10/17.
//

import SwiftUI

@main
struct MatrixTaskApp: App {
    
    var viewController =  ViewController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(TaskDB.shared)
                .environmentObject(viewController)
        }
    }
}
