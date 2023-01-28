//
//  ContentView.swift
//  CarCost
//
//  Created by macbook on 28.01.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedSection = "Fuel"
    let sections = ["All", "Fuel", "Service", "Other"]
    
    @ObservedObject var car = Car(name: "X3", mileage: 100, averageFuel: 10, averageCost: 1000)
    
    var body: some View {
            NavigationView {
                VStack {
                    Picker("", selection: $selectedSection, content: {
                        ForEach(self.sections, id: \.self, content: {
                            Text($0)
                        })
                    })
                    .pickerStyle(SegmentedPickerStyle())
                    Text(selectedSection)
                    
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
                .navigationBarTitle(Text("\(car.name)"))
            }
    }
}

struct ExpensePosts: View {
    var dataArr: [EI]
    
    var body: some View {
        ForEach(dataArr, id: \.self) { item in
            HStack {
                VStack(alignment: .leading) {
                    Text("\(item.description)")
                    Text("\(item.mileage) km")
                }
                Spacer()
                Text("$\(item.cost)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

protocol EI {
    var description: String { get set }
    var mileage: Int { get set }
    var cost: Double { get set }
    var date: Date { get set }
    var id: UUID { get set }
}

protocol FEI: EI {
    var price: Double { get set }
    var volume: Double { get set }
    var type: Petrol { get }
    var fullTank: Bool { get set }
}

protocol SEI: EI {
    var serviceName: String { get set }
}

enum Petrol: String {
    case ai92 = "АИ-92"
    case ai95 = "АИ-95"
    case ai98 = "АИ-98"
    case ai100 = "АИ-100"
}

enum FuelType: String {
    case Diesel = "ДТ"
    case Petrol
    case Gas = "Газ"
}

struct ExpenseItem: EI, Identifiable {
    var id = UUID()
    var description: String
    var mileage: Int
    var cost: Double
    var date: Date
}

struct FuelExpenseItem: FEI, Identifiable {
    var id = UUID()
    var description: String
    var mileage: Int
    var cost: Double
    var date: Date
    var price: Double
    var volume: Double
    var type: Petrol
    var fullTank: Bool
}

struct ServiceExpenseItem: SEI, Identifiable {
    var id = UUID()
    var serviceName: String
    var description: String
    var mileage: Int
    var cost: Double
    var date: Date
}

class Car: ObservableObject {
    @Published var name: String
    @Published var mileage: Int
    @Published var averageFuel: Double
    @Published var averageCost: Double
    
    @Published var allExpenses = [ExpenseItem]()
    @Published var fuelExpenses = [FuelExpenseItem]()
    @Published var serviceExpenses = [ServiceExpenseItem]()
    @Published var otherExpenses = [ExpenseItem]()
    
//    @Published var allExpenses = [EI]()
//    @Published var fuelExpenses = [FEI]()
//    @Published var serviceExpenses = [SEI]()
//    @Published var otherExpenses = [EI]()
    
    init(name: String, mileage: Int, averageFuel: Double, averageCost: Double) {
        self.name = name
        self.mileage = mileage
        self.averageFuel = averageFuel
        self.averageCost = averageCost
        
        self.allExpenses = [
//            FuelExpenseItem(description: "-", mileage: 10000, cost: 3000, date: Date(), price: 52.94, volume: 60, type: .ai95, fullTank: true),
//            FuelExpenseItem(description: "-", mileage: 10500, cost: 3000, date: Date(), price: 52.94, volume: 60, type: .ai95, fullTank: true),
//            ExpenseItem(description: "washing", mileage: 10600, cost: 300, date: Date())
        ]
        self.fuelExpenses = [
            FuelExpenseItem(description: "-", mileage: 10000, cost: 3000, date: Date(), price: 52.94, volume: 60, type: .ai95, fullTank: true),
            FuelExpenseItem(description: "-", mileage: 10500, cost: 3000, date: Date(), price: 52.94, volume: 60, type: .ai95, fullTank: true),
        ]
        self.serviceExpenses = []
        self.otherExpenses = []
    }
}






