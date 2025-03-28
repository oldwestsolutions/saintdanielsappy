import Foundation

// User Model
struct User: Identifiable, Codable {
    let id: String
    var name: String
    var email: String
    var points: Int
    var insurancePlan: InsurancePlan
    var healthMetrics: HealthMetrics
    var recentActivities: [Activity]
}

// Insurance Plan Model
struct InsurancePlan: Codable {
    let planName: String
    let planType: String
    let coverageDetails: CoverageDetails
    let claims: [Claim]
}

struct CoverageDetails: Codable {
    let deductible: Double
    let copay: Double
    let coinsurance: Double
    let outOfPocketMax: Double
}

struct Claim: Identifiable, Codable {
    let id: String
    let date: Date
    let amount: Double
    let status: ClaimStatus
    let description: String
}

enum ClaimStatus: String, Codable {
    case pending
    case approved
    case denied
    case processed
}

// Health Metrics Model
struct HealthMetrics: Codable {
    var steps: Int
    var heartRate: Int
    var sleepHours: Double
    var weight: Double?
    var bloodPressure: BloodPressure?
}

struct BloodPressure: Codable {
    let systolic: Int
    let diastolic: Int
    let timestamp: Date
}

// Activity Model
struct Activity: Identifiable, Codable {
    let id: String
    let type: ActivityType
    let points: Int
    let timestamp: Date
    let description: String
}

enum ActivityType: String, Codable {
    case steps
    case workout
    case sleep
    case checkup
    case vaccination
    case medication
}

// Rewards Model
struct Reward: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let pointsCost: Int
    let category: RewardCategory
    let imageURL: String?
}

enum RewardCategory: String, Codable {
    case giftCards
    case health
    case fitness
    case wellness
    case merchandise
}

// Health Goals Model
struct HealthGoal: Identifiable, Codable {
    let id: String
    let type: GoalType
    let target: Double
    let current: Double
    let deadline: Date
    let pointsReward: Int
}

enum GoalType: String, Codable {
    case steps
    case sleep
    case weight
    case exercise
    case checkup
} 