//
//  StatisticsRouterView.swift
//  TrainStat
//
//  Created by Kovalev Gleb on 12.11.2024.
//

import SwiftUI

struct StatisticsRouterView<Content: View>: View {
    @StateObject var router: StatisticsRouter = StatisticsRouter()
    // Our root view content
    private let content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            content
                .navigationDestination(for: StatisticsRouter.Route.self) { route in
                    router.view(for: route)
                }
        }
        .environmentObject(router)
    }
}
