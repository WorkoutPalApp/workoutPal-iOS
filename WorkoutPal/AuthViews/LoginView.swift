//
//  LoginView.swift
//  WorkoutPal
//
//  Created by Andy Craig on 2024-03-13.
//
//
//  Login.swift
//  CactusFB
//
//  Created by Andy Craig on 2024-02-02.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var firestoreManager: FirestoreManager
    @State private var navigationLinkActive = false
    @State private var password: String
    @State private var email: String
    init(password: String = "", email: String = "") {
        _password = State(initialValue: password)
        _email = State(initialValue: email)
    }
    func SignInUser(){
        authManager.signIn(email: email, password: password) { result in
            switch result {
            case .success(let user):
                navigationLinkActive = true
            case .failure(let error):
                print("Error creating user: \(error.localizedDescription)")
            }
        }
    }
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .fill(Color(uiColor: .systemGreen))
                    .ignoresSafeArea(edges: [.all])

                VStack {
                    Capsule(
                        style: .circular
                    )
                    .fill(Color(uiColor: .black))
                    .frame(
                        height: 2
                    )

                    HStack {
                        Text("Login to your Cactus account!")
                            .font(.system(.largeTitle, design: .default))
                            .bold()
                            .lineLimit(2)
                            .padding([.trailing, .top, .bottom], 7)

                        Spacer()
                    }
                    HStack {
                        Text("Enter your email and password to log into your Cactus account. ")
                            .font(.system(.title3, design: .default))

                        Spacer()
                    }
                    Divider()
                    RoundedTextField(text: $email, placeholder: "Email", keyboardType: .emailAddress)
                    SecureRoundedTextField(text: $password)
                    Spacer()
                    NavigationLink {
                        SignUpView()

                    } label: {
                        HStack {
                            Text("Don't have an account? Sign up")
                                .font(.system(.body, design: .default))
                                .foregroundColor(Color(uiColor: .black))
                                .multilineTextAlignment(.leading)

                            Spacer()
                        }
                    }
                    .buttonStyle(.automatic)

                    HStack(spacing: 0) {
                        HStack {
                            Image(systemName: "lock.fill")
                            Text("We never share this with anyone and it won't be on your profile.")
                                .font(.system(.footnote, design: .default))
                        }
                        Button(action:{
                            SignInUser()
                        }, label:{
                            Image(systemName: "chevron.right")
                                .font(.system(size: 19, weight: .heavy, design: .default))
                                .padding()
                                .background(alignment: .center) {
                                    Circle()
                                        .fill(Color(hue: 0.7222222222222218, saturation: 0.136, brightness: 0.086, opacity: 1))
                                }
                                .foregroundColor(Color(uiColor: .white))
                        })
                        .navigationDestination(isPresented: $navigationLinkActive) {
                            ContentView()
                        }
                    }
                }
                .padding(40)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .foregroundColor(Color(uiColor: .black))
            }
        }
    }
}

