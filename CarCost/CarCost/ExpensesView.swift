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
        NavigationView {
            VStack {
                HeaderPicker(sections: sections, selectedSection: $selectedSection)
                
                ExpensePosts(selectedSection: $selectedSection)
                Spacer()
            }
            .navigationBarTitle("\(car.name)", displayMode: .inline)
        }
    }
}

struct ExpensePosts: View {
    @EnvironmentObject var car : Car
    @Binding var selectedSection : String
    
    var body: some View {
        // Массив данных меняется в зависимости от выбранной секции
        var dataArr = [EI]()
        switch self.selectedSection {
            case "All": dataArr = car.allExpenses
            case "Fuel": dataArr = car.fuelExpenses
            case "Service": dataArr = car.serviceExpenses
            case "Other": dataArr = car.otherExpenses
            default: dataArr = car.allExpenses
        }
        
        let calendar = Calendar.current
        
        // Массив уникальных дат (по годам, месяцам и дням) всех расходов
        let arrOfTimePeriod = Array(Set(dataArr.map {
            [calendar.component(.year, from: $0.date),
             calendar.component(.month, from: $0.date),
             calendar.component(.day, from: $0.date)]
        })).sorted(by: {
            if $0[0] > $1[0] {
                return true
            } else if $0[0] == $1[0] {
                if $0[1] > $1[1] {
                    return true
                } else if $0[1] == $1[1] {
                    if $0[2] > $1[2] {
                        return true
                    }
                }
            }
            return false 
        })
        
        return
            List {
                ForEach(arrOfTimePeriod, id: \.self) { timePeriod in
                    Section(header: Text(translateDateArray(array: timePeriod))) {
                        ForEach(dataArr.filter {
                            calendar.component(.year, from: $0.date) == timePeriod[0] && calendar.component(.month, from: $0.date) == timePeriod[1] && calendar.component(.day, from: $0.date) == timePeriod[2]
                        }, id: \.id) { post in
                            HStack { // TODO SUBVIEW
                                VStack(alignment: .leading) {
                                    Text("\(post.description)")
                                    Text("\(post.mileage) km")
                                }
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text("$\(post.cost)")
                                    if let post = post as? FEI {
                                        Text("\(post.volume) lit")
                                    } else {
                                        Text("")
                                    }
                                }
                            }
                        }
                    }
                }
            }.listStyle(GroupedListStyle())
    }
}



//struct ExpensesView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExpensesView(car: Car(name: "test", mileage: 1, averageFuel: 2, averageCost: 3))
//    }
//}


