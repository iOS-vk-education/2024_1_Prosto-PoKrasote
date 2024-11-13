//
//  CustomTabView.swift
//  TrainStat
//
//  Created by Kovalev Gleb on 12.11.2024.
//
// CustomTabView - view for MainTabView, use there

import SwiftUI

struct CustomTabView: View {
    
    @Binding var tabSelection: Int
    
    let tabBarItems: [(image: String, name: String)] = [
        ("chart.bar.xaxis.ascending", "Stat"),
        ("house.fill", "Home"),
        ("dumbbell.fill", "Train"),
        ("person.crop.circle", "Acc")
    ]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 32)
                .frame(width: 340, height: 64)
                .foregroundStyle(systemDarkBlueColor)
            
            HStack(spacing: 34) {
                ForEach(0..<4) { index in
                    Button(action: {
                        tabSelection = index + 1
                    }, label: {
                        ZStack {
                            if tabSelection == index + 1 {
                                RoundedRectangle(cornerRadius: 43)
                                    .frame(width: 100, height: 36)
                                    .foregroundStyle(yellowColor)
                                    .opacity(tabSelection == index + 1 ? 1 : 0)
                            }
                            
                            HStack(spacing: 4) {
                                Image(systemName: tabBarItems[index].image)
                                    .font(.system(size: 24))
                                    .foregroundStyle(tabSelection == index + 1 ? systemDarkBlueColor : .white)
                                
                                if tabSelection == index + 1 {
                                    Text(tabBarItems[index].name)
                                        .font(.system(size: 13))
                                        .foregroundStyle(systemDarkBlueColor)
                                        .opacity(tabSelection == index + 1 ? 1 : 0)
                                }
                            }
                            .frame(height: 36)
                        }
                    })
                }
            }
            .padding(32)
            .animation(.easeInOut(duration: 0.3), value: tabSelection)
        }
    }
}

struct CustomTabView_Preview: PreviewProvider {
    
    static var previews: some View {
        @State var intVar = 2
        CustomTabView(tabSelection: $intVar)
    }
}
