import Foundation
import SwiftUI

class SaintDanielsViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var rewards: [Reward] = []
    @Published var healthGoals: [HealthGoal] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    // MARK: - User Management
    func signIn(email: String, password: String) async throws {
        isLoading = true
        defer { isLoading = false }
        
        // TODO: Implement actual authentication
        // This is a mock implementation
        let mockUser = User(
            id: UUID().uuidString,
            name: "John Doe",
            email: email,
            points: 2500,
            insurancePlan: mockInsurancePlan,
            healthMetrics: mockHealthMetrics,
            recentActivities: mockActivities
        )
        
        DispatchQueue.main.async {
            self.currentUser = mockUser
        }
    }
    
    func signOut() {
        currentUser = nil
    }
    
    // MARK: - Health Metrics
    func updateHealthMetrics(_ metrics: HealthMetrics) {
        guard var user = currentUser else { return }
        user.healthMetrics = metrics
        currentUser = user
    }
    
    // MARK: - Points & Rewards
    func addPoints(_ amount: Int) {
        guard var user = currentUser else { return }
        user.points += amount
        currentUser = user
    }
    
    func redeemReward(_ reward: Reward) async throws {
        guard var user = currentUser,
              user.points >= reward.pointsCost else {
            throw NSError(domain: "SaintDaniels", code: 1, userInfo: [NSLocalizedDescriptionKey: "Insufficient points"])
        }
        
        user.points -= reward.pointsCost
        currentUser = user
    }
    
    // MARK: - Health Goals
    func addHealthGoal(_ goal: HealthGoal) {
        healthGoals.append(goal)
    }
    
    func updateHealthGoal(_ goal: HealthGoal) {
        if let index = healthGoals.firstIndex(where: { $0.id == goal.id }) {
            healthGoals[index] = goal
        }
    }
    
    // MARK: - Mock Data
    private var mockInsurancePlan: InsurancePlan {
        InsurancePlan(
            planName: "Premium Health Plus",
            planType: "PPO",
            coverageDetails: CoverageDetails(
                deductible: 1000,
                copay: 25,
                coinsurance: 0.2,
                outOfPocketMax: 5000
            ),
            claims: []
        )
    }
    
    private var mockHealthMetrics: HealthMetrics {
        HealthMetrics(
            steps: 8234,
            heartRate: 72,
            sleepHours: 7.5,
            weight: 75.5,
            bloodPressure: BloodPressure(systolic: 120, diastolic: 80, timestamp: Date())
        )
    }
    
    private var mockActivities: [Activity] {
        [
            Activity(
                id: UUID().uuidString,
                type: .steps,
                points: 100,
                timestamp: Date(),
                description: "Completed Daily Steps Goal"
            ),
            Activity(
                id: UUID().uuidString,
                type: .workout,
                points: 200,
                timestamp: Date().addingTimeInterval(-86400),
                description: "Completed 30-minute Workout"
            ),
            Activity(
                id: UUID().uuidString,
                type: .sleep,
                points: 150,
                timestamp: Date().addingTimeInterval(-172800),
                description: "Achieved 8 Hours of Sleep"
            )
        ]
    }
} 