//
//  MainTabView.swift
//  TrainStat
//
//  Created by Kovalev Gleb on 12.11.2024.
//

// MainTabView - tab view that we put in main screen

import SwiftUI

struct MainTabView: View {
    
    // tabSelection - curerent selected view from tabview, later set to HomeView using @Binding to make navigation to WorkoutView
    
    @State private var tabSelection: Int = 2
    
    @StateObject var authManager: AuthManager
    
    init() {
        let authManager = AuthManager()
        _authManager = StateObject(wrappedValue: authManager)
    }
    
    var body: some View {
        if authManager.authState != .signedOut {
            TabView(selection: $tabSelection) {
                StatisticsRouterView {
                    StatisticsView()
                }
                    .tag(1)
                HomeRouterView {
                    HomeView()
                }
                    .tag(2)
                WorkoutRouterView {
                    WorkoutView()
                }
                    .tag(3)
                AccountRouterView {
                    AccountView()
                        .environmentObject(authManager)
                }
                    .tag(4)
            }
            .overlay(alignment: .bottom) {
                CustomTabView(tabSelection: $tabSelection)
                    .padding(.horizontal, 50)
            }
        } else {
            AuthView().environmentObject(authManager)
        }
    }
}

#Preview {
    MainTabView()
}

