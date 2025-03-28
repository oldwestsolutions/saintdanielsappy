import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var viewModel: SaintDanielsViewModel
    @State private var showingEditProfile = false
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile Header
                    RoyalCard {
                        HStack(spacing: 20) {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(Theme.secondaryColor)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(viewModel.currentUser?.name ?? "User Name")
                                    .font(Theme.Typography.bodyFont)
                                    .foregroundColor(Theme.primaryColor)
                                Text(viewModel.currentUser?.email ?? "email@example.com")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 10)
                    }
                    .padding(.horizontal)
                    
                    // Quick Actions
                    RoyalCard {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Quick Actions")
                                .font(Theme.Typography.bodyFont)
                                .foregroundColor(Theme.primaryColor)
                            
                            NavigationLink {
                                Text("View Activity History")
                            } label: {
                                Label("Activity History", systemImage: "clock.fill")
                                    .foregroundColor(Theme.secondaryColor)
                            }
                            
                            NavigationLink {
                                Text("View Rewards History")
                            } label: {
                                Label("Rewards History", systemImage: "gift.fill")
                                    .foregroundColor(Theme.secondaryColor)
                            }
                            
                            NavigationLink {
                                Text("View Claims History")
                            } label: {
                                Label("Claims History", systemImage: "doc.text.fill")
                                    .foregroundColor(Theme.secondaryColor)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Health Goals
                    RoyalCard {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Health Goals")
                                .font(Theme.Typography.bodyFont)
                                .foregroundColor(Theme.primaryColor)
                            
                            if viewModel.healthGoals.isEmpty {
                                Text("No goals set")
                                    .foregroundColor(.secondary)
                                    .padding(.vertical)
                            } else {
                                ForEach(viewModel.healthGoals) { goal in
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(goal.type.rawValue.capitalized)
                                            .font(.subheadline)
                                        ProgressView(value: goal.current, total: goal.target)
                                            .tint(Theme.secondaryColor)
                                        Text("\(Int(goal.current))/\(Int(goal.target))")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Settings
                    RoyalCard {
                        VStack(spacing: 15) {
                            Button(action: { showingEditProfile = true }) {
                                Label("Edit Profile", systemImage: "pencil")
                                    .foregroundColor(Theme.secondaryColor)
                            }
                            
                            Button(action: { showingSettings = true }) {
                                Label("Settings", systemImage: "gear")
                                    .foregroundColor(Theme.secondaryColor)
                            }
                            
                            Button(action: {
                                viewModel.signOut()
                            }) {
                                Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // App Info
                    RoyalCard {
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("Version")
                                Spacer()
                                Text("1.0.0")
                                    .foregroundColor(.secondary)
                            }
                            
                            NavigationLink {
                                Text("Privacy Policy")
                            } label: {
                                Text("Privacy Policy")
                                    .foregroundColor(Theme.secondaryColor)
                            }
                            
                            NavigationLink {
                                Text("Terms of Service")
                            } label: {
                                Text("Terms of Service")
                                    .foregroundColor(Theme.secondaryColor)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Theme.backgroundColor)
            .navigationTitle("Profile")
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView()
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
    }
}

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: SaintDanielsViewModel
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var address: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Personal Information") {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                    TextField("Phone", text: $phone)
                        .textContentType(.telephoneNumber)
                    TextField("Address", text: $address)
                }
                
                Section {
                    Button("Save Changes") {
                        // TODO: Implement profile update
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding()
                    .background(Theme.secondaryColor)
                    .cornerRadius(10)
                }
            }
            .navigationTitle("Edit Profile")
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

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var notificationsEnabled = true
    @State private var healthKitEnabled = true
    @State private var darkModeEnabled = false
    @State private var language = "English"
    
    let languages = ["English", "Spanish", "French", "German", "Chinese"]
    
    var body: some View {
        NavigationView {
            Form {
                Section("Notifications") {
                    Toggle("Push Notifications", isOn: $notificationsEnabled)
                        .tint(Theme.secondaryColor)
                    Toggle("Email Notifications", isOn: $notificationsEnabled)
                        .tint(Theme.secondaryColor)
                    Toggle("SMS Notifications", isOn: $notificationsEnabled)
                        .tint(Theme.secondaryColor)
                }
                
                Section("Health & Fitness") {
                    Toggle("Connect with HealthKit", isOn: $healthKitEnabled)
                        .tint(Theme.secondaryColor)
                    Toggle("Share Health Data", isOn: $healthKitEnabled)
                        .tint(Theme.secondaryColor)
                }
                
                Section("Appearance") {
                    Toggle("Dark Mode", isOn: $darkModeEnabled)
                        .tint(Theme.secondaryColor)
                    Picker("Language", selection: $language) {
                        ForEach(languages, id: \.self) { language in
                            Text(language).tag(language)
                        }
                    }
                }
                
                Section("Data") {
                    Button("Export Health Data") {
                        // TODO: Implement data export
                    }
                    .foregroundColor(Theme.secondaryColor)
                    
                    Button("Clear App Data") {
                        // TODO: Implement data clearing
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(SaintDanielsViewModel())
} 