//
//  SwiftUICoreDataApp.swift
//  SwiftUICoreData
//
//  Created by Siddharth on 26/04/21.
//

import SwiftUI

@main
struct SwiftUICoreDataApp: App {
    
    let persistanceController = PersistanceController.shared
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistanceController.container.viewContext)
        }
        .onChange(of: scenePhase) { (newScenePhase) in
            switch newScenePhase{
            
            case .background:
                print("Scene is in Background")
                persistanceController.save()
            case .inactive:
                print("Scene is inActive")
            case .active:
                print("Scene is Active")
            @unknown default:
                print("Apple changed something you should research!")
            }
        }
    }
}
