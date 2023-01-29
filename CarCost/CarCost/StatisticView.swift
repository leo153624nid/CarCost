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
        let newArr = arrSortedByDate(dataArr: car.allExpenses)
        return NavigationView {
            VStack {
                HeaderPicker(sections: sections, selectedSection: $selectedSection)
                
                List {
                    switch self.selectedSection {
                        case "Month":
                            StatisticPosts(dataArr: newArr )
                        case "Year":
                            StatisticPosts(dataArr: car.fuelExpenses)
                        case "Total":
                            StatisticPosts(dataArr: car.serviceExpenses)
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

func arrSortedBy(period: String, dataArr: [EI]) -> [EI] {
    let array = [EI]()
    if period == "Month" {
//        let array = dataArr.sorted(by: {
//            Calendar.current.component(.month, from: $0.date) > Calendar.current.component(.month, from: $1.date)
//        })
        let array = dataArr.sorted(by: {
            $0.date < $1.date
        })
        print(array)
        return array
    }
 
    return array
}

func arrSortedByDate(dataArr: [EI]) -> [EI] {
    let array = dataArr.sorted(by: { $0.date < $1.date })
    return array
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
