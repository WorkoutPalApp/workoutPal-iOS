//
//  WorkoutHistoryView.swift
//  WorkoutPal
//
//  Created by Andy Craig on 2024-03-13.
//
import SwiftUI

struct WorkoutHistoryView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var firestoreManager: FirestoreManager
    @State var loading = true
    @State var workouts: [Workout]
    
    init(workouts: [Workout] = [Workout(total_duration: 10, active_duration: 5, exercise: "Squat", calories_burned: 5, rep_count: 3, date: Date(), load: 135, average_rep_time: 3.3, intensity: 7, squat_height_data:[1,2,3]) ]) {
        _workouts = State(initialValue: workouts)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: true) {
                if (loading == true){
                    ProgressView()
                }else{
                    ListView(workouts: workouts)
                }
            }
            .navigationTitle("Workout History")
            .refreshable {
                firestoreManager.fetchUserWorkouts(userId: authManager.getUserID()) { (list, error) in
                    if let error = error {
                        print("Error fetching user workouts: \(error.localizedDescription)")
                    } else if let list = list {
                        self.workouts = list
                        loading=false
                    }
                }
                Task { @MainActor in
                    try await Task.sleep(for: .seconds(1))
                }
                
            }
        }
        .onAppear{
            firestoreManager.fetchUserWorkouts(userId: authManager.getUserID()) { (list, error) in
                if let error = error {
                    print("Error fetching user workouts: \(error.localizedDescription)")
                } else if let list = list {
                    self.workouts = list
                    loading=false
                }
            }}
    }
}


struct ListView: View {
    var workouts: [Workout]
    var body: some View {
        VStack(spacing: 0) {
            ForEach(workouts, id:\.self.ID) { workout in
                Row(workout: workout)
            }
        }
    }
}

struct Row: View {
    var workout: Workout

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    var body: some View {
        VStack(spacing: 0) {
            NavigationLink {
                KeyValuePairsView(workout: workout)

            } label: {
                HStack(spacing: 16) {
                    Image(workout.exercise)
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: 64,
                            height: 64
                        )
                        .mask(alignment: .center) {
                            RoundedRectangle(
                                cornerRadius: 8,
                                style: .circular
                            )
                            .fill(Color(uiColor: .systemGray))
                        }

                    VStack(alignment: .leading, spacing: 0) {
                        Text(workout.exercise)
                            .font(.system(.subheadline, design: .default))
                            .lineLimit(1)

                        Text(formatDate(workout.date))
                            .font(.system(.footnote, design: .default))
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                            .lineLimit(1)
                    }
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .lineLimit(1)

                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color(uiColor: .tertiaryLabel))
                }
                .background(alignment: .center) {
                    Rectangle()
                        .fill(Color(uiColor: .systemBackground))
                }
                .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
            }
            .buttonStyle(.plain)

            Divider()
        }
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
    }
}


struct Detail: View {
    @Environment(\.dismiss) private var envDismiss

    @Binding private var image: Image
    @Binding private var subtitle: String
    @Binding private var title: String

    init(image: Binding<Image> = .constant(Image("Placeholder")), subtitle: Binding<String> = .constant("Subtitle"), title: Binding<String> = .constant("Title")) {
        _image = image
        _subtitle = subtitle
        _title = title
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 16) {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: 240,
                        height: 240
                    )
                    .mask(alignment: .center) {
                        RoundedRectangle(
                            cornerRadius: 16,
                            style: .circular
                        )
                        .fill(Color(uiColor: .systemGray))
                    }
                    .background(alignment: .center) {
                        RoundedRectangle(
                            cornerRadius: 16,
                            style: .circular
                        )
                        .fill(Color(uiColor: .systemBackground))
                        .shadow(
                            color: Color(hue: 0, saturation: 0, brightness: 0, opacity: 0.2),
                            radius: 8,
                            x: 0,
                            y: 8
                        )
                    }
                    .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))

                VStack(spacing: 0) {
                    Text(title)
                        .bold()

                    Text(subtitle)
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                }
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                .font(.system(.title3, design: .default))

                HStack(spacing: 16) {
                    Button {
                        envDismiss()
                    } label: {
                        Text("Button 1")
                            .frame(
                                maxWidth: .infinity
                            )
                    }
                    .buttonStyle(.borderedProminent)

                    Button {
                        envDismiss()
                    } label: {
                        Text("Button 2")
                            .frame(
                                maxWidth: .infinity
                            )
                    }
                    .buttonStyle(.bordered)
                }
                Divider()
                VStack(alignment: .leading) {
                    Text("Description")
                        .font(.system(.headline, design: .default))

                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. In orci nibh, ornare ac varius a, hendrerit eu lorem. Cras ac ligula purus. Phasellus efficitur velit at nulla finibus, eget placerat elit luctus. Pellentesque faucibus iaculis tempus. Fusce finibus cursus sapien non iaculis. Duis ac lorem sed erat venenatis tempor lacinia eget massa. Integer finibus leo in nunc euismod tempus id quis ipsum. Nullam pulvinar dui dolor, ultricies pharetra urna finibus sed. Quisque tempus diam blandit dolor eleifend blandit.")
                        .lineLimit(4)
                }
                .frame(
                    maxWidth: .infinity
                )
            }
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct KeyValuePairsView: View {
    var workout: Workout
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(workout.exercise + " on " + formatDate(workout.date))
                .foregroundColor(Color(uiColor: .secondaryLabel))
            Divider()
            ChartView(box_heights:workout.squat_height_data)
            KeyValueView(key: "Total Duration", value: "\(Int(workout.total_duration)) seconds")
            KeyValueView(key: "Active Duration", value: "\(Int(workout.active_duration)) seconds")
            KeyValueView(key: "Calories Burned", value: "\(String(format: "%.2f", workout.calories_burned)) kcal")
            KeyValueView(key: "Average Rep Time", value: "\(String(format: "%.2f", workout.average_rep_time)) seconds")
            KeyValueView(key: "Rep Count", value: "\(workout.rep_count)")
            KeyValueView(key: "Intensity", value: "\(workout.intensity)/10")
        }
        .navigationTitle("Exercise Summary")
        .padding()
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct KeyValueView: View {
    var key: String
    var value: String
    
    var body: some View {
        HStack {
            Text(key)
                .font(.headline)
            Spacer()
            Text(value)
                .foregroundColor(.gray)
        }
    }
}
