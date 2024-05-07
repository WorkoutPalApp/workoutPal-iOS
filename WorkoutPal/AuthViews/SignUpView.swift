//
//  SignUpView.swift
//  WorkoutPal
//
//  Created by Andy Craig on 2024-03-13.
//

//
//  CreateUser.swift
//  CactusFB
//
//  Created by Andy Craig on 2024-02-02.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var firestoreManager: FirestoreManager
    @State private var navigationLinkActive = false
    @State private var password: String
    @State private var firstName: String
    @State private var lastName: String
    @State private var email: String

    init(password: String = "", firstName: String = "", lastName: String = "", email: String = "") {
        _password = State(initialValue: password)
        _firstName = State(initialValue: firstName)
        _lastName = State(initialValue: lastName)
        _email = State(initialValue: email)
    }
    
    func SignUpUser(){
        authManager.signUp(email: email, password: password) { result in
            switch result {
            case .success(let user):
                // User creation successful, now add the user to the 'users' collection
                firestoreManager.createUser(email: email, uid: user.uid, firstName: firstName, lastName: lastName) { error in
                    if let error = error {
                        print("Error adding user to Firestore: \(error.localizedDescription)")
                    } else {
                        print("User added to Firestore successfully")

                        // Now, navigate to the CreateBusiness view
                        navigationLinkActive = true
                    }
                }
            case .failure(let error):
                print("Error creating user: \(error.localizedDescription)")
            }
        }
    }

    var body: some View {
        ZStack {
            Text("SignUp")
            NavigationStack {
                ZStack {
                    Rectangle()
                        .fill(Color(uiColor: .systemGreen))
                        .ignoresSafeArea(edges: [.all])

                    VStack(alignment: .leading, spacing: 16) {
                        ZStack(alignment: .leading) {
                            Capsule(
                                style: .circular
                            )
                            .fill(Color(hue: 0.3063151041666667, saturation: 0.572, brightness: 0.551, opacity: 1))
                            .frame(
                                height: 3
                            )

                            Capsule(
                                style: .circular
                            )
                            .fill(Color(hue: 0.7222222222222218, saturation: 0.136, brightness: 0.086, opacity: 1))
                            .frame(
                                width: 100,
                                height: 3
                            )
                        }
                        Text("Create your Cactus account!")
                            .font(.system(.largeTitle, design: .default))
                            .bold()
                            .lineLimit(2...)

                        Text("Enter your info to start earning and redeeming your rewards!")
                            .font(.system(.title3, design: .default))

                        Divider()
                        RoundedTextField(text: $email, placeholder: "Email", keyboardType: .emailAddress)
                        
                        HStack {
                            RoundedTextField(text: $firstName, placeholder: "First Name", keyboardType: .default)
                            RoundedTextField(text: $lastName, placeholder: "Last Name", keyboardType: .default)
                        }
                        SecureRoundedTextField(text: $password)
                        
                        Spacer()
                        NavigationLink {
                            LoginView()

                        } label: {
                            Text("Already have an account? Sign In")
                        }
                        .buttonStyle(.automatic)
                        .navigationBarBackButtonHidden(true)

                        HStack(spacing: 0) {
                            HStack {
                                Image(systemName: "lock.fill")
                                Text("We never share this with anyone and it won't be on your profile.")
                                    .font(.system(.footnote, design: .default))
                            }
                            Button(action:{
                                SignUpUser()
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
                        maxWidth: .infinity
                    )
                    .foregroundColor(Color(hue: 0.7222222222222218, saturation: 0.136, brightness: 0.086, opacity: 1))
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

