//
//  StatisticView.swift
//  CarCost
//
//  Created by macbook on 29.01.2023.
//

import SwiftUI

struct StatisticView: View {
    @EnvironmentObject var car: Car
    @State private var selectedSection = "Month"
    let sections = ["Month", "Year", "Total"]
    
    var body: some View {
            NavigationView {
                VStack {
                    HeaderPicker(sections: sections, selectedSection: $selectedSection)
                    
                    StatisticPosts(selectedSection: $selectedSection)
                    Spacer()
                }
                .navigationBarTitle("Statistic", displayMode: .inline)
            }
    }
}

struct StatisticPosts: View {
    @EnvironmentObject var car : Car
    @Binding var selectedSection : String
    
    var body: some View {
        let calendar = Calendar.current
        // Массив уникальных дат (по годам) всех расходов
        let arrOfYear = Array(Set(car.allExpenses.map {
            [calendar.component(.year, from: $0.date)]
        })).sorted(by: { $0[0] > $1[0] })
        
        // Массив уникальных дат (по годам и месяцам) всех расходов
        let arrOfMonth = Array(Set(car.allExpenses.map {
            [calendar.component(.year, from: $0.date), calendar.component(.month, from: $0.date)]
        })).sorted(by: {
            if $0[0] > $1[0] {
                return true
            } else if $0[0] == $1[0] {
                if $0[1] > $1[1] {
                    return true
                }
            }
            return false
        })
        
        // Массив дат меняется в зависимости от выбранной секции
        var arrOfTimePeriod = [[Int]]()
        var prefix = ""
        switch self.selectedSection {
            case "Month": arrOfTimePeriod = arrOfMonth
            case "Year": arrOfTimePeriod = arrOfYear
            case "Total":
                arrOfTimePeriod = [arrOfMonth.last!]
                prefix = "from"
            default: arrOfTimePeriod = arrOfMonth
        }
        
        return
            List {
                ForEach(arrOfTimePeriod, id: \.self) { timePeriod in
                    Section(header:
                                Text("\(prefix) \(translateDate(array: timePeriod))"))
                    {
                        // Фильтрация массива со всеми расходами по выбранному временному отрезку
//                        let dataArr = car.allExpenses.filter {
//                            var condition = false
//                            switch self.selectedSection {
//                                case "Month": condition = calendar.component(.year, from: $0.date) == timePeriod[0] && calendar.component(.month, from: $0.date) == timePeriod[1]
//                                case "Year": condition = calendar.component(.year, from: $0.date) == timePeriod[0]
//                                case "Total": condition = true
//                                default: condition = false
//                            }
//                            return condition
//                        }
                        let dataArr = filterArrOnTimePeriod(dataArray: car.allExpenses, timePeriod: self.selectedSection, arrOfTimePeriod: timePeriod)
                        StatisticPostView(dataArr: dataArr)
                    }
                }
            }.listStyle(GroupedListStyle())
    }
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
    
//    let last = dataArray.filter({ $0.date < arrOfTimePeriod[0].date }).last ?? FuelExpenseItem(description: "noLast", mileage: 0, cost: 0, date: Date(), price: 0, volume: 0, type: .ai95, fullTank: false)
//    let first = dataArray.filter({ $0.date > arrOfTimePeriod.last?.date ?? $0.date }).first ?? FuelExpenseItem(description: "noFirst", mileage: 0, cost: 0, date: Date(), price: 0, volume: 0, type: .ai95, fullTank: false)
//
//    arrOfTimePeriod.append(first)
//    arrOfTimePeriod.insert(last, at: 0)
}

struct StatisticPostView: View {
    var dataArr : [EI]
    var averageFuel: Double {
        return 11.11
//        return self.dataArr.map({ item in
//            guard let item = item as FuelExpenseItem else { return }
//            return item.price
//        })
    }
    var fuelCost: Double {
        return self.dataArr.filter({ $0 is FuelExpenseItem }).reduce(0, {
            $0 + $1.cost
        })
    }
    var otherCost: Double {
        return self.dataArr.filter({ $0 is ExpenseItem }).reduce(0, {
            $0 + $1.cost
        })
    }
    var mileage: Int {
        return self.dataArr.filter({ $0 is ExpenseItem }).reduce(0, {
            $0 + $1.mileage
        })
    }
    var fuelingCount: Int {
        return self.dataArr.filter({ $0 is FuelExpenseItem }).count
    }
    
    var body: some View {
        VStack {
            StatisticPostRow(text: "AverageFuel", value: "\(averageFuel)")
            StatisticPostRow(text: "fuelCost", value: "\(fuelCost)")
            StatisticPostRow(text: "otherCost", value: "\(otherCost)")
            StatisticPostRow(text: "Mileage", value: "\(mileage)")
            StatisticPostRow(text: "fuelingCount", value: "\(fuelingCount)")
        }
    }
}

struct StatisticPostRow: View {
    let text : String
    let value : String
    
    var body: some View {
        HStack {
            Text(self.text)
            Spacer()
            Text(self.value)
        }
    }
}

//struct StatisticView_Previews: PreviewProvider {
//    static var previews: some View {
//        StatisticView()
//    }
//}


