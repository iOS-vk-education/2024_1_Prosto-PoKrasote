//
//  StatisticsRouter.swift
//  TrainStat
//
//  Created by Kovalev Gleb on 12.11.2024.
//

import SwiftUI

class StatisticsRouter: ObservableObject {
    // Contains the possible destinations in our Router
    enum Route: Hashable {
        case statView
        case achievementView
        case generalStatisticsView
        case exerciseStatisticsView
    }
    
    // Used to programatically control our navigation stack
    @Published var path: NavigationPath = NavigationPath()
    
    // Builds the views
    @ViewBuilder func view(for route: Route) -> some View {
        switch route {
        case .statView:
            StatisticsView()
        case .achievementView:
            AchievementsView()
        case .generalStatisticsView:
            GeneralStatisticsView()
        case .exerciseStatisticsView:
            ExerciseStatisticsView()
        }
    }
    
    // Used by views to navigate to another view
    func navigateTo(_ appRoute: Route) {
        path.append(appRoute)
    }
    
    // Used to go back to the previous screen
    func navigateBack() {
        path.removeLast()
    }
    
    // Pop to the root screen in our hierarchy
    func popToRoot() {
        path.removeLast(path.count)
    }
}
