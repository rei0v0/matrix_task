//
//  ExpandedTaskPage.swift
//  matrix_todo
//
//  Created by 濵川怜 on 2023/11/03.
//

import SwiftUI
import RealmSwift

struct ExpandedTaskPage: View {
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    let headerColors:[Color] = [Color(0xB8D24B),Color(0xF9746C),Color(0xBEBEBE),Color(0x7EC1FF)]
    let bodyColors:[Color] = [Color(0xE8F5B1),Color(0xFFD4D4),Color(0xEAEAEA),Color(0xE0F0FF)]
    
    let viewTitle:[String] = ["緊急ではないが重要","重要かつ緊急","重要でも緊急でもない","重要ではないが緊急"]
    
    @StateObject var taskDB = TaskDB.shared
    @EnvironmentObject var viewController: ViewController
    @Binding var isPresented: Bool
    @State var selectedIndex:Int
    @State var opacity: Double = 0
    @State private var isShowAlert: Bool = false
    @State private var isShowEditingPage: Bool = false
    @State var targetTask : Task? = nil
    
    
    var body: some View {
       
        let taskData = taskDB.tasksForSelectedIndex(selectedIndex)
        
        ZStack{
            Color.white.opacity(0.3)
            VStack{
                Text(viewTitle[selectedIndex])
                    .font(.callout)
                    .padding(.leading,20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 30)
                    .foregroundColor(.white)
                    .background(headerColors[selectedIndex])
                
                if(taskData == []){
                    Spacer()
                    Text("No tasks")
                }else{
                    ScrollView{
                        ForEach(0..<taskData.count,id: \.self) { i in
                            TaskCell(task: taskData[i])
                                .onTapGesture {
                                    viewController.selectedTask = taskData[i]
                                    viewController.selectedTaskId = taskData[i].id
                                    viewController.showDetails = true
                                }
                                .onLongPressGesture(minimumDuration: 0.5, perform: {
                                    targetTask = taskData[i]
                                    isShowAlert.toggle()
                                })
                                
                                .padding(.horizontal,10)
                            
                            
                        }
                    }.padding(.top,10)
                }
                
                Spacer()
                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "xmark")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.black)
                }
                .padding()
                .frame(width: deviceWidth * 0.95)
                .background(Color.gray.opacity(0.2))
                
                
            }

            .frame(width: deviceWidth * 0.95,height: deviceHeight * 2 / 3)
            .background(bodyColors[selectedIndex])
            .cornerRadius(20)
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .opacity(self.opacity)
        .onAppear {
            withAnimation(.linear(duration: 0.1)) {
                self.opacity = 1.0
            }
        }
        
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

struct ExpandedTaskPage_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
