import SwiftUI

struct RewardsView: View {
    @EnvironmentObject private var viewModel: SaintDanielsViewModel
    @State private var selectedCategory: RewardCategory?
    @State private var showingRedeemAlert = false
    @State private var selectedReward: Reward?
    
    private let categories: [RewardCategory] = [
        .giftCards,
        .health,
        .fitness,
        .wellness,
        .merchandise
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Points Balance
                    RoyalCard {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Available Points")
                                    .font(Theme.Typography.bodyFont)
                                    .foregroundColor(Theme.primaryColor)
                                Text("\(viewModel.currentUser?.points ?? 0)")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(Theme.primaryColor)
                            }
                            Spacer()
                            Image(systemName: "star.fill")
                                .font(.title)
                                .foregroundColor(Theme.secondaryColor)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Categories
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(categories, id: \.self) { category in
                                CategoryButton(
                                    category: category,
                                    isSelected: selectedCategory == category,
                                    action: { selectedCategory = category }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Rewards Grid
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 20) {
                        ForEach(filteredRewards) { reward in
                            RewardCard(reward: reward) {
                                selectedReward = reward
                                showingRedeemAlert = true
                            }
                        }
                    }
                    .padding()
                }
                .padding(.vertical)
            }
            .background(Theme.backgroundColor)
            .navigationTitle("Rewards")
            .alert("Redeem Reward", isPresented: $showingRedeemAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Redeem") {
                    if let reward = selectedReward {
                        Task {
                            try? await viewModel.redeemReward(reward)
                        }
                    }
                }
            } message: {
                if let reward = selectedReward {
                    Text("Are you sure you want to redeem '\(reward.name)' for \(reward.pointsCost) points?")
                }
            }
        }
    }
    
    private var filteredRewards: [Reward] {
        guard let category = selectedCategory else {
            return viewModel.rewards
        }
        return viewModel.rewards.filter { $0.category == category }
    }
}

struct CategoryButton: View {
    let category: RewardCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(category.rawValue.capitalized)
                .font(Theme.Typography.bodyFont)
                .fontWeight(.medium)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(isSelected ? Theme.secondaryColor : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : Theme.primaryColor)
                .cornerRadius(20)
        }
    }
}

struct RewardCard: View {
    let reward: Reward
    let onRedeem: () -> Void
    
    var body: some View {
        RoyalCard {
            VStack(alignment: .leading, spacing: 10) {
                // Reward Image
                if let imageURL = reward.imageURL {
                    AsyncImage(url: URL(string: imageURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color.gray.opacity(0.2)
                    }
                    .frame(height: 120)
                    .clipped()
                    .cornerRadius(8)
                } else {
                    Color.gray.opacity(0.2)
                        .frame(height: 120)
                        .cornerRadius(8)
                }
                
                // Reward Info
                VStack(alignment: .leading, spacing: 5) {
                    Text(reward.name)
                        .font(Theme.Typography.bodyFont)
                        .foregroundColor(Theme.primaryColor)
                    
                    Text(reward.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(Theme.secondaryColor)
                        Text("\(reward.pointsCost)")
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.primaryColor)
                    }
                    .font(.subheadline)
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
                
                // Redeem Button
                Button(action: onRedeem) {
                    Text("Redeem")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Theme.secondaryColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 8)
            }
        }
    }
}

#Preview {
    RewardsView()
        .environmentObject(SaintDanielsViewModel())
} 