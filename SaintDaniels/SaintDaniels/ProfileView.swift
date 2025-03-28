import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var viewModel: SaintDanielsViewModel
    @State private var showingEditProfile = false
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            List {
                // Profile Header
                Section {
                    HStack(spacing: 20) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(viewModel.currentUser?.name ?? "User Name")
                                .font(.headline)
                            Text(viewModel.currentUser?.email ?? "email@example.com")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 10)
                }
                
                // Quick Actions
                Section("Quick Actions") {
                    NavigationLink {
                        Text("View Activity History")
                    } label: {
                        Label("Activity History", systemImage: "clock.fill")
                    }
                    
                    NavigationLink {
                        Text("View Rewards History")
                    } label: {
                        Label("Rewards History", systemImage: "gift.fill")
                    }
                    
                    NavigationLink {
                        Text("View Claims History")
                    } label: {
                        Label("Claims History", systemImage: "doc.text.fill")
                    }
                }
                
                // Health Goals
                Section("Health Goals") {
                    ForEach(viewModel.healthGoals) { goal in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(goal.type.rawValue.capitalized)
                                .font(.subheadline)
                            ProgressView(value: goal.current, total: goal.target)
                                .tint(.blue)
                            Text("\(Int(goal.current))/\(Int(goal.target))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                // Settings
                Section {
                    Button(action: { showingEditProfile = true }) {
                        Label("Edit Profile", systemImage: "pencil")
                    }
                    
                    Button(action: { showingSettings = true }) {
                        Label("Settings", systemImage: "gear")
                    }
                    
                    Button(action: {
                        viewModel.signOut()
                    }) {
                        Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.red)
                    }
                }
                
                // App Info
                Section {
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
                    }
                    
                    NavigationLink {
                        Text("Terms of Service")
                    } label: {
                        Text("Terms of Service")
                    }
                }
            }
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
                    .background(Color.blue)
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
                    Toggle("Email Notifications", isOn: $notificationsEnabled)
                    Toggle("SMS Notifications", isOn: $notificationsEnabled)
                }
                
                Section("Health & Fitness") {
                    Toggle("Connect with HealthKit", isOn: $healthKitEnabled)
                    Toggle("Share Health Data", isOn: $healthKitEnabled)
                }
                
                Section("Appearance") {
                    Toggle("Dark Mode", isOn: $darkModeEnabled)
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