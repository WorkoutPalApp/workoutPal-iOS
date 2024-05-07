//
//  AuthViewComponents.swift
//  WorkoutPal
//
//  Created by Andy Craig on 2024-03-13.
//

//
//  SwiftUIView.swift
//  CactusFB
//
//  Created by Andy Craig on 2024-02-02.
//

import SwiftUI

struct SignUpButton: View {
    var body: some View {
        HStack {
            Image(systemName: "person")
                .scaledToFit()
                .frame(
                    width: 32,
                    height: 32
                )
                .padding([.leading])

            Text("Sign up with Email")
                .padding()

            Spacer()
        }
        .background(alignment: .center) {
            RoundedRectangle(
                cornerRadius: 8,
                style: .circular
            )
            .fill(Color(uiColor: .white))
            .shadow(
                color: Color(hue: 0, saturation: 0, brightness: 0, opacity: 0.333),
                radius: 4,
                x: 0,
                y: 4
            )
        }
    }
}
struct RoundedTextField: View {
    @Binding var text: String
    var placeholder: String
    var keyboardType: UIKeyboardType
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .shadow(color: Color(hue: 0, saturation: 0, brightness: 0, opacity: 0.15), radius: 0, x: 0, y: 4)
            )
            .keyboardType(keyboardType)
    }
}

struct SecureRoundedTextField: View {
    @Binding var text: String
    var body: some View{
        ZStack {
            RoundedRectangle(
                cornerRadius: 8,
                style: .circular
            )
            .fill(Color(uiColor: .white))
            .frame(
                height: 50
            )
            .shadow(
                color: Color(hue: 0, saturation: 0, brightness: 0, opacity: 0.333),
                radius: 4,
                x: 0,
                y: 4
            )

            SecureField("Password", text: $text)
                .keyboardType(.default)
                .padding([.leading])
                .textFieldStyle(.automatic)
        }
    }
}

