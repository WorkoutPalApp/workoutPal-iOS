//
//  HomeView.swift
//  WorkoutPal
//
//  Created by Andy Craig on 2024-03-13.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var firestoreManager: FirestoreManager
    @State var workoutCount: Int = 0
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    HStack {
                        Text("Welcome Back Andy")
                            .font(.system(.title2, design: .default))
                            .bold()
                        
                        Image(systemName: "gear")

                    }
                    WorkoutProgressView(workoutsCompleted: workoutCount)
                    HStack {
                        VStack {
                            HStack {
                                Text("Learn Exercises")
                                    .font(.system(.title3, design: .default))
                                    .bold()
                            }
                            .frame(
                                width: 325,
                                height: 50,
                                alignment: .leading
                            )
                            
                            ZStack {
                                HStack {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Image(systemName: "lock.shield.fill")
                                            Text("Pushup")
                                                .font(.system(.title3, design: .default))
                                                .bold()
                                        }
                                        HStack {
                                            Text("Your first pushup")
                                                .font(.system(.callout, design: .default))
                                        }
                                        Text("Beginner")
                                            .foregroundColor(Color(uiColor: .systemGreen))
                                            .font(.system(.subheadline, design: .default))
                                    }
                                    .frame(
                                        width: 150,
                                        height: 100,
                                        alignment: .leading
                                    )
                                    
                                    Spacer()
                                    Image(decorative: "htpushup")
                                        .resizable()
                                        .frame(
                                            minWidth: 130,
                                            maxWidth: 140,
                                            maxHeight: 110
                                        )
                                        .cornerRadius(8)
                                }
                                .frame(
                                    width: 300,
                                    height: 125,
                                    alignment: .leading
                                )
                            }
                            .background(alignment: .center) {
                                RoundedRectangle(
                                    cornerRadius: 8,
                                    style: .circular
                                )
                                .strokeBorder(Color(hue: 0.033, saturation: 0.02, brightness: 0.976, opacity: 1), lineWidth: 2)
                                .frame(
                                    width: 325,
                                    height: 125
                                )
                            }
                            .frame(
                                width: 325,
                                height: 125
                            )
                            
                            ZStack {
                                HStack {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Image(systemName: "lock.shield.fill")
                                            Text("Squat")
                                                .font(.system(.title3, design: .default))
                                                .bold()
                                        }
                                        Text("The perfect squat")
                                            .font(.system(.callout, design: .default))
                                        
                                        Text("Intermediate")
                                            .foregroundColor(Color(uiColor: .systemYellow))
                                            .font(.system(.subheadline, design: .default))
                                    }
                                    .frame(
                                        width: 150,
                                        height: 100,
                                        alignment: .leading
                                    )
                                    
                                    Spacer()
                                    Image("htsquat")
                                        .resizable()
                                        .frame(
                                            minWidth: 130,
                                            maxWidth: 140,
                                            maxHeight: 110
                                        )
                                        .cornerRadius(8)
                                }
                                .frame(
                                    width: 300,
                                    height: 125,
                                    alignment: .leading
                                )
                            }
                            .background(alignment: .center) {
                                RoundedRectangle(
                                    cornerRadius: 8,
                                    style: .circular
                                )
                                .strokeBorder(Color(hue: 0.033, saturation: 0.02, brightness: 0.976, opacity: 1), lineWidth: 2)
                                .frame(
                                    width: 325,
                                    height: 125
                                )
                            }
                            .frame(
                                width: 325,
                                height: 125
                            )
                            
                            ZStack {
                                HStack {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Image(systemName: "lock.shield.fill")
                                            Text("Deadlift")
                                                .font(.system(.title3, design: .default))
                                                .bold()
                                        }
                                        Text("Deadlift tips")
                                            .font(.system(.callout, design: .default))
                                        
                                        Text("Advanced")
                                            .foregroundColor(Color(uiColor: .systemRed))
                                            .font(.system(.subheadline, design: .default))
                                    }
                                    .frame(
                                        width: 150,
                                        height: 100,
                                        alignment: .leading
                                    )
                                    
                                    Spacer()
                                    Image("htdeadlift")
                                        .resizable()
                                        .frame(
                                            minWidth: 130,
                                            maxWidth: 140,
                                            maxHeight: 110
                                        )
                                        .cornerRadius(8)
                                }
                                .frame(
                                    width: 300,
                                    height: 125,
                                    alignment: .leading
                                )
                            }
                            .background(alignment: .center) {
                                RoundedRectangle(
                                    cornerRadius: 8,
                                    style: .circular
                                )
                                .strokeBorder(Color(hue: 0.033, saturation: 0.02, brightness: 0.976, opacity: 1), lineWidth: 2)
                                .frame(
                                    width: 325,
                                    height: 125
                                )
                            }
                            .frame(
                                width: 325,
                                height: 125
                            )
                        }
                    }
                }
                .padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0))
            }
        }.onAppear(){
            firestoreManager.getNumWorkouts(uid: authManager.getUserID()){ workoutC, error in
                if let error = error{
                    print("error fetching count")
                }
                if let workoutC=workoutC{
                    print(workoutC)
                    self.workoutCount = workoutC
                }
            }
        }
            
    }
}
