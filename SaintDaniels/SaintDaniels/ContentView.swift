//
//  ContentView.swift
//  SaintDaniels
//
//  Created by user277255 on 3/27/25.
//

import SwiftUI
import CoreData

class TabRouter: ObservableObject {
    @Published var selectedTab = 0
}

struct ContentView: View {
    @EnvironmentObject private var viewModel: SaintDanielsViewModel
    @StateObject private var router = TabRouter()
    
    var body: some View {
        Group {
            if viewModel.isAuthenticated {
                TabView(selection: $router.selectedTab) {
                    DashboardView(router: router)
                        .tabItem {
                            Label("Dashboard", systemImage: "house.fill")
                        }
                        .tag(0)
                    
                    RewardsView()
                        .tabItem {
                            Label("Rewards", systemImage: "gift.fill")
                        }
                        .tag(1)
                    
                    HealthTrackingView()
                        .tabItem {
                            Label("Health", systemImage: "heart.fill")
                        }
                        .tag(2)
                    
                    InsuranceView()
                        .tabItem {
                            Label("Insurance", systemImage: "shield.fill")
                        }
                        .tag(3)
                    
                    ProfileView()
                        .tabItem {
                            Label("Profile", systemImage: "person.fill")
                        }
                        .tag(4)
                }
                .accentColor(Theme.secondaryColor)
            } else {
                WelcomeView()
            }
        }
    }
}

struct DashboardView: View {
    @EnvironmentObject private var viewModel: SaintDanielsViewModel
    @ObservedObject var router: TabRouter
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Welcome Message
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Welcome Back, \(viewModel.currentUser?.name.components(separatedBy: " ").first ?? "User")!")
                            .font(Theme.Typography.headlineFont)
                            .foregroundColor(Theme.primaryColor)
                        Text("Manage your healthcare rewards and track your progress")
                            .font(Theme.Typography.bodyFont)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // Points Balance Card
                    RoyalCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Points Balance")
                                .font(Theme.Typography.bodyFont)
                                .foregroundColor(Theme.primaryColor)
                            
                            Text("\(viewModel.currentUser?.points ?? 0)")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(Theme.primaryColor)
                            
                            Text("Available Rewards Points")
                                .font(Theme.Typography.captionFont)
                                .foregroundColor(.secondary)
                            
                            // Progress Bar
                            VStack(alignment: .leading, spacing: 8) {
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(height: 8)
                                        
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Theme.secondaryColor)
                                            .frame(width: geometry.size.width * 0.75, height: 8)
                                    }
                                }
                                .frame(height: 8)
                                
                                Text("Next tier: 500 points away")
                                    .font(Theme.Typography.captionFont)
                                    .foregroundColor(.secondary)
                            }
                            
                            Button {
                                router.selectedTab = 1
                            } label: {
                                Text("VIEW REWARDS")
                                    .font(.system(size: 16, weight: .semibold))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .foregroundColor(.white)
                                    .background(Theme.secondaryColor)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Recent Activity Card
                    RoyalCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Recent Activity")
                                .font(Theme.Typography.bodyFont)
                                .foregroundColor(Theme.primaryColor)
                            
                            VStack(spacing: 16) {
                                ForEach(viewModel.currentUser?.recentActivities.prefix(3) ?? [], id: \.id) { activity in
                                    HStack(spacing: 12) {
                                        Circle()
                                            .fill(Theme.secondaryColor)
                                            .frame(width: 8, height: 8)
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(activity.description)
                                                .font(Theme.Typography.bodyFont)
                                            
                                            Text("\(activity.points) points")
                                                .font(Theme.Typography.captionFont)
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        Spacer()
                                        
                                        Text(activity.timestamp, style: .date)
                                            .font(Theme.Typography.captionFont)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    if activity.id != viewModel.currentUser?.recentActivities.prefix(3).last?.id {
                                        Divider()
                                    }
                                }
                            }
                            
                            Button {
                                // TODO: Navigate to activity history
                            } label: {
                                Text("VIEW ALL ACTIVITIES")
                                    .font(.system(size: 16, weight: .semibold))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .foregroundColor(.white)
                                    .background(Theme.secondaryColor)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Coverage Level Card
                    RoyalCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Coverage Level")
                                .font(Theme.Typography.bodyFont)
                                .foregroundColor(Theme.primaryColor)
                            
                            Text("Premium Plus")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Theme.primaryColor)
                            
                            Text("Active until December 31, 2024")
                                .font(Theme.Typography.bodyFont)
                                .foregroundColor(.secondary)
                            
                            VStack(spacing: 12) {
                                CoverageRow(title: "Deductible", value: "$500")
                                CoverageRow(title: "Co-pay", value: "$20")
                                CoverageRow(title: "Out-of-pocket Max", value: "$2,000")
                            }
                            
                            Button {
                                router.selectedTab = 3
                            } label: {
                                Text("VIEW COVERAGE DETAILS")
                                    .font(.system(size: 16, weight: .semibold))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .foregroundColor(.white)
                                    .background(Theme.secondaryColor)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Quick Actions Card
                    RoyalCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Quick Actions")
                                .font(Theme.Typography.bodyFont)
                                .foregroundColor(Theme.primaryColor)
                            
                            VStack(spacing: 12) {
                                Button {
                                    // TODO: Implement find a doctor
                                } label: {
                                    Text("FIND A DOCTOR")
                                        .font(.system(size: 16, weight: .semibold))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 14)
                                        .foregroundColor(.white)
                                        .background(Theme.secondaryColor)
                                        .cornerRadius(8)
                                }
                                
                                Button {
                                    // TODO: Implement contact support
                                } label: {
                                    Text("CONTACT SUPPORT")
                                        .font(.system(size: 16, weight: .semibold))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 14)
                                        .foregroundColor(.white)
                                        .background(Theme.secondaryColor)
                                        .cornerRadius(8)
                                }
                                
                                Button {
                                    router.selectedTab = 4
                                } label: {
                                    Text("ACCOUNT SETTINGS")
                                        .font(.system(size: 16, weight: .semibold))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 14)
                                        .foregroundColor(.white)
                                        .background(Theme.secondaryColor)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Theme.backgroundColor)
            .navigationTitle("Dashboard")
        }
    }
}

struct CoverageRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(Theme.Typography.bodyFont)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(Theme.Typography.bodyFont)
                .foregroundColor(Theme.primaryColor)
        }
    }
}

// Placeholder Views
struct RewardsView: View {
    var body: some View {
        Text("Rewards View")
    }
}

struct HealthTrackingView: View {
    var body: some View {
        Text("Health Tracking View")
    }
}

struct InsuranceView: View {
    var body: some View {
        Text("Insurance View")
    }
}

struct ProfileView: View {
    var body: some View {
        Text("Profile View")
    }
}

#Preview {
    ContentView()
        .environmentObject(SaintDanielsViewModel())
}
