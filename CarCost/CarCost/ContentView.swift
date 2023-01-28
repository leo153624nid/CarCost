//
//  ContentView.swift
//  CarCost
//
//  Created by macbook on 28.01.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
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

enum FuelType {
    case Diesel
    case Petrol
}

//class Car {
//    var name: String
//    var mileage: Int
//    var averageFuel: Double
//    var averageCost: Double
//    
//}
