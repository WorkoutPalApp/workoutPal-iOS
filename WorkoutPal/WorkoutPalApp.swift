//
//  WorkoutPalApp.swift
//  WorkoutPal
//
//  Created by Andy Craig on 2024-03-12.
//

import Firebase
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct WorkoutPalApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let authManager = AuthManager()
    let firestoreManager = FirestoreManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    firestoreManager.configureFirestore()
                }
                .environmentObject(authManager)
                .environmentObject(firestoreManager)
        }
    }
}
