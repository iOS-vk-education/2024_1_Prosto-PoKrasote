//
//  SwiftUIView.swift
//  TestTrainStat
//
//  Created by Kovalev Gleb on 18.11.2024.
//

import SwiftUI

struct AddWorkoutRouterView<Content: View>: View {
    @StateObject var router: AddWorkoutRouter = AddWorkoutRouter()
    @EnvironmentObject var viewModel: WorkoutViewModel
    
    private let content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            content
                .navigationDestination(for: AddWorkoutRouter.Route.self) { route in
                    router.view(for: route)
                }
        }
        .environmentObject(viewModel)
        .environmentObject(router)
    }
}
