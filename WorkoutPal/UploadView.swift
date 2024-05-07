import AVKit
import PhotosUI
import SwiftUI

struct Video: Transferable {
    let url: URL

    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .movie) { movie in
            SentTransferredFile(movie.url)
        } importing: { received in
            let copy = URL.documentsDirectory.appending(path: "video.mp4")

            if FileManager.default.fileExists(atPath: copy.path()) {
                try FileManager.default.removeItem(at: copy)
            }

            try FileManager.default.copyItem(at: received.file, to: copy)
            return Self.init(url: copy)
        }
    }
}


func createWorkoutFromResponse(response:ResponseModel) -> Workout {
    let reps = response.repetitions?.count ?? 0
    
    return Workout(total_duration: response.total_duration, active_duration: response.active_duration, exercise: response.exercise, calories_burned: response.calories_burned, rep_count: reps, date: Date(),load: response.load, average_rep_time: response.average_rep_time, intensity: response.intensity, squat_height_data: response.squat_height_data)
}

struct UploadView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var firestoreManager: FirestoreManager
    @Binding var workoutPending: Bool
    @Binding var completedWorkout: Workout
    
    @State private var videoURL: URL
    @State private var intensity: Double
    @State private var load: Double
    @State private var body_weight: Double
    
    init(workoutPending: Binding<Bool>,completedWorkout:Binding<Workout>, body_weight: Double = 191, intensity: Double = 7, load: Double = 135, videoURL: URL = URL(fileURLWithPath: "video.mp4")) {
        _intensity = State(initialValue: intensity)
        _load = State(initialValue: load)
        _videoURL = State(initialValue: videoURL)
        _body_weight = State(initialValue: body_weight)
        self._completedWorkout = completedWorkout
        self._workoutPending = workoutPending
    }

    
    func uploadFile(file:Data, fileName: String, fileExtension: String){
        var mimeType = "video/mp4"

        let url = "http://andycraig1.pythonanywhere.com/upload_video"

        let request = MultipartFormDataRequest(url: URL(string: url)!)
        request.addTextField(named: "intensity", value: String(Int(intensity)))
        request.addTextField(named: "body_weight", value: String(191))
        request.addTextField(named: "load", value: String(Int(load)))
        request.addDataField(fieldName:  "file", fileName: fileName, data: file, mimeType: mimeType)
        self.workoutPending = true
        URLSession.shared.dataTask(with: request, completionHandler: {data,urlResponse,error in
            // Check for errors
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            // Check if there is data
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                // Decode JSON data
                // Print the decoded data
                let decoder = JSONDecoder()
                let responseModel = try decoder.decode(ResponseModel.self, from: data)
                let workout = createWorkoutFromResponse(response: responseModel)
                firestoreManager.createWorkout(workout: workout, uid: authManager.getUserID()) { error in
                    if let error = error {
                        print("Error adding workout to Firestore: \(error.localizedDescription)")
                    } else {
                        print("Workout added to Firestore successfully")
                    }
                }
                        // Access response fields
                self.completedWorkout = workout
                self.workoutPending = false
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }).resume()
    }
    var body: some View {
            ZStack {
                Rectangle()
                    .fill(Color(uiColor: .tertiarySystemFill))
                    .ignoresSafeArea(edges: [.all])

                VStack(spacing: 16) {
                    Text("Upload Workout")
                        .font(.system(.largeTitle))
                        .bold()
                        .multilineTextAlignment(.center)

                    Text("Use the sliders to set the workout intensity and load weight. Once the workout has been analyzed, it will be available in your Workout History")
                        .multilineTextAlignment(.center)

                    Divider()
                    HStack(spacing: 0) {
                        Spacer()
                        UploadViewComponent(videoURL:$videoURL)
                        Spacer(minLength: 24)
                    }
                    .padding(17)
                    .background(alignment: .center) {
                        RoundedRectangle(
                            cornerRadius: 8,
                            style: .circular
                        )
                        .fill(Color(uiColor: .systemBackground))
                    }

                    VStack() {
                        VStack {

                            HStack(spacing: 0) {
                                Text("Intensity")
                                    .font(.system(.headline, design: .default))
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .leading
                                    )
                                Spacer()
                                Text(intensity.formatted())
                                
                            }
                            .font(.system(.title3, design: .default))

                            Slider(value: $intensity, in: 0 ... 10, step: 1) {
                                Text("Slider")
                            }
                            .tint(Color(uiColor: .black))
                        }
                        VStack {
                            HStack(spacing: 0) {
                                Text("Body weight")
                                    .font(.system(.headline, design: .default))
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .leading
                                    )
                                Spacer()
                                Text(body_weight.formatted())
                                Text(" lbs")
                                
                            }
                            .font(.system(.title3, design: .default))

                            Slider(value: $body_weight, in: 0 ... 300, step: 1) {
                                Text("Slider")
                            }
                            .tint(Color(uiColor: .black))
                        }
                        VStack {
                            HStack(spacing: 0) {
                                Text("Load weight")
                                    .font(.system(.headline, design: .default))
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .leading
                                    )
                                Spacer()
                                Text(load.formatted())
                                Text(" lbs")
                                Spacer()
                            }
                            .font(.system(.title3, design: .default))

                            Slider(value: $load, in: 0 ... 500, step: 5) {
                                Text("Slider")
                            }
                            .tint(Color(uiColor: .black))
                        }
                    }
                    .padding()
                    .background(alignment: .center) {
                        RoundedRectangle(
                            cornerRadius: 16,
                            style: .circular
                        )
                        .fill(Color(uiColor: .systemBackground))
                    }

                    Divider()
                    if workoutPending{
                        HStack(spacing: 0) {
                            Spacer()
                                
                            
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))

                            Spacer(minLength: 24)
                        }
                        .padding()
                        .background(alignment: .center) {
                            RoundedRectangle(
                                cornerRadius: 8,
                                style: .circular
                            )
                            .fill(Color(uiColor: .systemOrange))
                        }
                        HStack(){
                            Text("Analysis in progress, please wait a minute.")
                                .foregroundColor(Color(uiColor: .systemGray2))
                        }
                        
                    }else{
                        HStack(spacing: 0) {
                            Spacer()
                            Button {
                                do {
                                    uploadFile(file: try Data(contentsOf: videoURL), fileName: "filename", fileExtension: "mp4")
                                } catch let error {
                                    print(error)
                                }
                            } label: {
                                Text("Analyse Workout")
                            }
                            .foregroundColor(Color(uiColor: .white))

                            Spacer(minLength: 24)
                        }
                        .padding()
                        .background(alignment: .center) {
                            RoundedRectangle(
                                cornerRadius: 8,
                                style: .circular
                            )
                            .fill(Color(uiColor: .systemIndigo))
                        }
                        HStack(){
                            Text("Analysis usually takes a minute to complete.")
                                .foregroundColor(Color(uiColor: .systemGray2))
                        }
                    }
                    
                }
                .padding()
            }
        }
}
