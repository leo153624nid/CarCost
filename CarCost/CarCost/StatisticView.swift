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
                                Text("\(prefix) \(translateDateArray(array: timePeriod))"))
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
    let arrOfTimePeriod : [Int] // do you need it???????????????????????????????????????????????????

    var averageFuel: Double {
        var fuelDataArr = dataArr.filter ({ $0 is FuelExpenseItem }).map({ $0 as! FuelExpenseItem })
        // разворот массива обратно по нарастающей дате
        fuelDataArr = arrSortedByDateDown(dataArr: fuelDataArr as [EI]) as! [FuelExpenseItem]
        
        guard fuelDataArr.count >= 1 else {
            print("no Item in timePeriod")
            return 0
        }
        let last = car.fuelExpenses.filter({ $0.date < fuelDataArr[0].date }).last // тут может быть не тот элемент
            ?? FuelExpenseItem(description: "noLast", mileage: 0, cost: 0, date: Date(), price: 0, volume: 0, type: .ai95, fullTank: false)
        let first = car.fuelExpenses.filter({ $0.date > fuelDataArr.last?.date ?? $0.date }).first // тут может быть не тот элемент
            ?? FuelExpenseItem(description: "noFirst", mileage: 0, cost: 0, date: Date(), price: 0, volume: 0, type: .ai95, fullTank: false)
        
        return countAverageFuelForMonth(fuelDataArr: fuelDataArr, last: last as! FuelExpenseItem, first: first as! FuelExpenseItem, averageFuel: car.averageFuel)
    }
    var fuelCost: Double {
        return self.dataArr.filter({ $0 is FuelExpenseItem }).reduce(0, {
            $0 + $1.cost
        })
    }
    var otherCost: Double {
        return self.dataArr.filter({ $0 is FuelExpenseItem ? false : true }).reduce(0, {
            $0 + $1.cost
        })
    }
    var mileage: Int { 
        guard dataArr.count > 0 else { return 0 }
        guard dataArr.count > 1 else { return dataArr.first!.mileage }
        return dataArr.last!.mileage - dataArr.first!.mileage
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

func averageFuelBetweenTwo(firstItem : FuelExpenseItem, secondItem : FuelExpenseItem) -> Double {
    return secondItem.volume * 100 / Double(secondItem.mileage - firstItem.mileage)
}

func countAverageFuelForMonth (fuelDataArr: [FuelExpenseItem],
                               last: FuelExpenseItem,
                               first: FuelExpenseItem,
                               averageFuel: Double) -> Double {
    let calendar = Calendar.current
    guard fuelDataArr.count >= 1 else {
        print("no Item in timePeriod")
        return 0
    }
    
    // Расход ДО
    var avBefore: Double
    if last.description == "noLast" {
        avBefore = averageFuel
    } else {
        avBefore = averageFuelBetweenTwo(firstItem: last, secondItem: fuelDataArr.first!)
    }
    // for MONTH !!! TODO for Year !!!!
    let daysBefore = Double(calendar.component(.day, from: fuelDataArr.first!.date))
    
    // Расход ПОСЛЕ
    var avAfter: Double
    if first.description == "noFirst" {
        avAfter = 0
    } else {
        avAfter = averageFuelBetweenTwo(firstItem: fuelDataArr.last!, secondItem: first)
    }
    // for MONTH !!! TODO for Year !!!!
    let daysAfter = Double(30 - calendar.component(.day, from: fuelDataArr.last!.date))
    
    if fuelDataArr.count == 1 {
        return (avBefore * daysBefore + avAfter * daysAfter) / 30
    }
    var avIn : [Double] = []
    for i in 0..<fuelDataArr.count {
        guard (i + 1) != fuelDataArr.count else { break }
        let dayFirst = calendar.component(.day, from: fuelDataArr[i].date)
        let daySecond = calendar.component(.day, from: fuelDataArr[i + 1].date)
        avIn.append(averageFuelBetweenTwo(firstItem: fuelDataArr[i], secondItem: fuelDataArr[i + 1]) * Double((daySecond - dayFirst)))
    }
    return (avBefore * daysBefore + avIn.reduce(0, { $0 + $1 }) + avAfter * daysAfter) / 30
}
