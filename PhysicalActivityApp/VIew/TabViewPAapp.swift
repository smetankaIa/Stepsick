//
//  TabViewPAapp.swift
//  PhysicalActivityApp
//
//  Created by Алексей Никулин on 20.12.2023.
//

import SwiftUI
struct TabViewPAapp: View {
    @EnvironmentObject var manager: HealthManager
    @State var selectedTab = "Home"
    var body: some View {
        TabView(selection: $selectedTab){
            HomeViewPAapp()
                .environmentObject(manager)
                .tag("Home")
                .tabItem{
                    Image(systemName: "house")
                }
            
            ChartsView()
                .environmentObject(manager)
                .tag("Charts")
                .tabItem{
                    Image(systemName: "chart.line.uptrend.xyaxis")
                }
            
            
                .environmentObject(manager)
//            ContentView()
//                .tag("Content")
//                .tabItem{
//                    Image(systemName: "person")
//
//                }
        }
    }
}

#Preview {
    TabViewPAapp()
        .environmentObject(HealthManager())
}
