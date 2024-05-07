//
//  ChartView.swift
//  WorkoutPal
//
//  Created by Andy Craig on 2024-03-13.
//

import SwiftUI
import Charts

struct BoxHeight{
    var time: Double
    var height: Double
    init(time: Double, height: Double) {
        self.time = time
        self.height = height
    }
}

struct ChartView: View {
    var box_heights: [BoxHeight]
    init(box_heights: [Double]) {
        self.box_heights = []
        for (i, box_height) in box_heights.enumerated() {
            self.box_heights.append(BoxHeight(time:(Double(i)/10), height: box_height))
        }
    }
    var body: some View {
        Chart(box_heights, id:\.self.time) {
                LineMark(
                    x: .value("Time", $0.time),
                    y: .value("Height", $0.height)
                )
            }
        .chartXScale(domain: 0...Int(Float(box_heights.count)/10))
        .aspectRatio(1.2, contentMode: .fit)
        .padding()
        .chartYAxis(.hidden)
        .chartXAxisLabel("Time (seconds)")
    }
}
