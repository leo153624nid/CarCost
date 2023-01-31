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
        let calendar = Calendar.current
        // Массив уникальных дат (по годам) всех расходов
        let arrOfYear = Array(Set(car.allExpenses.map {
            [calendar.component(.year, from: $0.date)]
        })).sorted(by: { $0[0] > $1[0] })
        
        // Массив уникальных дат (по годам и месяцам) всех расходов
        let arrOfMonth = Array(Set(car.allExpenses.map {
            [calendar.component(.year, from: $0.date), calendar.component(.month, from: $0.date)]
        })).sorted(by: { $0[0] > $1[0] })
        
        // Массив дат меняется в зависимости от выбранной секции
        var arrOfTimePeriod = [[Int]]()
        switch self.selectedSection {
            case "Month": arrOfTimePeriod = arrOfMonth
            case "Year": arrOfTimePeriod = arrOfYear
            case "Total": arrOfTimePeriod = [arrOfMonth.last!] // TODO
            default: arrOfTimePeriod = arrOfMonth
        }
        
        return
            List {
                ForEach(arrOfTimePeriod, id: \.self) { timePeriod in
                    Section(header: Text(translateDate(array: timePeriod))) {
                        ForEach(car.allExpenses.filter {
                            var condition = false
                            switch self.selectedSection {
                                case "Month": condition = calendar.component(.year, from: $0.date) == timePeriod[0] && calendar.component(.month, from: $0.date) == timePeriod[1]
                                case "Year": condition = calendar.component(.year, from: $0.date) == timePeriod[0]
                                case "Total": condition = true
                                default: condition = false
                            }
                            return condition   
                        }, id: \.id) { post in
                            HStack { // !!! TODO !!!
                                VStack(alignment: .leading) {
                                    Text("\(post.description)")
                                    Text("\(post.mileage) km")
                                }
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text("\(post.date.description)")
                                    Text("$\(post.cost)")
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
