//
//  ToDoCard.swift
//  matrix_todo
//
//  Created by 濵川怜 on 2023/10/19.
//

import SwiftUI

struct ToDoCard: View {
    var body: some View {
        HStack(alignment: .center){
            Button(action: {
                print("tapped!!")
            }, label: {
                Image(systemName: "circle")
                    .resizable().frame(width: 20,height: 20)
                    .foregroundColor(.teal)
                    .padding(.horizontal,5)
            })
            HStack{
                VStack(alignment: .leading){
                    
                    HStack(spacing: 5){
                        Text("緊急").font(.subheadline.weight(Font.Weight.light))
                            .padding(.horizontal,20)
                            .padding(.vertical,5)
                            .background(Color.pink.opacity(0.3))
                            .cornerRadius(50)
                        
                        Text("重要").font(.subheadline.weight(Font.Weight.light))
                            .padding(.horizontal,20)
                            .padding(.vertical,5)
                            .background(Color.pink.opacity(0.3))
                            .cornerRadius(50)
                    }
                    
                    Text("task's title").font(.title.bold())
                    Text("SwiftUI")
                }
                Spacer()
            }
            .padding(.horizontal,20)
            .padding(.vertical,5)
            .background(Color.cyan.opacity(0.3))
            .cornerRadius(15)
            
        }
    }
}

struct ToDoCard_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListPage()
    }
}
