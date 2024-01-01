//
//  TaksListPage.swift
//  matrix_todo
//
//  Created by 濵川怜 on 2023/10/17.
//

import SwiftUI
import RealmSwift

struct TaskListPage: View {
    let deviceWidth = UIScreen.main.bounds.width
    let deviceHeight = UIScreen.main.bounds.height
    let headerColors:[Color] = [Color(0xB8D24B),Color(0xF9746C),Color(0xBEBEBE),Color(0x7EC1FF)]
    let bodyColors:[Color] = [Color(0xE8F5B1),Color(0xFFD4D4),Color(0xEAEAEA),Color(0xE0F0FF)]
    @State var isPresented = false
    @State var isShowedDetail = false
    @State var showDetails = false
    @State var selectedIndex = 0
    @StateObject var taskDB = TaskDB.shared
    @EnvironmentObject var viewController: ViewController
    
    var body: some View {
        
        VStack{
            AppBar()
            ZStack {
                VStack{
                    
                    HStack(spacing: 0.0){
                        Spacer().frame(width: 10)
                        
                        TaskBoard(title: "緊急ではないが重要",headerColor: headerColors[0],bodyColor: bodyColors[0], index: 0,isPresented: $isPresented, isShowedDetail: $isShowedDetail, selectedIndex: $selectedIndex
                        )
                        
                        Spacer().frame(width: 10.0)
                        
                        TaskBoard(title: "重要かつ緊急", headerColor: headerColors[1], bodyColor: bodyColors[1], index: 1,isPresented: $isPresented, isShowedDetail: $isShowedDetail, selectedIndex: $selectedIndex
                        )
                        
                        Spacer().frame(width: 10)
                    }
                    
                    HStack(spacing: 0.0){
                        Spacer().frame(width: 10)
                        TaskBoard(
                            title:"重要でも緊急でもない", headerColor: headerColors[2], bodyColor: bodyColors[2], index: 2,isPresented: $isPresented, isShowedDetail: $isShowedDetail, selectedIndex: $selectedIndex
                        )
                        
                        Spacer().frame(width: 10.0)
                        
                        TaskBoard(title: "重要ではないが緊急", headerColor: headerColors[3], bodyColor: bodyColors[3], index: 3,isPresented: $isPresented, isShowedDetail: $isShowedDetail, selectedIndex: $selectedIndex
                        )
                    
                        Spacer().frame(width: 10)
                    }
                }
                if isPresented {
                    
                    switch selectedIndex{
                    case 0:
                        ExpandedTaskPage(isPresented: $isPresented,selectedIndex: selectedIndex)
                    case 1:
                        ExpandedTaskPage(isPresented: $isPresented,selectedIndex: selectedIndex)
                    case 2:
                        ExpandedTaskPage(isPresented: $isPresented,selectedIndex: selectedIndex)
                    case 3:
                        ExpandedTaskPage(isPresented: $isPresented,selectedIndex: selectedIndex)
                    default:
                        ExpandedTaskPage(isPresented: $isPresented,selectedIndex: selectedIndex)
                    }
                    
                }
                
                if viewController.showDetails {
                    if (viewController.selectedTaskId != nil){
                        TaskShowView(taskId: viewController.selectedTaskId!)
                    }
                }
            }
        }
        
    }
}

struct TaskListPage_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
extension Color {
  init(_ hex: UInt, alpha: Double = 1) {
    self.init(
      .sRGB,
      red: Double((hex >> 16) & 0xFF) / 255,
      green: Double((hex >> 8) & 0xFF) / 255,
      blue: Double(hex & 0xFF) / 255,
      opacity: alpha
    )
  }
}

struct TaskBoard: View {
    
    let title:String
    let headerColor : Color
    let bodyColor : Color
    let index: Int
    @Binding var isPresented: Bool
    @Binding var isShowedDetail: Bool
    @Binding var selectedIndex: Int
    @State private var isShowAlert: Bool = false
    @State private var isShowEditingPage: Bool = false
    @State var targetTask : Task? = nil
    @StateObject var taskDB = TaskDB.shared
    @EnvironmentObject var viewController: ViewController
    
    var body: some View {
        let taskData = taskDB.tasksForSelectedIndex(index)
        VStack{
            Text(title)
                .font(.system(size: 12))
                .padding(.leading,10)
                .frame(height: 30)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.white)
                .background(headerColor)
            if(taskData.count > 0){
                ScrollView{
                    ForEach(0..<taskData.count,id: \.self) { i in
                        TaskCell(task:taskData[i])
                            .onTapGesture {
                                viewController.selectedTask = taskData[i]
                                viewController.selectedTaskId = taskData[i].id
                                viewController.showDetails = true
                            }
                            .onLongPressGesture(minimumDuration: 0.5, perform: {
                                targetTask = taskData[i]
                                isShowAlert.toggle()
                            })
                            .padding(.horizontal,3)
                    }
                }
            }else{
                Text("No tasks").frame(maxHeight: .infinity).foregroundColor(.black.opacity(0.7))
            }
           
            
            Spacer()
            HStack{
                Spacer()
                Button {
                    isPresented = true
                    selectedIndex = index
                } label: {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.gray)
                }
                .padding(.all,10)
                
            }
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(bodyColor)
        .cornerRadius(10)
        .alert(targetTask?.title ?? "",isPresented: $isShowAlert) {
            Button("タスクを削除", role: .destructive) {
                if(targetTask != nil){taskDB.removeData(targetTask: self.targetTask!)}
                targetTask = nil
                isShowAlert.toggle()
            }
            Button("タスクを編集") {
                isShowEditingPage.toggle()
            }

        } message: {
            Text("操作を選択して下さい")
        }
        .sheet(isPresented: $isShowEditingPage) { //フルスクリーンの画面遷移
            if(targetTask != nil){
                AddTaskPage(editingTask: targetTask!)

            }
            
        }
        
    }
    
}

struct AppBar: View {
    @State private var isPresented: Bool = false
    var body: some View {
        ZStack {
            HStack{
                Spacer()
                Text("Task")
                    .font(.title)
                    .frame(maxWidth: .infinity)
                    .frame(height: 88)
                    .background(Color(.white))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 88)
            
            HStack{
                Spacer()
                Button {
                    isPresented = true
                    
                } label: {
                    Image(systemName: "square.and.pencil")
                        
                        .resizable()
                        .font(Font.title.weight(.semibold))
                        .frame(width: 30, height: 30)
                        .foregroundColor(.black)
                }
                .padding(.trailing, 25)
                .sheet(isPresented: $isPresented) { //フルスクリーンの画面遷移
                    AddTaskPage()
                }
                
            }
        }
        
    }
}

