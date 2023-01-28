//
//  ContentView.swift
//  CarCost
//
//  Created by macbook on 28.01.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text(FuelType.Diesel.rawValue)
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
    var type: String { get set }
    var fullTank: Bool { get set }
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

class Car {
    var name: String
    var mileage: Int
    var averageFuel: Double
    var averageCost: Double
    
    init(name: String, mileage: Int, averageFuel: Double, averageCost: Double) {
        self.name = name
        self.mileage = mileage
        self.averageFuel = averageFuel
        self.averageCost = averageCost
    }
}
