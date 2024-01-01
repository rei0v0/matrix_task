//
//  AddTaskPage.swift
//  matrix_todo
//
//  Created by 濵川怜 on 2023/11/02.
//

import SwiftUI
import RealmSwift

struct AddTaskPage: View {
    
    @State var inputName = ""
    @State var numCheckList = 0
    @State var checkList:[CheckItem] = []
    @State var states:[Bool]=[]
    @State var detail = ""
    @State var isOn:[Bool] = [false,false,false]
    @State var selectedDate: [Date] = [Date(),Date(),Date()]
    @State var taskType :[Bool]=[false,true,false,false]
    
    var editingTask: Task?
    var isEditingMode: Bool {
        self.editingTask != nil
    }
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var taskDB = TaskDB.shared
    
    init(editingTask: Task? = nil) {
        self.editingTask = editingTask
        loadData()
    }
    
    var body: some View {
        ScrollView{
            VStack{
                Group{
                    HStack{
                        Image(systemName: "chevron.down")
                            .resizable()
                            .font(Font.title.weight(.semibold))
                            .frame(width: 60, height: 20)
                            .foregroundColor(Color(0xDCDCDC))
                    }.padding(.top,10)
                    
                    HStack{
                        Button {
                            self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .font(Font.title.weight(.regular))
                                .frame(width: 25, height: 25)
                                .foregroundColor(.black)
                        }
                        .padding(.leading, 15)
                        Spacer()
                        Button {
                            
                            if (self.isEditingMode){
                                print("実行されている")
                                self.updateTask()
                                
                            }else{
                                self.saveData()
                            }
                            self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("保存")
                                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                .font(.footnote)
                                .foregroundColor(.white)
                                .background(Color(.blue))
                                .cornerRadius(50)
                                .padding(.trailing,10)
                        }
                        .padding(.leading, 15)
                        
                    }
                }
                        
                Group{
                    TextField("タイトルを追加", text: $inputName)
                        .font(.system(size: 25))
                        .padding()
                    Divider()
                }
                Group{
                    HStack{
                        Button(action: {
                            taskType = [true,false,false,false]
                        }) {
                            Text("緊急ではないが重要")
                                .font(.footnote)
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.black)
                                .background(taskType[0] ? Color(0xE8F5B1) : Color.white)
                                .cornerRadius(25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25).stroke(Color.gray, lineWidth: 1)
                                )
                        }
                        
                        Spacer()
                        Button(action: {
                            taskType = [false,true,false,false]
                        }) {
                            Text("重要かつ緊急")
                                .font(.footnote)
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.black)
                                .background(taskType[1] ? Color(0xFFD4D4) : Color.white)
                                .cornerRadius(25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25).stroke(Color.gray, lineWidth: 1)
                                )
                        }
                        
                    }.padding(.horizontal,20)
                    HStack{
                        Button(action: {
                            taskType = [false,false,true,false]
                        }) {
                            Text("重要でも緊急でもない")
                                .font(.footnote)
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.black)
                                .background(taskType[2] ? Color(0xEAEAEA) : Color.white)
                                .cornerRadius(25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25).stroke(Color.gray, lineWidth: 1)
                                )
                                
                        }
                        
                        Spacer()
                        Button(action: {
                            taskType = [false,false,false,true]
                        }) {
                            Text("重要ではないが緊急")
                                .font(.footnote)
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.black)
                                .background(taskType[3] ? Color(0xE0F0FF) : Color.white)
                                .cornerRadius(25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25).stroke(Color.gray, lineWidth: 1)
                                )
                        }
                        
                    }.padding(.horizontal,20)
                    Divider()
                    
                }

                Group{
                    ForEach(0..<numCheckList,id: \.self) { i in
                        
                        HStack{
                            Image(systemName: "square")
                                .resizable()
                                .font(Font.title.weight(.regular))
                                .frame(width: 20, height: 20)
                                .foregroundColor(.gray)
                            
                            TextField("",
                                      text: $checkList[i].title,
                                        onEditingChanged: { isEditing in
                                if isEditing {
                                    states[i]=true
                                }else{
                                    states[i]=false
                                }
                            })
                                .font(.system(size: 20))
                                .padding()
                            
                            if states[i]{
                                Button {
                                    numCheckList -= 1
                                    checkList.remove(at: i)
                                    states.remove(at: i)
                                } label: {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .font(Font.title.weight(.regular))
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.black)
                                }
                                
                            }
                            
                        }
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    }
                }
                
                       
                Group{
                    Button {
                        numCheckList += 1
                        let newCheckItem = CheckItem()
                        newCheckItem.title = ""
                        checkList.append(newCheckItem)
                        states.append(false)
                    } label: {
                        HStack{
                            Image(systemName: "plus")
                                .resizable()
                                .font(Font.title.weight(.regular))
                                .frame(width: 20, height: 20)
                                .foregroundColor(.gray)
                            Text("チェックリスト")
                                .font(.title2)
                                .foregroundColor(.gray)
                            Spacer()
                        }.padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 0))
                        
                    }
                    Divider()
                }
                        
                Group{
                    HStack(alignment: .center){
                        Image(systemName: "text.justify.leading")
                            .resizable()
                            .font(Font.title.weight(.regular))
                            .frame(width: 20, height: 20)
                            .foregroundColor(.gray)
                        
                        TextField("詳細を追加", text: $detail,axis: .vertical)
                            .font(.system(size: 20))
                            .padding()
                        
                    }.padding(.leading,20)
                    
                    Divider()
                }
                Group{
                    HStack(alignment: .top){
                        Image(systemName: "clock")
                            .resizable()
                            .font(Font.title.weight(.regular))
                            .frame(width:30, height: 30)
                            .foregroundColor(.gray)
                        VStack(alignment: .leading) {
                            Text("開始期限")
                                .font(.system(size: 23))
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                                        
                            if(isOn[0]){
                                DatePicker(selection: $selectedDate[0],
                                    displayedComponents: [.date], label: {})
                                    .environment(\.locale, Locale(identifier: "ja_JP"))
                                    .font(.system(size: 30))
                                    .labelsHidden()
                                    .disabled(false)
                                            
                                }
                                        
                            }
                                    
                            Spacer()
                            Toggle(isOn: $isOn[0]){}
                                .tint(.blue)
                    }.padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                    
                    Divider()
                }
                        
                Group{
                    HStack(alignment: .top){
                        Image(systemName: "clock")
                            .resizable()
                            .font(Font.title.weight(.regular))
                            .frame(width:30, height: 30)
                            .foregroundColor(.gray)
                        VStack(alignment: .leading) {
                            Text("中間期限")
                                .font(.system(size: 23))
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                                        
                            if(isOn[1]){
                                DatePicker(selection: $selectedDate[1],
                                    displayedComponents: [.date], label: {})
                                    .environment(\.locale, Locale(identifier: "ja_JP"))
                                    .font(.system(size: 30))
                                    .labelsHidden()
                                    .disabled(false)
                                            
                                }
                            }
                                    
                            Spacer()
                            Toggle(isOn: $isOn[1]){}
                                .tint(.blue)
                    }.padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                    
                    Divider()
                }
                Group{
                    HStack(alignment: .top){
                        Image(systemName: "clock")
                            .resizable()
                            .font(Font.title.weight(.regular))
                            .frame(width:30, height: 30)
                            .foregroundColor(.gray)
                        VStack(alignment: .leading) {
                            Text("最終期限")
                                .font(.system(size: 23))
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                                        
                            if(isOn[2]){
                                DatePicker(selection: $selectedDate[2],
                                    displayedComponents: [.date], label: {})
                                    .environment(\.locale, Locale(identifier: "ja_JP"))
                                    .font(.system(size: 30))
                                    .labelsHidden()
                                    .disabled(false)
                                            
                                }
                                        
                            }
                                    
                            Spacer()
                            Toggle(isOn: $isOn[2]){}
                                .tint(.blue)
                    }.padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                    
                    Divider()
                }
                        
                Spacer()
                        
            }
            .onAppear {
                loadData()
            }
        }
        
    }
    
    func loadData() {
        if let task = editingTask {
                // 編集するタスクのデータを読み込む
            self.inputName = task.title
            self.numCheckList = task.checkList.count
            for checkItem in task.checkList {
                self.checkList.append(checkItem)
                self.states.append(false)
            }
            self.detail = task.detail ?? ""
            if(task.startDeadline != nil){
                self.selectedDate[0] = task.startDeadline ?? Date()
                self.isOn[0]=true
                
            }
            if(task.middleDeadline != nil){
                self.selectedDate[1] = task.middleDeadline ?? Date()
                self.isOn[1]=true
            }
            if(task.finalDeadline != nil)
            {
                self.selectedDate[2] = task.finalDeadline ?? Date()
                self.isOn[2]=true
            }
            self.taskType = [false,false,false,false]
            self.taskType[task.type] = true
                // ... 他のフィールドも同様に読み込む ...
        }
    }
    
    
    func saveData(){
        
        taskDB.reset()
        
        let index = taskType.firstIndex(of: true)
        taskDB.title = inputName
        taskDB.type = index ?? 1
        taskDB.detail = detail
        taskDB.checkList = checkList
        taskDB.startDeadline = isOn[0] ? selectedDate[0] : nil
        taskDB.middleDeadline = isOn[1] ? selectedDate[1] : nil
        taskDB.finalDeadline = isOn[2] ? selectedDate[2] : nil
        
        taskDB.addData()
    }
    
    func updateTask(){
        
        taskDB.reset()
        let index = taskType.firstIndex(of: true)
        if let editingTask = self.editingTask {
            let realm = try! Realm()
            try! realm.write {
                editingTask.title = inputName
                editingTask.type = index ?? 1
                editingTask.detail = detail
                
                for checkItem in self.checkList {
                    if editingTask.checkList.contains(where: {$0.id == checkItem.id}){
                        editingTask.checkList.first(where: {$0.id == checkItem.id})?.title = checkItem.title
                    }else{
                        editingTask.checkList.append(checkItem)
                    }
                }
                //不要なcheckItemを削除
                let idsToRemove = editingTask.checkList.filter { item in
                    !self.checkList.contains(where: { $0.id == item.id })
                }
                for item in idsToRemove {
                    if let index = editingTask.checkList.index(of: item) {
                        editingTask.checkList.remove(at: index)
                    }
                }
                
                for item in idsToRemove {
                    realm.delete(item)
                }
                
                
                editingTask.startDeadline = isOn[0] ? selectedDate[0] : nil
                editingTask.middleDeadline = isOn[1] ? selectedDate[1] : nil
                editingTask.finalDeadline = isOn[2] ? selectedDate[2] : nil
            }
        }
    }
}

struct AddTaskPage_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskPage()
    }
}
