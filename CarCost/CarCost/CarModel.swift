//
//  CarModel.swift
//  CarCost
//
//  Created by macbook on 29.01.2023.
//

import Foundation

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
    
//    @Published var allExpenses = [ExpenseItem]()
//    @Published var fuelExpenses = [FuelExpenseItem]()
//    @Published var serviceExpenses = [ServiceExpenseItem]()
//    @Published var otherExpenses = [ExpenseItem]()
    
    @Published var allExpenses = [EI]()
    var fuelExpenses : [FEI] {
        var array = [FEI]()
        for item in self.allExpenses {
            if item is FEI {
                array.append(item as! FEI)
            }
        }
        return array
    }
    var serviceExpenses : [SEI] {
        var array = [SEI]()
        for item in self.allExpenses {
            if item is SEI {
                array.append(item as! SEI)
            }
        }
        return array
    }
    var otherExpenses : [EI] {
        var array = [EI]()
        for item in self.allExpenses {
            if item is FEI || item is SEI {
                continue
            } else {
                array.append(item)
            }
        }
        return array
    }
    
    init(name: String, mileage: Int, averageFuel: Double, averageCost: Double) {
        self.name = name
        self.mileage = mileage
        self.averageFuel = averageFuel
        self.averageCost = averageCost
        
        self.allExpenses = [
            FuelExpenseItem(description: "-", mileage: 10000, cost: 3000, date: Date(), price: 52.94, volume: 60, type: .ai95, fullTank: true),
            FuelExpenseItem(description: "-", mileage: 10500, cost: 3000, date: Date(), price: 52.94, volume: 60, type: .ai95, fullTank: true),
            ServiceExpenseItem(serviceName: "self", description: "washing", mileage: 10600, cost: 300, date: Date()),
            ServiceExpenseItem(serviceName: "self", description: "washing", mileage: 11600, cost: 400, date: Date()),
            ExpenseItem(description: "oil filter", mileage: 10700, cost: 300, date: Date()),
            ExpenseItem(description: "oil filter", mileage: 11700, cost: 400, date: Date()),
        ]
    }
}