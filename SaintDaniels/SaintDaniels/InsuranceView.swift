import SwiftUI

struct InsuranceView: View {
    @EnvironmentObject private var viewModel: SaintDanielsViewModel
    @State private var showingNewClaim = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Insurance Plan Overview
                    if let plan = viewModel.currentUser?.insurancePlan {
                        InsurancePlanCard(plan: plan)
                    }
                    
                    // Coverage Details
                    if let coverage = viewModel.currentUser?.insurancePlan.coverageDetails {
                        CoverageDetailsCard(coverage: coverage)
                    }
                    
                    // Claims Section
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("Recent Claims")
                                .font(.headline)
                            Spacer()
                            Button(action: { showingNewClaim = true }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal)
                        
                        if let claims = viewModel.currentUser?.insurancePlan.claims {
                            ForEach(claims) { claim in
                                ClaimCard(claim: claim)
                            }
                        } else {
                            Text("No claims found")
                                .foregroundColor(.secondary)
                                .padding()
                        }
                    }
                }
            }
            .navigationTitle("Insurance")
            .sheet(isPresented: $showingNewClaim) {
                NewClaimView()
            }
        }
    }
}

struct InsurancePlanCard: View {
    let plan: InsurancePlan
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "shield.fill")
                    .font(.title)
                    .foregroundColor(.blue)
                VStack(alignment: .leading) {
                    Text(plan.planName)
                        .font(.headline)
                    Text(plan.planType)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Divider()
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Member Since")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("Jan 1, 2024")
                        .font(.subheadline)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Policy Number")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("POL-123456789")
                        .font(.subheadline)
                }
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(15)
        .padding(.horizontal)
    }
}

struct CoverageDetailsCard: View {
    let coverage: CoverageDetails
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Coverage Details")
                .font(.headline)
            
            HStack {
                CoverageItem(
                    title: "Deductible",
                    value: String(format: "$%.2f", coverage.deductible)
                )
                
                CoverageItem(
                    title: "Copay",
                    value: String(format: "$%.2f", coverage.copay)
                )
            }
            
            HStack {
                CoverageItem(
                    title: "Coinsurance",
                    value: String(format: "%.0f%%", coverage.coinsurance * 100)
                )
                
                CoverageItem(
                    title: "Out of Pocket Max",
                    value: String(format: "$%.2f", coverage.outOfPocketMax)
                )
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
        .padding(.horizontal)
    }
}

struct CoverageItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ClaimCard: View {
    let claim: Claim
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading) {
                    Text(claim.description)
                        .font(.headline)
                    Text(claim.date, style: .date)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(String(format: "$%.2f", claim.amount))
                    .font(.headline)
            }
            
            HStack {
                StatusBadge(status: claim.status)
                Spacer()
                Button(action: {}) {
                    Text("View Details")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct StatusBadge: View {
    let status: ClaimStatus
    
    var body: some View {
        Text(status.rawValue.capitalized)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
    
    private var backgroundColor: Color {
        switch status {
        case .pending: return .orange
        case .approved: return .green
        case .denied: return .red
        case .processed: return .blue
        }
    }
}

struct NewClaimView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: SaintDanielsViewModel
    
    @State private var description = ""
    @State private var amount: Double = 0
    @State private var date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section("Claim Details") {
                    TextField("Description", text: $description)
                    TextField("Amount", value: $amount, format: .currency(code: "USD"))
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
                
                Section {
                    Button("Submit Claim") {
                        // TODO: Implement claim submission
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                }
            }
            .navigationTitle("New Claim")
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
    InsuranceView()
        .environmentObject(SaintDanielsViewModel())
} 