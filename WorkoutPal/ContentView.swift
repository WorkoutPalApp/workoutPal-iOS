//
//  ContentView.swift
//  WorkoutPal
//
//  Created by Andy Craig on 2024-03-13.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var firestoreManager: FirestoreManager
    @State private var workoutPending: Bool = false
    @State private var completedWorkout: Workout = Workout(total_duration: 0.0, active_duration: 0.0, exercise: "Null", calories_burned: 0.0, rep_count: 0, date: Date(), load: 0, average_rep_time: 0.0, intensity: 0, squat_height_data: [0.0])
    @State private var selectedTab: Tab = .home
    @State private var isShowingSuccessSheet: Bool = false
    @State private var isShowingPendingSheet: Bool = false
    
    enum Tab {
        case upload
        case workoutHistory
        case home
    }
    
    var body: some View {
        Group{
            if (authManager.isLoggedIn){
                TabView(selection: $selectedTab) {
                    HomeView()
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                        .tag(Tab.home)
                    UploadView(workoutPending: $workoutPending, completedWorkout: $completedWorkout)
                        .tabItem {
                            Label("Upload", systemImage: "arrow.up.circle")
                        }
                        .tag(Tab.upload)
                    
                    WorkoutHistoryView()
                        .tabItem {
                            Label("Workout History", systemImage: "clock.arrow.circlepath")
                        }
                        .tag(Tab.workoutHistory)
                    
                }
                .onChange(of: workoutPending) { pending in
                    if (pending){
                        print("workout is pending")
                        
                    }else{
                        print("workout analysis completed")
                        isShowingSuccessSheet = true
                    }
                    
                }
            }else{
                LoginView()
            }
            
        }
        .sheet(isPresented: $isShowingSuccessSheet) {
            Text("Analysis Completed!")
                .font(.largeTitle)
                .bold()
            KeyValuePairsView(workout: self.completedWorkout)
        }
        .sheet(isPresented: $isShowingPendingSheet) {
            PendingSheet()
                .presentationDetents([.medium])
        }
        .onAppear {
            authManager.checkLoggedIn()
        }
    }
}

struct PendingSheet: View {
    var body: some View {
        VStack {
            Text("File Uploaded Successfully!")
                .font(.title)
                .padding()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

struct SuccessSheet: View {
    var body: some View {
        VStack {
            Text("Workout analysis complete")
                .font(.title)
                .padding()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
