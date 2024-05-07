//
//  UploadViewComponent.swift
//  WorkoutPal
//
//  Created by Andy Craig on 2024-03-13.
//
import AVKit
import PhotosUI
import SwiftUI

struct UploadViewComponent: View {
    @Binding var videoURL: URL
    enum LoadState {
        case unknown, loading, loaded(Video), failed
    }
    @State private var loadState = LoadState.unknown
    @State private var selectedItem: PhotosPickerItem?

    var body: some View {
        HStack {
            
            PhotosPicker("Choose video", selection: $selectedItem, matching: .videos)
            switch loadState {
            case .unknown:
                Image(systemName: "arrow.up.circle.fill").foregroundColor(.blue)
            case .loading:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
            case .loaded(let video):
                Image(systemName: "checkmark.circle.fill").foregroundColor(.blue)
            case .failed:
                Text("Import failed")
            }
        }
        .onChange(of: selectedItem) { _ in
            Task {
                do {
                    loadState = .loading

                    if let video = try await selectedItem?.loadTransferable(type: Video.self) {
                        videoURL = video.url
                        loadState = .loaded(video)
                    } else {
                        loadState = .failed
                    }
                } catch {
                    loadState = .failed
                }
            }
        }
    }
}

