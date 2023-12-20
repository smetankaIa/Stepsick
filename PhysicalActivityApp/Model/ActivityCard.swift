//
//  ActivityCard.swift
//  PhysicalActivityApp
//
//  Created by Алексей Никулин on 20.12.2023.
//

import SwiftUI

struct Activity{
    let id: Int
    let title: String
    let subtitle: String
    let image: String
    let amount: String
    let color: Color
}

struct ActivityCard: View {
    @State var activity: Activity
    var body: some View {
        ZStack{
            Color(uiColor: .systemGray6)
                .cornerRadius(15)
            VStack{
                HStack(alignment: .top){
                    VStack(alignment: .leading, spacing: 5){
                        Text(activity.title)
                            .font(.system(size: 16))

                    
                        Text(activity.subtitle)
                            .font(.system(size: 12))
                    }
                    Spacer()
                    
                    Image(systemName: activity.image)
                        .foregroundColor(activity.color)
                }.padding()
                
                Text(activity.amount)
                    .font(.system(size: 24))
            }
            .padding()
            .cornerRadius(15)
        }.padding()
    }
    
}

#Preview {
    ActivityCard(activity: Activity(id: 0, title: "Daily Steps", subtitle: "Goal 10,000", image: "figure.walk", amount: "5,532", color: .green))
}
