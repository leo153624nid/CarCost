//
//  ExpensesView.swift
//  CarCost
//
//  Created by macbook on 29.01.2023.
//

import SwiftUI

struct ExpensesView: View {
    @EnvironmentObject var car: Car
    @State private var selectedSection = "Fuel"
    let sections = ["All", "Fuel", "Service", "Other"]
    
    var body: some View {
        let calendar = Calendar.current
        // Массив уникальных дат (по годам) всех расходов
        let arrOfYear = Array(Set(car.allExpenses.map { calendar.component(.year, from: $0.date) }))
        
        return
            NavigationView {
                VStack {
                    HeaderPicker(sections: sections, selectedSection: $selectedSection)
                    
                    List {
                        switch self.selectedSection {
                            case "All":
                                ForEach(arrOfYear, id: \.self) { item in
                                    Section(header: Text("\(item)")) {
                                        ExpensePosts(dataArr: car.allExpenses.filter {
                                            calendar.component(.year, from: $0.date) == item
                                        })
                                    }
                                }
                            case "Fuel":
                                ExpensePosts(dataArr: car.fuelExpenses)
                            case "Service":
                                ExpensePosts(dataArr: car.serviceExpenses)
                            case "Other":
                                ExpensePosts(dataArr: car.otherExpenses)
                            default:
                                ExpensePosts(dataArr: car.allExpenses )
                        }
                    }.listStyle(GroupedListStyle())
                    Spacer()
                }
                .navigationBarTitle("\(car.name)", displayMode: .inline)
            }
    }
}

struct ExpensePosts: View {
    let dataArr: [EI]
    
    
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



//struct ExpensesView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExpensesView(car: Car(name: "test", mileage: 1, averageFuel: 2, averageCost: 3))
//    }
//}


