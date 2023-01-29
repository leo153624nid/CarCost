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
                HeaderPicker(sections: sections, selectedSection: $selectedSection)
                
                List {
                    switch self.selectedSection {
                        case "Month":
                            StatisticPosts(dataArr: car.allExpenses )
                        case "Year":
                            StatisticPosts(dataArr: car.fuelExpenses)
                        case "All":
                            StatisticPosts(dataArr: car.serviceExpenses)
                        default:
                            StatisticPosts(dataArr: car.allExpenses )
                    }
                }
                Spacer()
            }
            .navigationBarTitle("Statistic", displayMode: .inline)
        }
    }
}

struct StatisticPosts: View {
    var dataArr: [EI]
    
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
