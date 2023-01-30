//
//  StatisticView.swift
//  CarCost
//
//  Created by macbook on 29.01.2023.
//

import SwiftUI

struct StatisticView: View {
    @EnvironmentObject var car: Car
    @State private var selectedSection = "Month"
    let sections = ["Month", "Year", "Total"]
    
    var body: some View {
            NavigationView {
                VStack {
                    HeaderPicker(sections: sections, selectedSection: $selectedSection)
                    
                    StatisticPosts(selectedSection: $selectedSection)
                    Spacer()
                }
                .navigationBarTitle("Statistic", displayMode: .inline)
            }
    }
}

struct StatisticPosts: View {
    @EnvironmentObject var car : Car
    @Binding var selectedSection : String
    
    var body: some View {
        // Массив данных меняется в зависимости от выбранной секции
        var dataArr = [EI]()
        switch self.selectedSection { // !!! TODO !!!
            case "Month": dataArr = car.allExpenses
            case "Year": dataArr = car.allExpenses
            case "Total": dataArr = car.allExpenses
            default: dataArr = car.allExpenses
        }
        
        let calendar = Calendar.current
        // Массив уникальных дат (по годам) всех расходов
        let arrOfYear = Array(Set(dataArr.map { calendar.component(.year, from: $0.date) }))
        
        return
            List {
                ForEach(arrOfYear, id: \.self) { timePeriod in
                    Section(header: Text("\(timePeriod)")) {
                        ForEach(dataArr.filter {
                            calendar.component(.year, from: $0.date) == timePeriod
                        }, id: \.id) { item in
                            HStack { // !!! TODO !!!
                                VStack(alignment: .leading) {
                                    Text("\(item.description)")
                                    Text("\(item.mileage) km")
                                }
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text("\(item.date.description)")
                                    Text("$\(item.cost)")
                                }
                            }
                        }
                    }
                }
            }.listStyle(GroupedListStyle())
    }
}

//struct StatisticView_Previews: PreviewProvider {
//    static var previews: some View {
//        StatisticView()
//    }
//}
