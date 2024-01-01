//
//  TaskShowView.swift
//  matrix_todo
//
//  Created by 濵川怜 on 2023/11/10.
//

import SwiftUI
import RealmSwift

struct TaskShowView: View {
    
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    let taskId : ObjectId
    let headerColors:[Color] = [Color(0xB8D24B),Color(0xF9746C),Color(0xBEBEBE),Color(0x7EC1FF)]
    let bodyColors:[Color] = [Color(0xE8F5B1),Color(0xFFD4D4),Color(0xEAEAEA),Color(0xE0F0FF)]
    
    let viewTitle:[String] = ["緊急ではないが重要","重要かつ緊急","重要でも緊急でもない","重要ではないが緊急"]
    
   
    @ObservedObject var taskDB = TaskDB.shared
    @EnvironmentObject var viewController: ViewController
        
    var body: some View {
        let task = taskDB.allTasks.first(where:{$0.id == taskId})
        let checkItems = taskDB.getCheckItmes(taskId: taskId)
        
        ZStack{
            Color.white.opacity(0.3)
            VStack(alignment: .leading){
                Text(viewTitle[task?.type ?? 0])
                    .font(.callout)
                    .padding(.leading,20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 30)
                    .foregroundColor(.white)
                    .background(headerColors[task?.type ?? 0])
                
                ScrollView{
                    if(task != nil) {
                        Text(task!.title)
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.black)
                            .padding(.vertical,10)
                        
                        DeadlinesView(task: task!)
                        VStack{
                            ForEach(checkItems, id: \.self){ checkItem in
                                HStack{
                                    Button(action: {
                                        //taskDB.sampleAdd()
                                        taskDB.updateCheckItem(itemId: checkItem.id)
                                        
                                        //taskDB.sampleUpdate(taskId: taskId)
                                    }) {
                                        Image(systemName: checkItem.isCompleted ?  "checkmark.square" : "square")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .padding(.trailing,10)
                                            .foregroundColor(.black)
                                    }
                                    
                                    Text(checkItem.title)
                                        .font(.subheadline)
                                    Spacer()
                                }.padding(.top,5)
                            }
                            Text(task?.detail ?? "")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }.padding(.vertical,5)
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                .background(.white.opacity(0.7))
                .cornerRadius(20)
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                
                Spacer()
                
                Button(action: {
                    viewController.showDetails = false
                    viewController.selectedTask = nil
                }) {
                    Image(systemName: "xmark")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.black)
                }
                .padding()
                .frame(width: deviceWidth * 0.95)
                .background(Color.gray.opacity(0.2))
            }
            .frame(width: deviceWidth * 0.95, height: deviceHeight * 2 / 3)
            .background(bodyColors[task?.type ?? 0])
            .cornerRadius(20)
        }
    }
    
}

struct TaskShowView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct DeadlinesView: View {
    let task: Task
    let dateFormatter = DateFormatter()
    
    var body: some View {
        let startDeadline = date2String(date: task.startDeadline)
        let middleDeadline = date2String(date: task.middleDeadline)
        let finalDeadline = date2String(date: task.finalDeadline)
        let today = Date()
        VStack{
            if(task.startDeadline != nil){
                HStack() {

                    if(task.startDeadline! >= today){
                        Image(systemName: "circle")
                        Text("開始期限 : \(startDeadline)")
                        .font(.subheadline)
                    }else{
                        Image(systemName: "circle.fill")
                        Text("開始期限 : \(startDeadline)")
                            .strikethrough()
                        .font(.subheadline)
                    }
                        
                    Spacer()
                    
                }.padding(.bottom,3)
            }
            if(task.middleDeadline != nil){
                HStack() {
                    if(task.middleDeadline! >= today){
                        Image(systemName: "circle")
                        Text("中間期限 :  \(middleDeadline)")
                            .font(.subheadline)
                    }else{
                        Image(systemName: "circle.fill")
                        Text("中間期限 :  \(middleDeadline)")
                            .font(.subheadline)
                            .strikethrough()
                    }
                    Spacer()
                    
                }.padding(.bottom,3)
            }
            
            if(task.finalDeadline != nil){
                HStack() {
                    
                    if(task.finalDeadline! >= today){
                        Image(systemName: "circle")
                        Text("最終期限 :  \(finalDeadline)")
                            .font(.subheadline)
                    }else{
                        Image(systemName: "circle.fill")
                        Text("最終期限 :  \(finalDeadline)")
                            .font(.subheadline)
                            .strikethrough()
                    }
                    Spacer()
                    
                }.padding(.bottom,3)
            }
        }
    }
    
    func date2String(date:Date?)-> String{
        if(date == nil) {return ""}
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        return dateFormatter.string(from: date!)
    }
}
