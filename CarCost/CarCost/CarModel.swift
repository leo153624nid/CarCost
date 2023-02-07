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

//protocol StatisticPostProtocol {
//    var averageFuel: Double { get set }
//    var fuelCost: Double { get set }
//    var otherCost: Double { get set }
//    var mileage: Int { get set }
//    var fuelingCount: Int { get set }
//}

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

//struct StatisticPost: StatisticPostProtocol {
//    var averageFuel: Double
//    var fuelCost: Double
//    var otherCost: Double
//    var mileage: Int
//    var fuelingCount: Int
//}

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
        
        self.allExpenses = arrSortedByDateUp(dataArr:[
            FuelExpenseItem(description: "f1", mileage: 100, cost: 3000, date: Date(timeIntervalSinceNow: -1000000), price: 52.94, volume: 60, type: .ai95, fullTank: true),
            FuelExpenseItem(description: "f2", mileage: 200, cost: 3000, date: Date(timeIntervalSinceNow: -100000), price: 52.94, volume: 60, type: .ai95, fullTank: true),
            FuelExpenseItem(description: "f3", mileage: 300, cost: 3000, date: Date(timeIntervalSinceNow: 10), price: 52.94, volume: 60, type: .ai95, fullTank: true),
            FuelExpenseItem(description: "f4", mileage: 400, cost: 3000, date: Date(timeIntervalSinceNow: 6000000), price: 52.94, volume: 60, type: .ai95, fullTank: true),
            ServiceExpenseItem(serviceName: "self", description: "washing1", mileage: 300, cost: 300, date: Date(timeIntervalSinceNow: 10)),
            ServiceExpenseItem(serviceName: "self", description: "washing2", mileage: 400, cost: 400, date: Date(timeIntervalSinceNow: 10)),
            ExpenseItem(description: "oil filter1", mileage: 500, cost: 1000, date: Date(timeIntervalSinceNow: 10)),
            ExpenseItem(description: "oil filter2", mileage: 600, cost: 1100, date: Date(timeIntervalSinceNow: 10)),
        ])
    }
}

func translateDateArray(array: [Int]) -> String {
    if array.count == 3 {
        let year = array[0]
        let month = array[1]
        let day = array[2]
        return "\(year) \(month) \(day)"
    } else if array.count == 2 {
        let year = array[0]
        let month = array[1]
        return "\(year) \(month)"
    } else if array.count == 1 {
        let year = array[0]
        return "\(year)"
    }
    return "date error"
}

func arrSortedByDateUp(dataArr: [EI]) -> [EI] {
    let array = dataArr.sorted(by: { $0.date > $1.date })
    return array
}

func arrSortedByDateDown(dataArr: [EI]) -> [EI] {
    let array = dataArr.sorted(by: { $0.date < $1.date })
    return array
}

// Фильтрация массива [EI] со всеми расходами по выбранному временному отрезку
func filterArrOnTimePeriod(dataArray: [EI], timePeriod: String, arrOfTimePeriod: [Int]) -> [EI] {
    let calendar = Calendar.current
    var condition = false
    
    return dataArray.filter {
        switch timePeriod {
            case "Month":
                condition = calendar.component(.year, from: $0.date) == arrOfTimePeriod[0] && calendar.component(.month, from: $0.date) == arrOfTimePeriod[1]
            case "Year":
                condition = calendar.component(.year, from: $0.date) == arrOfTimePeriod[0]
            case "Total": condition = true
            default: condition = false
        }
        return condition
    }
}
