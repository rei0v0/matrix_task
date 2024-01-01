//
//  Task.swift
//  matrix_todo
//
//  Created by 濵川怜 on 2023/11/02.
//

import SwiftUI

struct TaskCell: View {
    let task: Task
    
    var body: some View {
        let deadlineType  = deadlineType()
        let deadline = checkDeadline()
        VStack{
            
            //title
            HStack{
                Text(task.title)
                    .font(.caption)
                Spacer()
               
            }.padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 0))
            
            
            //deadline
            HStack(alignment: .top){
                Text(deadlineType)
                    .font(.caption2)
                
                Spacer()
                Text(deadline)
                    .font(.caption2)
            }.padding(EdgeInsets(top: 1, leading: 10, bottom: 0, trailing: 10))
            //step ProgressBar
            if 2 < self.countCheckItem(){
                GeometryReader{ geometry in
                    StepProgressBar(geo: geometry, numPoint: self.countCheckItem(), isFinish: self.isValidList())
                }.padding(EdgeInsets(top: 2, leading: 15, bottom: 5, trailing: 15))
            }else{
                CheckListView(checkItem: Array(task.checkList),task: task)
                    .padding(.bottom,10)
                
                
            }
            
        }
        .frame(maxWidth: .infinity)
        .background(Color(0xFFFFFF,alpha: 0.7))
        .cornerRadius(10)
    }
    
    func countCheckItem() -> Int{
        //print(self.task.checkList.count)
        return self.task.checkList.count
    }
    
    func isValidList() -> [Bool]{
        var isFinished:[Bool] = []
        for checkItem in task.checkList {
            if checkItem.isCompleted {
                isFinished.append(true)
            }else{
                isFinished.append(false)
            }
        }
        isFinished.sort(by: { $0 && !$1 })
        return isFinished
    }
    
    func checkDeadline() -> String{
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        if(task.startDeadline != nil && task.startDeadline! >= today){
            return dateFormatter.string(from: task.startDeadline!)
        }
        if(task.middleDeadline != nil && task.middleDeadline! >= today){
            return dateFormatter.string(from: task.middleDeadline!)
        }
        if(task.finalDeadline != nil && task.finalDeadline! >= today){
            return dateFormatter.string(from: task.finalDeadline!)
        }
        if(task.finalDeadline != nil){
            return "期限切れ"
        }
        return "なし"
    }
    func deadlineType() -> String{
        let today = Date()
        
        if(task.startDeadline != nil && task.startDeadline! >= today){
            return "開始期限"
        }
        if(task.middleDeadline != nil && task.middleDeadline! >= today){
            return "中間期限"
        }
        if(task.finalDeadline != nil && task.finalDeadline! >= today){
            return "最終期限"
        }
        return "期限"
    }
}

struct Task_Previews: PreviewProvider {
    static var previews: some View {
       ContentView()
    }
}

struct StepProgressBar: View {
    let geo: GeometryProxy
    var numPoint: Int
    var isFinish:[Bool]
    var body: some View {
        let lenght = (geo.size.width) / CGFloat(numPoint-1)
        let position = CGFloat(0)
        
        
        if numPoint == 2 {
            ZStack{
                let lineColor = isFinish[1] ? Color(0xA2EA81):Color(0x999999)
                Path { path in
                    path.move(to: CGPoint(x: position + lenght*CGFloat(0), y: 0))
                    path.addLine(to: CGPoint(x: position + lenght/3*CGFloat(1), y: 0))
                }
                .stroke(lineColor,lineWidth: 2)
            
                Path { path in
                    path.addArc(center: CGPoint(x: position + lenght*CGFloat(0), y: 0), radius: 5,startAngle: Angle.degrees(0),endAngle: .degrees(360),clockwise: false)
                }
                .fill(isFinish[0] ? Color(0xA2EA81):Color(0x999999))
                
                
                Path { path in
                    path.addArc(center: CGPoint(x: position + lenght/3*CGFloat(1), y: 0), radius: 5,startAngle: Angle.degrees(0),endAngle: .degrees(360),clockwise: false)
                }
                .fill(isFinish[1] ? Color(0xA2EA81):Color(0x999999))
                
            }
        }else{
            ZStack{
                ForEach(0..<(numPoint-1),id: \.self) {i in
                    let lineColor = isFinish[i+1] ? Color(0xA2EA81):Color(0x999999)
                    Path { path in
                        
                        path.move(to: CGPoint(x: position + lenght*CGFloat(i), y: 0))
                        path.addLine(to: CGPoint(x: position + lenght*CGFloat(i+1), y: 0))
                    }
                    .stroke(lineColor,lineWidth: 2)
                    
                    
                }
            
                ForEach(0..<(numPoint),id: \.self) {i in
                    let circleColor = isFinish[i] ? Color(0xA2EA81):Color(0x999999)
                    Path { path in
                        path.addArc(center: CGPoint(x: position + lenght*CGFloat(i), y: 0), radius: 5,startAngle: Angle.degrees(0),endAngle: .degrees(360),clockwise: false)
                    }
                    .fill(circleColor)
                    
                }
                
            }
        }
    }
}

struct CheckListView: View {
    let checkItem:[CheckItem]
    let task: Task
    var body: some View {
        VStack {
            
            ForEach(0..<task.checkList.count, id: \.self) { index in

                HStack{
                    Image(systemName: task.checkList[index].isCompleted ? "checkmark.square" : "square")
                        .resizable()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.black)
                    Text(task.checkList[index].title)
                        .font(.caption2)
                    
                    Spacer()
                }.padding(EdgeInsets(top: 2, leading: 10, bottom: 0, trailing: 15))
            }
        }
    }
}
