//
//  MainView.swift
//  TrainStat
//
//  Created by Kovalev Gleb on 12.12.2024.
//

import SwiftUI

struct MainView: View {
    let coreDataManager = CoreDataManager.shared
    
    var body: some View {
        MainTabView()
            .environment(\.managedObjectContext, coreDataManager.persistentContainer.viewContext)
    }
}

#Preview {
    MainView()
}
