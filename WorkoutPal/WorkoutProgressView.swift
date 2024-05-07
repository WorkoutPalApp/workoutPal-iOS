//
//  workoutProgressView.swift
//  WorkoutPal
//
//  Created by Andy Craig on 2024-03-14.
//

import SwiftUI

struct WorkoutProgressView: View {
    var workoutsCompleted: Int
    let workoutGoal: Int = 10
    @State var progressValue: Float = 0.3
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var degress: Double = -110
    
    var body: some View {
        
        VStack {
            ZStack{
                
                ProgressBar(text:String(workoutsCompleted) + "/" + String(workoutGoal), progress: self.$progressValue)
                    .frame(width: 250.0, height: 250.0)
                    .padding(40.0).onReceive(timer) { _ in
                        withAnimation {
                            var value:Float = 0.0
                            if workoutsCompleted<workoutGoal{
                                value = Float(3+workoutsCompleted)/(3+Float(workoutGoal))
                            }else{
                                value = 0.9
                            }
                            
                            if progressValue < value{
                                progressValue += 0.0275
                            }
                        }
                    }
            }
            Spacer()
        }
        .onAppear(){
            progressValue=0.3
        }
    }
    
    struct ProgressBar: View {
        var text: String
        @Binding var progress: Float
        
        var body: some View {
            ZStack {
                Circle()
                    .trim(from: 0.3, to: 0.9)
                    .stroke(style: StrokeStyle(lineWidth: 12.0, lineCap: .round, lineJoin: .round))
                    .opacity(0.3)
                    .foregroundColor(Color.gray)
                    .rotationEffect(.degrees(54.5))
                
                Circle()
                    .trim(from: 0.3, to: CGFloat(self.progress))
                    .stroke(style: StrokeStyle(lineWidth: 12.0, lineCap: .round, lineJoin: .round))
                    .fill(AngularGradient(gradient: Gradient(stops: [
                        .init(color: Color.init(hex: "ED4D4D"), location: 0.39000002),
                        .init(color: Color.init(hex: "E59148"), location: 0.48000002),
                        .init(color: Color.init(hex: "EFBF39"), location: 0.5999999),
                        .init(color: Color.init(hex: "EEED56"), location: 0.7199998),
                        .init(color: Color.init(hex: "32E1A0"), location: 0.8099997)]), center: .center))
                    .rotationEffect(.degrees(54.5))
                
                VStack{
                    Text(text).font(Font.system(size: 44)).bold().foregroundColor(Color.init(hex: "314058"))
                    Text("Workouts!").bold().foregroundColor(Color.init(hex: "32E1A0"))
                }
            }
        }
    }
    
    struct ProgressBarTriangle: View {
        @Binding var progress: Float
        
        
        var body: some View {
            ZStack {
                Image("triangle").resizable().frame(width: 10, height: 10, alignment: .center)
            }
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
