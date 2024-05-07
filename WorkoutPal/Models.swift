//
//  Models.swift
//  WorkoutPal
//
//  Created by Andy Craig on 2024-03-13.
//

import Foundation
import FirebaseFirestore

struct ResponseModel: Codable {
    let repetitions: [Repetition]?
    let total_duration: Double
    let active_duration: Double
    let calories_burned: Double
    let intensity: Int
    let exercise: String
    let load: Int
    let average_rep_time: Double
    let squat_height_data: [Double]
}

struct Repetition: Codable {
    let start_time: Double
    let end_time: Double
    let elapsed_time: Double
}


struct Customer: Codable {
    var email: String
    var first_name: String
    var last_name: String
    var uid: String
}

struct Business: Codable {
    @DocumentID var ID : String?
    var businessName: String
    var uid: String
    
}

struct Workout: Codable, Hashable {
    @DocumentID var ID : String?
    var total_duration: Double
    var active_duration: Double
    var exercise: String
    var calories_burned: Double
    var rep_count: Int
    var date: Date
    var load: Int
    var average_rep_time: Double
    var intensity: Int
    var squat_height_data: [Double]
}

struct Reward : Codable, Hashable {
    var id = UUID()
    var rewardName: String
    var rewardCost: Double
}
