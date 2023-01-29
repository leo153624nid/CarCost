//
//  ContentView.swift
//  CarCost
//
//  Created by macbook on 28.01.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTabView = 1
    
    @ObservedObject var car = Car(name: "BMW X3", mileage: 100, averageFuel: 10, averageCost: 1000)
    
    var body: some View {
        TabView(selection: $selectedTabView) {
            ExpensesView()
                .tabItem {
                    Image(systemName: "1.circle")
                    Text("Expenses")
                }.tag(1)
            Text("add")
                .tabItem {
                    Image(systemName: "2.circle")
                    Text("add")
                }.tag(2)
            StatisticView()
                .tabItem {
                    Image(systemName: "3.circle")
                    Text("Statistic")
                }.tag(3)
        }.environmentObject(car)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
