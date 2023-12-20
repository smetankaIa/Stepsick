//
//  HomeViewPAapp.swift
//  PhysicalActivityApp
//
//  Created by Алексей Никулин on 20.12.2023.
//

import SwiftUI

struct HomeViewPAapp: View {
    @EnvironmentObject var manager: HealthManager
    let welcomeArray = [ "Ас-Саляму Алейкум ", "Добро Пожаловать", "Welcome"]
    @State private var currentIndex = 0
    var body: some View {
        VStack(alignment: .leading){
            Text(welcomeArray[currentIndex])
                .font(.largeTitle)
                .foregroundColor(.secondary)
                
                .padding()
                .onAppear(){
                    startWelcomeTimer()
                }
            
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 0 ), count: 2)){
                ForEach(manager.activites.sorted(by: {$0.value.id < $1.value.id}), id: \.key ){ item in
                    ActivityCard(activity: item.value)
                }
            }
//            .onAppear{
//                manager.fetchTodaySteps()
//                manager.fetchTodayCalories()
//            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    func startWelcomeTimer(){
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true){ timer in
            withAnimation{
                currentIndex = (currentIndex + 1) % welcomeArray.count
                return
            }
        }
    }
}

#Preview {
    HomeViewPAapp()
        .environmentObject(HealthManager())
}
