import SwiftUI
import Charts

struct HealthTrackingView: View {
    @EnvironmentObject private var viewModel: SaintDanielsViewModel
    @State private var showingAddGoal = false
    @State private var selectedTimeRange: TimeRange = .week
    
    enum TimeRange: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Health Metrics Overview
                    HealthMetricsOverview(metrics: viewModel.currentUser?.healthMetrics)
                    
                    // Time Range Selector
                    Picker("Time Range", selection: $selectedTimeRange) {
                        ForEach(TimeRange.allCases, id: \.self) { range in
                            Text(range.rawValue).tag(range)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    // Activity Chart
                    ActivityChart(timeRange: selectedTimeRange)
                        .frame(height: 200)
                        .padding()
                    
                    // Health Goals
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("Health Goals")
                                .font(.headline)
                            Spacer()
                            Button(action: { showingAddGoal = true }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal)
                        
                        ForEach(viewModel.healthGoals) { goal in
                            GoalCard(goal: goal)
                        }
                    }
                }
            }
            .navigationTitle("Health Tracking")
            .sheet(isPresented: $showingAddGoal) {
                AddGoalView()
            }
        }
    }
}

struct HealthMetricsOverview: View {
    let metrics: HealthMetrics?
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                MetricCard(
                    title: "Steps",
                    value: "\(metrics?.steps ?? 0)",
                    icon: "figure.walk",
                    color: .blue
                )
                
                MetricCard(
                    title: "Heart Rate",
                    value: "\(metrics?.heartRate ?? 0)",
                    icon: "heart.fill",
                    color: .red
                )
                
                MetricCard(
                    title: "Sleep",
                    value: String(format: "%.1f", metrics?.sleepHours ?? 0),
                    icon: "bed.double.fill",
                    color: .purple
                )
            }
            
            if let bloodPressure = metrics?.bloodPressure {
                HStack {
                    Text("Blood Pressure")
                        .font(.subheadline)
                    Spacer()
                    Text("\(bloodPressure.systolic)/\(bloodPressure.diastolic)")
                        .font(.headline)
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(10)
            }
        }
        .padding()
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)
            Text(value)
                .font(.headline)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(10)
    }
}

struct ActivityChart: View {
    let timeRange: HealthTrackingView.TimeRange
    
    var body: some View {
        // Mock data for the chart
        let data = (0..<7).map { day in
            (date: Date().addingTimeInterval(Double(day) * -86400),
             steps: Int.random(in: 5000...12000))
        }
        
        Chart(data, id: \.date) { item in
            BarMark(
                x: .value("Date", item.date),
                y: .value("Steps", item.steps)
            )
            .foregroundStyle(Color.blue.gradient)
        }
    }
}

struct GoalCard: View {
    let goal: HealthGoal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(iconColor)
                Text(goal.type.rawValue.capitalized)
                    .font(.headline)
                Spacer()
                Text("\(Int(goal.pointsReward)) pts")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            ProgressView(value: goal.current, total: goal.target)
                .tint(iconColor)
            
            HStack {
                Text("\(Int(goal.current))/\(Int(goal.target))")
                    .font(.subheadline)
                Spacer()
                Text(goal.deadline, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    private var iconName: String {
        switch goal.type {
        case .steps: return "figure.walk"
        case .sleep: return "bed.double.fill"
        case .weight: return "scalemass.fill"
        case .exercise: return "figure.run"
        case .checkup: return "stethoscope"
        }
    }
    
    private var iconColor: Color {
        switch goal.type {
        case .steps: return .blue
        case .sleep: return .purple
        case .weight: return .green
        case .exercise: return .orange
        case .checkup: return .red
        }
    }
}

struct AddGoalView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: SaintDanielsViewModel
    
    @State private var selectedType: GoalType = .steps
    @State private var target: Double = 0
    @State private var deadline = Date().addingTimeInterval(7 * 86400)
    @State private var pointsReward: Int = 100
    
    var body: some View {
        NavigationView {
            Form {
                Section("Goal Type") {
                    Picker("Type", selection: $selectedType) {
                        ForEach(GoalType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }
                }
                
                Section("Target") {
                    TextField("Target Value", value: $target, format: .number)
                }
                
                Section("Deadline") {
                    DatePicker("Deadline", selection: $deadline, displayedComponents: .date)
                }
                
                Section("Points Reward") {
                    Stepper("\(pointsReward) points", value: $pointsReward, in: 50...1000, step: 50)
                }
            }
            .navigationTitle("Add Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let goal = HealthGoal(
                            id: UUID().uuidString,
                            type: selectedType,
                            target: target,
                            current: 0,
                            deadline: deadline,
                            pointsReward: pointsReward
                        )
                        viewModel.addHealthGoal(goal)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    HealthTrackingView()
        .environmentObject(SaintDanielsViewModel())
} 