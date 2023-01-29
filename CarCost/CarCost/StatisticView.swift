//
//  StatisticView.swift
//  CarCost
//
//  Created by macbook on 29.01.2023.
//

import SwiftUI

struct StatisticView: View {
    @State private var selectedSection = "Month"
    let sections = ["Month", "Year", "All"]
    
    @EnvironmentObject var car: Car
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("", selection: $selectedSection, content: {
                    ForEach(self.sections, id: \.self, content: {
                        Text($0)
                    })
                })
                .pickerStyle(SegmentedPickerStyle())
                
//                List {
//                    switch self.selectedSection {
//                        case "All":
//                            ExpensePosts(dataArr: car.allExpenses )
//                        case "Fuel":
//                            ExpensePosts(dataArr: car.fuelExpenses)
//                        case "Service":
//                            ExpensePosts(dataArr: car.serviceExpenses)
//                        case "Other":
//                            ExpensePosts(dataArr: car.otherExpenses)
//                        default:
//                            ExpensePosts(dataArr: car.allExpenses )
//                    }
//                }
                Spacer()
            }
            .navigationBarTitle("Statistic", displayMode: .inline)
        }
    }
}

struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticView()
    }
}
