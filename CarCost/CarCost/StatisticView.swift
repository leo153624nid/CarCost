//
//  StatisticView.swift
//  CarCost
//
//  Created by macbook on 29.01.2023.
//

import SwiftUI

struct StatisticView: View {
    @State private var selectedSection = "Month"
    let sections = ["Month", "Year", "Total"]
    
    @EnvironmentObject var car: Car
    
    var body: some View {
        // Массив уникальных дат (по годам) всех расходов
        let arrOfYear = Array(Set(car.allExpenses.map { Calendar.current.component(.year, from: $0.date) }))
        
        return
            NavigationView {
                VStack {
                    HeaderPicker(sections: sections, selectedSection: $selectedSection)
                    
                    List {
                        switch self.selectedSection {
                            case "Month":
                                StatisticPosts(dataArr: car.allExpenses )
                            case "Year":
                                ForEach(arrOfYear, id: \.self) { item in
                                    Section(header: Text("\(item)")) {
                                        StatisticPosts(dataArr: car.allExpenses.filter {
                                            Calendar.current.component(.year, from: $0.date) == item
                                        })
                                    }
                                }
                            case "Total":
                                StatisticPosts(dataArr: car.allExpenses)
                            default:
                                StatisticPosts(dataArr: car.allExpenses )
                        }
                    }.listStyle(GroupedListStyle())
                    Spacer()
                }
                .navigationBarTitle("Statistic", displayMode: .inline)
            }
    }
}

struct StatisticPosts: View {
    let dataArr: [EI]
    var dataArrSorted: [EI] {
        return [EI]()
    }
    
    var body: some View {
        ForEach(dataArr, id: \.id) { item in
            HStack {
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

//struct StatisticView_Previews: PreviewProvider {
//    static var previews: some View {
//        StatisticView()
//    }
//}
