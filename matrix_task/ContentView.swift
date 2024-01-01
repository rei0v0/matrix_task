//
//  ContentView.swift
//  matrix_todo
//
//  Created by 濵川怜 on 2023/10/17.
//

import SwiftUI

struct ContentView: View {
    let deviceWidth = UIScreen.main.bounds.width
    
    var body: some View {
        TaskListPage()
//        TabView {
//            TaskListPage()
//                .padding(.bottom,15)
//            .tabItem {
//                Image(systemName: "list.bullet")
//                Text("タスク一覧")
//            }
//
//            ToDoListPage()
//            .tabItem {
//                Image(systemName: "checkmark.square")
//                Text("todo")
//            }
//        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

