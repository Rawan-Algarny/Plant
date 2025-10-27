////
////  PlantApp.swift
////  Plant
////
////  Created by Rawan Algarny on 05/05/1447 AH.
////
//
//import SwiftUI
//
//@main
//struct PlantApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}
import SwiftUI

@main
struct PlantApp: App {
    init() {
        // ✅ Request notification permission on app launch
       // NotificationManager.shared.requestPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
