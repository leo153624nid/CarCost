//
//  ContentView.swift
//  CarCost
//
//  Created by macbook on 28.01.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTabView = 1
    
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
            Text("Statistic")
                .tabItem {
                    Image(systemName: "3.circle")
                    Text("Statistic")
                }.tag(3)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}










