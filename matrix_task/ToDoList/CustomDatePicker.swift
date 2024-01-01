//
//  CustomDatePicker.swift
//  matrix_todo
//
//  Created by 濵川怜 on 2023/10/19.
//

import SwiftUI

struct CustomDatePicker: View {
    @Binding var currentDate: Date
    
    //Days
    let days:[String] = ["日","月","火","水","木","金","土"]
    @State var currentMonth : Int = 0
    
    var body: some View {
        
        //Year, Month and Bottons...
        VStack(spacing: 35) {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(extraDate()[0])
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    Text("\(extraDate()[1])月")
                        .font(.title.bold())
                }
                
                Spacer(minLength: 0)
                
                Button {
                    withAnimation {
                        currentMonth -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                
                Button {
                    withAnimation {
                        currentMonth += 1
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }
            }
            .padding()
        }
        
        //Day View...
        HStack(spacing: 0) {
            ForEach(days, id: \.self){day in
                Text(day)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
            }
        }
        
        HStack(spacing: 0) {
            
        }
        
        let columns = Array(repeating: GridItem(.flexible()), count: 7)
        LazyVGrid(columns: columns, spacing: 15) {
            ForEach(extractDate()){value in
                CardView(value: value)
            }
        }
        .gesture(
            DragGesture(minimumDistance: 10, coordinateSpace: .local)
                .onEnded { value in
                    if value.translation.width < 0 {
                        withAnimation {
                            currentMonth -= 1
                        }
                    } else {
                        withAnimation {
                            currentMonth += 1
                        }
                    }
                }
        )
        .onChange(of: currentMonth) { newValue in
            currentDate = getCurrentMonth()
        }
        
//        VStack(spacing: 15) {
//
//            HStack {
//                Text("todoリスト")
//                    .font(.title2.bold())
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.horizontal,5)
//                Spacer()
//
//                Text("2023/10/19")
//                    .font(.title2.bold())
//                    .padding(.horizontal,10)
//
//            }
//            .padding(.vertical,10)
//
//
//            ToDoCard()
//            ToDoCard()
//            ToDoCard()
//            ToDoCard()
//            ToDoCard()
//
//        }
//        .padding()
//        .background(Color(.white))
//        .cornerRadius(40)
//        .shadow(color: .gray, radius: 5, x: 3, y: 3)
//
        
    }
    
    @ViewBuilder
    func CardView(value: DateValue)  -> some View {
        
        VStack {
            if value.day != -1 {
                Text("\(value.day)")
                    .font(.title3.bold())
            }
        }
        .padding(.vertical, 8)
        .frame(height: 40, alignment: .top)
        
    }
    
    func getCurrentMonth()-> Date {
        
        let calender = Calendar.current
        
        guard let currentMonth = calender.date(byAdding: .month,value: self.currentMonth, to: Date()) else{
            return Date()
        }
        
        return currentMonth
    }
    
    func extraDate()->[String]{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MM"
        
        let date = formatter.string(from: currentDate)
        return date.components(separatedBy: " ")
    }
    
    func extractDate()-> [DateValue]{
        
        let calender = Calendar.current
        
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap{date -> DateValue in
            let day = calender.component(.day, from: date)
            
            return DateValue(day: day, date: date)
        }
        
        let firstWeekday = calender.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        return days
    }
}

struct CustomDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListPage()
    }
}

extension Date {
    func getAllDates()->[Date] {
        let calendar = Calendar.current
        
        let startDate = calendar.date(from:Calendar.current.dateComponents([.year, .month], from: self))!
                                      
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        return range.compactMap{day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
}
