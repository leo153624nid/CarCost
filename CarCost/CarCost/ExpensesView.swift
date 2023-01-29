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
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                HeaderPicker(selectedSection: $selectedSection)
                
                List {
                    switch self.selectedSection {
                        case "All":
                            ExpensePosts(dataArr: car.allExpenses )
                        case "Fuel":
                            ExpensePosts(dataArr: car.fuelExpenses)
                        case "Service":
                            ExpensePosts(dataArr: car.serviceExpenses)
                        case "Other":
                            ExpensePosts(dataArr: car.otherExpenses)
                        default:
                            ExpensePosts(dataArr: car.allExpenses )
                    }
                }
                Spacer()
            }
            .navigationBarTitle("\(car.name)", displayMode: .inline)
        }
    }
}

struct ExpensePosts: View {
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

struct HeaderPicker: View {
        let sections = ["All", "Fuel", "Service", "Other"]
    @Binding var selectedSection: String
    
    var body: some View {
        Picker("", selection: $selectedSection, content: {
            ForEach(self.sections, id: \.self, content: {
                Text($0)
            })
        })
        .pickerStyle(SegmentedPickerStyle())
    }
}

//struct ExpensesView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExpensesView(car: Car(name: "test", mileage: 1, averageFuel: 2, averageCost: 3))
//    }
//}


