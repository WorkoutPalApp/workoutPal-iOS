//
//  AuthManager.swift
//  WorkoutPal
//
//  Created by Andy Craig on 2024-03-13.
//

//
//  Auth.swift
//  Cactus for Businesses
//
//  Created by Andy Craig on 2024-01-08.
//

import SwiftUI
import Firebase

class AuthManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String?
    @Published var userID: String?
    
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let user = authResult?.user {
                self.userID = user.uid
                self.isLoggedIn = true
                completion(.success(user))
            } else if let error = error {
                self.errorMessage = "Error signing in: \(error.localizedDescription)"
                print("Error signing in: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let user = authResult?.user {
                self.userID = user.uid
                completion(.success(user))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.isLoggedIn = false
        } catch {
            self.errorMessage = "Error signing out: \(error.localizedDescription)"
        }
    }

    func resetPassword(email: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.errorMessage = "Error resetting password: \(error.localizedDescription)"
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    func checkLoggedIn() {
            if let user = Auth.auth().currentUser {
                self.isLoggedIn = true
                self.userID = user.uid // Set userID to the UID of the current user
            } else {
                self.isLoggedIn = false
                self.userID = nil // No user is logged in, so set userID to nil
            }
        }
    func getUserID() -> String {
        return self.userID!
    }
    
    
    func signInWithGoogle() {
        // Implement Google Sign In here
    }
}
