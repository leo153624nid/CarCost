//
//  ContentView.swift
//  CarCost
//
//  Created by macbook on 28.01.2023.
//

import SwiftUI

struct ContentView: View {
    let carTestData = EI(description: "-", mileage: 100, cost: 1000, date: Date())
    let car = Car(name: "X3", mileage: 100, averageFuel: 10, averageCost: 1000)
    
    var body: some View {
        car.allExpenses.append(carTestData)
        return Text("\(car.allExpenses.count)")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

protocol ExpenseItem {
    var description: String { get set }
    var mileage: Int { get set }
    var cost: Double { get set }
    var date: Date { get set }
}

protocol FuelExpenseItem: ExpenseItem {
    var price: Double { get set }
    var volume: Double { get set }
    var type: Petrol { get }
    var fullTank: Bool { get set }
}

protocol ServiceExpenseItem: ExpenseItem {
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

struct EI: ExpenseItem {
    var description: String
    var mileage: Int
    var cost: Double
    var date: Date
}



class Car {
    var name: String
    var mileage: Int
    var averageFuel: Double
    var averageCost: Double
    
    var allExpenses = [ExpenseItem]()
    var fuelExpenses = [FuelExpenseItem]()
    var serviceExpenses = [ServiceExpenseItem]()
    var otherExpenses = [ExpenseItem]()
    
    init(name: String, mileage: Int, averageFuel: Double, averageCost: Double) {
        self.name = name
        self.mileage = mileage
        self.averageFuel = averageFuel
        self.averageCost = averageCost
    }
}




