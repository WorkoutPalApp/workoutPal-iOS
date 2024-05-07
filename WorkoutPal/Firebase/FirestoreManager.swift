//
//  FirestoreManager.swift
//  Cactus for Businesses
//
//  Created by Andy Craig on 2024-01-12.
//

import FirebaseFirestore
import FirebaseAuth

class FirestoreManager: ObservableObject {
    static let shared = FirestoreManager()
    private var db: Firestore!
    
    
    func configureFirestore() {
        db = Firestore.firestore()
    }
    // MARK: - Users Collection
    
    func createUser(email: String, uid: String, firstName: String, lastName: String, completion: @escaping (Error?) -> Void) {
        let userDocRef = db.collection("users").document(uid)
        let userData: [String: Any] = [
            "email": email,
            "uid": uid,
            "first_name": firstName,
            "last_name": lastName
        ]
        
        userDocRef.setData(userData) { error in
            completion(error)
        }
    }
    func getNumWorkouts(uid: String, completion: @escaping (Int?, Error?) -> Void){
        let workoutsCollection = db.collection("users").document(uid).collection("workouts")
        workoutsCollection.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error)")
                completion(nil, error)
            }

            if let snapshot = snapshot {
                completion(snapshot.documents.count, nil)
            }
        }
    }
    func createWorkout(workout:Workout, uid: String, completion: @escaping (Error?) -> Void) {
        let workoutsCollection = db.collection("users").document(uid).collection("workouts")
        do {
                _ = try workoutsCollection.addDocument(from: workout) { error in
                    if let error = error {
                        print("Error adding document: \(error)")
                        completion(error)
                    } else {
                        print("Document added successfully")
                        completion(nil)
                    }
                }
            } catch {
                print("Error encoding workout: \(error)")
                completion(error)
            }
    }
    func fetchUserWorkouts(userId: String, completion: @escaping ([Workout]?, Error?) -> Void) {
        let db = Firestore.firestore()
        let workoutsRef = db.collection("users").document(userId).collection("workouts")
        
        workoutsRef.getDocuments { (snapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            var workouts: [Workout] = []
            
            for document in snapshot!.documents {
                do {
                    let workoutData = try document.data(as: Workout.self)
                    workouts.append(workoutData)
                    
                } catch let error {
                    print("Error decoding workout data: \(error)")
                }
            }
            workouts = workouts.sorted(by: {
                $0.date.compare($1.date) == .orderedDescending
            })
            completion(workouts.isEmpty ? nil : workouts, nil)
        }
    }
    
    func updateUser(uid: String, firstName: String, lastName: String, completion: @escaping (Error?) -> Void) {
        let userDocRef = db.collection("users").document(uid)
        let updatedData: [String: Any] = [
            "first_name": firstName,
            "last_name": lastName
        ]
        
        userDocRef.updateData(updatedData) { error in
            completion(error)
        }
    }
    
    func deleteUser(uid: String, completion: @escaping (Error?) -> Void) {
        let userDocRef = db.collection("users").document(uid)
        
        userDocRef.delete { error in
            completion(error)
        }
    }
    
    func fetchUser(userID: String, completion: @escaping (Customer?) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { (document, error) in
            if let document = document, document.exists {
                do{
                    let customer = try document.data(as: Customer.self)
                    completion(customer)
                } catch {
                    print("Error decoding user document: \(error)")
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    
    // ** ADD TIME STAMP **
    // ** Deal with business collection insert
    func addRewards(uid: String, businessID: String, transactionValue: Double, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        
        let rewardsDocRef = db.collection("users").document(uid).collection("rewardsPoints").document(businessID)
        
        rewardsDocRef.getDocument { document, error in
            if let document = document, document.exists, document.documentID == businessID {   // check if customer already has rewards with this business
                var currentRewards = document.data()?["rewardsPoints"] as? Double ?? 0.0
                currentRewards += transactionValue
                
                rewardsDocRef.updateData(["rewardsPoints" : currentRewards]) { error in
                    if let error = error {
                        print("Error Adding Rewards")
                        completion(error)
                    } else {
                        print("Rewards Points Successfully Added")
                        print("User ID: ", uid)
                        print("BusinessID: ", businessID)
                        completion(nil)
                    }
                }
            } else { // customer has not collected rewards with this business yet, create new entry
                let rewardsData: [String : Any] = [
                    "businessID": businessID,
                    "rewardsPoints" : transactionValue
                ]
                
                rewardsDocRef.setData(rewardsData) { error in
                    if let error = error {
                        print("Error adding rewards points")
                        completion(error)
                    } else {
                        print("Added new rewards points entry")
                        completion(nil)
                    }
                }
                
            }
            // add entry with customerID to the business collection as well
            
        }
    }
    
    // ** ADD TIME STAMP **
    func redeemRewards (uid: String, businessID: String, rewardValue: Double, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        
        let rewardsDocRef = db.collection("users").document(uid).collection("rewardsPoints").document(businessID)
        
        rewardsDocRef.getDocument { document, error in
            if let document = document, document.exists, document.documentID == businessID {   // check if customer already has rewards with this business
                var currentRewards = document.data()?["rewardsPoints"] as? Double ?? 0.0
                var temp = currentRewards
                temp = currentRewards - rewardValue
                
                if (temp <= 0) {
                    print("Not enough rewards points")
                    completion(nil)
                    return
                } else {
                    currentRewards -= rewardValue
                }
                
                rewardsDocRef.updateData(["rewardsPoints" : currentRewards]) { error in
                    if let error = error {
                        print("Error Adding Rewards")
                        completion(error)
                    } else {
                        print("Rewards Points Successfully Redeemed")
                        print("User ID: ", uid)
                        print("BusinessID: ", businessID)
                        completion(nil)
                    }
                }
            } else {
                print("User has not collected rewards with business with ID:", businessID)
            }
        }
    }
    
    
    // MARK: Customers Collection
    
    func getRewards (uid: String, businessID: String, completion: @escaping (Double?) -> Void) {
        let rewardsPointsRef = db.collection("customers").document(uid).collection("rewardsPoints").document(businessID)
        rewardsPointsRef.getDocument { document, error  in
            if let error = error {
                print(error)
                completion(nil)
            }
            if let document = document, document.exists {
                let rewardsPointsValue = document.data()?["rewardsPoints"] as? Double
                completion(rewardsPointsValue)
            } else {
                print("failed to extract rewards points value")
                completion(nil)
            }
            
        }
        
    }
    
    // MARK: - Businesses Collection
    
    func getRewardsList(businessID: String, completion: @escaping ([Reward]?) -> Void) {
        let rewardCollectionRef = db.collection("businesses").document(businessID).collection("rewards")
        
        rewardCollectionRef.getDocuments { querySnapshot, error in
            if error != nil {
                print("Error Fetching Rewards")
                completion([])
            }
            var rewards : [Reward] = []
            for document in querySnapshot!.documents {
                let rewardData = document.data()
                let rewardName = rewardData["rewardName"] as? String ?? ""
                let rewardCost = rewardData["rewardCost"] as? Double ?? 0.0
                let reward = Reward(rewardName: rewardName, rewardCost: rewardCost)
                rewards.append(reward)
                
            }
            completion(rewards)
        }
    }
    
    func createReward(businessID: String, reward: Reward, completion: @escaping (Error?) -> Void) {
        let rewardDocRef = db.collection("businesses").document(businessID).collection("rewards")
        
        let rewardData: [String: Any] = [
            "rewardName": reward.rewardName,
            "rewardCost": reward.rewardCost
        ]
        
        rewardDocRef.addDocument(data: rewardData) { error in
            if let error = error {
                print("Error adding reward document: \(error.localizedDescription)")
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func deleteReward(businessID: String, reward: Reward, completion: @escaping (Error?) -> Void) {
        let rewardDocRef = db.collection("businesses").document(businessID).collection("rewards").document(reward.id.uuidString)
        
        rewardDocRef.delete { error in
            if let error = error {
                print("Error deleting reward document: \(error.localizedDescription)")
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
}
