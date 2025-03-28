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
                    if let metrics = viewModel.currentUser?.healthMetrics {
                        HealthMetricsOverview(metrics: metrics)
                    }
                    
                    // Time Range Selector
                    RoyalCard {
                        Picker("Time Range", selection: $selectedTimeRange) {
                            ForEach(TimeRange.allCases, id: \.self) { range in
                                Text(range.rawValue).tag(range)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding(.horizontal)
                    
                    // Activity Chart
                    RoyalCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Activity Trends")
                                .font(Theme.Typography.bodyFont)
                                .foregroundColor(Theme.primaryColor)
                            
                            ActivityChart(timeRange: selectedTimeRange)
                                .frame(height: 200)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Health Goals
                    RoyalCard {
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("Health Goals")
                                    .font(Theme.Typography.bodyFont)
                                    .foregroundColor(Theme.primaryColor)
                                Spacer()
                                Button {
                                    showingAddGoal = true
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(Theme.secondaryColor)
                                }
                            }
                            
                            if viewModel.healthGoals.isEmpty {
                                Text("No goals set")
                                    .foregroundColor(.secondary)
                                    .padding(.vertical)
                            } else {
                                ForEach(viewModel.healthGoals) { goal in
                                    GoalCard(goal: goal)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Theme.backgroundColor)
            .navigationTitle("Health Tracking")
            .sheet(isPresented: $showingAddGoal) {
                AddGoalView()
            }
        }
    }
}

struct HealthMetricsOverview: View {
    let metrics: HealthMetrics
    
    var body: some View {
        RoyalCard {
            VStack(spacing: 15) {
                HStack {
                    MetricCard(
                        title: "Steps",
                        value: "\(metrics.steps)",
                        icon: "figure.walk",
                        color: Theme.secondaryColor
                    )
                    
                    MetricCard(
                        title: "Heart Rate",
                        value: "\(metrics.heartRate)",
                        icon: "heart.fill",
                        color: .red
                    )
                    
                    MetricCard(
                        title: "Sleep",
                        value: String(format: "%.1f", metrics.sleepHours),
                        icon: "bed.double.fill",
                        color: .purple
                    )
                }
                
                if let bloodPressure = metrics.bloodPressure {
                    HStack {
                        Text("Blood Pressure")
                            .font(.subheadline)
                        Spacer()
                        Text("\(bloodPressure.systolic)/\(bloodPressure.diastolic)")
                            .font(.headline)
                    }
                    .padding()
                    .background(Theme.secondaryColor.opacity(0.1))
                    .cornerRadius(10)
                }
            }
        }
        .padding(.horizontal)
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
            .foregroundStyle(Theme.secondaryColor.gradient)
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
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
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
        case .steps: return Theme.secondaryColor
        case .sleep: return .purple
        case .weight: return .green
        case .exercise: return .orange
        case .checkup: return Theme.primaryColor
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
                        .keyboardType(.decimalPad)
                }
                
                Section("Deadline") {
                    DatePicker("Deadline", selection: $deadline, displayedComponents: .date)
                }
                
                Section("Points Reward") {
                    Stepper("\(pointsReward) points", value: $pointsReward, in: 50...1000, step: 50)
                }
                
                Section {
                    Button("Add Goal") {
                        let goal = HealthGoal(
                            id: UUID().uuidString,
                            type: selectedType,
                            target: target,
                            current: 0,
                            deadline: deadline,
                            pointsReward: Double(pointsReward)
                        )
                        viewModel.addHealthGoal(goal)
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding()
                    .background(Theme.secondaryColor)
                    .cornerRadius(10)
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
            }
        }
    }
}

#Preview {
    HealthTrackingView()
        .environmentObject(SaintDanielsViewModel())
} 