//
//  HealthManager.swift
//  PhysicalActivityApp
//
//  Created by Алексей Никулин on 20.12.2023.
//

import Foundation
import HealthKit

extension Date {
    static var startOfDay: Date{
        Calendar.current.startOfDay(for: Date())
    }
    static var startOfWeek: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        components.weekday = 2 //monday
        
        return calendar.date(from: components)!
    }
    static var oneMonthAgo: Date{
        let calendar = Calendar.current
        let oneMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        return calendar.startOfDay(for: oneMonth!)
        
    }
}

class HealthManager: ObservableObject{
    let healthStore = HKHealthStore()
    
    @Published var activites: [String : Activity] = [:]
    
    
    @Published var oneMonthChartData = [DailyStepView]()
    
    @Published var mockActivites: [String : Activity] = [
        "todaySteps": Activity(id: 1, title: "Today Steps", subtitle: "Goal 10,000", image: "figure.walk", amount: "12,155", color: .green),
        "todayCalories": Activity(id: 1, title: "Today Calories", subtitle: "Goal 900", image: "flame", amount: "1,241", color: .red)
    ]
    
    init(){
        let steps = HKQuantityType(.stepCount)
        let calories = HKQuantityType(.activeEnergyBurned)
        
        let healthTypes: Set = [steps, calories]
        
        Task{
            do{
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
                
                fetchTodaySteps()
                fetchTodayCalories()
                fetchPastMonthStepData()
            } catch{
                print("error")
            }
        }
    }
    
    func fetchDailySteps(startDate: Date, completion: @escaping([DailyStepView]) -> Void){
        let steps = HKQuantityType(.stepCount)
        let interval = DateComponents(day: 1)
        let query = HKStatisticsCollectionQuery(quantityType: steps, quantitySamplePredicate: nil,  anchorDate: startDate, intervalComponents: interval)
        
        query.initialResultsHandler = { query, result, error in
            guard let result = result else{
                completion([])
                return
            }
            var dailySteps = [DailyStepView]()
            
            result.enumerateStatistics(from: startDate, to: Date()) { statistics, stop  in
                dailySteps.append(DailyStepView(date: statistics.startDate, stepCount: statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0.00))
            }
            completion(dailySteps)
            
        }
        healthStore.execute(query)
    }
    
    func fetchTodaySteps(){
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(),  error == nil else{
                print("error")
                return
            }
            let stepsCount = quantity.doubleValue(for: .count())
            let activity = Activity(id: 1, title: "Today Steps", subtitle: "Goal 10,000", image: "figure.walk", amount: "\(stepsCount.formatedString())", color: .green)
            DispatchQueue.main.async {
                self.activites["todaySteps"] = activity
            }
            print(stepsCount.formatedString())
        }
        healthStore.execute(query)
    }
    
    func fetchTodayCalories(){
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate){ _, result, error in
            guard let quantity = result?.sumQuantity(),  error == nil else{
                print("error")
                return
            
        }
            let caloriesBurned = quantity.doubleValue(for: .kilocalorie())
            let activity = Activity(id: 0, title: "Today Calories Burned", subtitle: "Goal 900", image: "flame", amount: "\(caloriesBurned.formatedString())", color: .red )
            DispatchQueue.main.async {
                self.activites["todayCaloriesBurned"] = activity
            }
            print(caloriesBurned.formatedString())
        }
        healthStore.execute(query)
    }
    
}



extension Double{
    func formatedString() -> String{
        let nummberFormated = NumberFormatter()
        nummberFormated.numberStyle = .decimal
        nummberFormated.maximumFractionDigits = 0
        
        return nummberFormated.string(from: NSNumber(value: self))!
    }
}

 // MARK: Chart Data
extension HealthManager{
    func fetchPastMonthStepData(){
        fetchDailySteps(startDate: .oneMonthAgo) { dailySteps in
            DispatchQueue.main.async{
                self.oneMonthChartData = dailySteps
            }
        }
    }
}
