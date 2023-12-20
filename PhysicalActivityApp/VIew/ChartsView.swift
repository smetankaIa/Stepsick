//
//  ChartsView.swift
//  PhysicalActivityApp
//
//  Created by Алексей Никулин on 21.12.2023.
//

import SwiftUI
import Charts


struct DailyStepView: Identifiable{
    let id = UUID()
    let date: Date
    let stepCount: Double
    
}

enum ChartsOptions{
    case oneWeek
    case oneMonth
    case threeMonth
    case yearToDate
    case oneYear
    
}

struct ChartsView: View {
    @EnvironmentObject var manager: HealthManager
    @State var selectedChart: ChartsOptions = .oneWeek
    var body: some View {
        VStack(spacing: 8){
            Chart{
                ForEach(manager.oneMonthChartData ){ daily in
                    BarMark(x: .value(daily.date.formatted(), daily.date, unit: .day), y: .value("Steps", daily.stepCount))
                }
                
            }.foregroundColor(.orange)
            .frame(height: 350)
            .padding(.horizontal)

            HStack{
               
                Button("1W"){
                    withAnimation{
                        selectedChart = .oneWeek
                    }
                }.padding(.all)
                    .foregroundColor(selectedChart == .oneWeek ? .white : .green)
                    .background(selectedChart == .oneWeek ? .green : .clear)
                    .cornerRadius(10)
                
                Button("1M"){
                    withAnimation{
                        selectedChart = .oneMonth
                    }
                }.padding(.all)
                    .foregroundColor(selectedChart == .oneMonth ? .white : .green)
                    .background(selectedChart == .oneMonth ? .green : .clear)
                    .cornerRadius(10)
                
                Button("3M"){
                    withAnimation{
                        selectedChart = .threeMonth
                    }
                }.padding(.all)
                    .foregroundColor(selectedChart == .threeMonth ? .white : .green)
                    .background(selectedChart == .threeMonth ? .green : .clear)
                    .cornerRadius(10)
                
                Button("YTD"){
                    withAnimation{
                        selectedChart = .yearToDate
                    }
                }.padding(.all)
                    .foregroundColor(selectedChart == .yearToDate ? .white : .green)
                    .background(selectedChart == .yearToDate ? .green : .clear)
                    .cornerRadius(10)
                
                Button("1Y"){
                    withAnimation{
                        selectedChart = .oneYear
                    }
                }.padding(.all)
                    .foregroundColor(selectedChart == .oneYear ? .white : .green)
                    .background(selectedChart == .oneYear ? .green : .clear)
                    .cornerRadius(10)
            }
            
        }.onAppear(){
            print(manager.oneMonthChartData)
            
        }
        
    }
}

#Preview {
    ChartsView()
        .environmentObject(HealthManager() )
}
