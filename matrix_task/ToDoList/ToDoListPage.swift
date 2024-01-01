//
//  ToDoListPage.swift
//  matrix_todo
//
//  Created by 濵川怜 on 2023/10/17.
//

import SwiftUI

struct ToDoListPage: View {
    
    @State var currentDate: Date = Date()
    
    var body: some View {
        
        ZStack{
            VStack(spacing: 20) {
                CustomDatePicker(currentDate: $currentDate)
                Spacer()
            }
            
            FloatingActionButton()
        }
        
    }
}

struct ToDoListPage_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListPage()
    }
}

struct FloatingActionButton: View {
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Spacer()
                Button(action: {
                    print("tapped!")
                }, label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable().frame(width: 70,height: 70)
                        .background(Color(.white))
                        .cornerRadius(35.0)
                        .foregroundColor(.teal)
                        .shadow(color: .gray, radius: 5, x: 3, y: 3)
                        .padding()
                })
            }
        }
    }
}
