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
                        let dataArr = filterArrOnTimePeriod(dataArray: car.allExpenses, timePeriod: self.selectedSection, arrOfTimePeriod: timePeriod)
                        StatisticPostView(dataArr: dataArr, arrOfTimePeriod: timePeriod)
                    }
                }
            }.listStyle(GroupedListStyle())
    }
}

struct StatisticPostView: View {
    @EnvironmentObject var car : Car
    let dataArr : [EI]
    let arrOfTimePeriod : [Int] // do you need it???

    var averageFuel: Double {
        let fuelDataArr = dataArr.filter ({ $0 is FuelExpenseItem }).map({ $0 as! FuelExpenseItem })

        var last = car.fuelExpenses.filter({ $0.date < fuelDataArr[0].date }).last ?? FuelExpenseItem(description: "noLast", mileage: 0, cost: 0, date: Date(), price: 0, volume: 0, type: .ai95, fullTank: false)
        var first = car.fuelExpenses.filter({ $0.date > fuelDataArr.last?.date ?? $0.date }).first ?? FuelExpenseItem(description: "noFirst", mileage: 0, cost: 0, date: Date(), price: 0, volume: 0, type: .ai95, fullTank: false)
        
        let a1 = AverageFuelCount(firstItem: last as! FuelExpenseItem, secondItem: fuelDataArr.first as! FuelExpenseItem)

        let a3 = AverageFuelCount(firstItem: fuelDataArr.last as! FuelExpenseItem, secondItem: first as! FuelExpenseItem)
        let a2 : Double // todo
        return a1 + a2 + a3

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
    var mileage: Int { // TODO !!!!!!!!!!!!!!!
        return self.dataArr.filter({ $0 is ExpenseItem }).reduce(0, {
            $0 + $1.mileage
        })
    }
    var fuelingCount: Int {
        return self.dataArr.filter({ $0 is FuelExpenseItem }).count
    }
    
    var body: some View {

        return
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

func AverageFuelCount(firstItem : FuelExpenseItem, secondItem : FuelExpenseItem) -> Double {
    return secondItem.volume * 100 / Double(secondItem.mileage - firstItem.mileage)
}
