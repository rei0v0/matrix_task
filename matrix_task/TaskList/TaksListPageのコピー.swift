//
//  TaksListPage.swift
//  matrix_todo
//
//  Created by 濵川怜 on 2023/10/17.
//

import SwiftUI
import Charts

struct TaskListPage: View {
    let deviceWidth = UIScreen.main.bounds.width
    @State private var selectedDataPoint: ChartEntry? = nil
    var body: some View {
        VStack{
            ChartView()
            TaskListView()
        }.ignoresSafeArea() 
    }
}

struct TaskListPage_Previews: PreviewProvider {
    static var previews: some View {
        TaskListPage()
    }
}

struct ChartView: View {
    
    let tasks : [Task] = [
    
    ]
    let data_test: [ChartEntry] = [
        .init(title: "A", xValue: 1.0,yValue: 1.0),
        .init(title: "A", xValue: 0.1, yValue: -0.2,color: .blue),
        .init(title: "B", xValue: -0.3, yValue: 0.4),
        .init(title: "B", xValue: -0.3, yValue: 0.5),
        .init(title: "C", xValue: -0.4,yValue: -0.5)
    ]
    var body: some View {
        Chart {
            ForEach(data_test) { dataPoint in
                PointMark(
                    x: .value("緊急度", dataPoint.xValue),
                    y: .value("重要度", dataPoint.yValue)
                )
                .foregroundStyle(dataPoint.color)
            }
            
            RuleMark(
                y:.value("average", 0)
            )
            .lineStyle(StrokeStyle(lineWidth: 1))
            RuleMark(
                x:.value("average", 0)
            )
            .lineStyle(StrokeStyle(lineWidth: 1))
        }
        .chartXAxis{
            AxisMarks(values: [-1,0,1,]){
                AxisGridLine()
            }
        }
        .chartYAxis{
            AxisMarks(values: [-1,0,1,]){
                AxisGridLine()
            }
        }
        .chartXAxisLabel(position: .trailing, spacing: 3){
            Text("緊急度(高)").font(.system(size: 15)).foregroundColor(Color.black.opacity(0.8))
        }
        .chartXAxisLabel(position: .leading)
        {
            Text("緊急度(低)").font(.system(size: 15)).foregroundColor(Color.black.opacity(0.8))
        }
        .chartYAxisLabel(alignment: .center){
            Text("重要度(高)").font(.system(size: 15)).foregroundColor(Color.black.opacity(0.8))
        }
        .chartXAxisLabel(alignment: .center){
            Text("重要度(低)").font(.system(size: 15)).foregroundColor(Color.black.opacity(0.8))
        }
        .frame(width:300,height: 200)
//        .chartOverlay { proxy in
//            ZStack(alignment: .top) {
//                Rectangle().fill(Color.clear).contentShape(Rectangle())
//                    .onTapGesture { location in
//                        updateSelectedDataPoint(at: location, proxy: proxy)
//                    }
//            }
//        }
    }
}


struct TaskListView: View {
    @State public var select = 0
    var body: some View {
        VStack {
            Picker(selection: $select, label: Text("Select Background")) {
                Text("A").tag(0)
                Text("B").tag(1)
                Text("C").tag(2)
                Text("D").tag(3)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(EdgeInsets(top: 40, leading: 20, bottom: 10, trailing: 20))
            List(0..<20) { i in
                HStack {
                    Text("ユーザー\(String(format: "%02d", i + 1))")
                    Spacer()
                    Text("残り4日").foregroundColor(.gray)
                }
                
            }
            .listStyle(.plain)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
        .background(Color(.white))
        .cornerRadius(40.0)
        .shadow(color: .gray, radius: 5, x: 2, y: -2)
    }
}

