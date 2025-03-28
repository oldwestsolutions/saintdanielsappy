//
//  SaintDanielsApp.swift
//  SaintDaniels
//
//  Created by user277255 on 3/27/25.
//

import SwiftUI

@main
struct SaintDanielsApp: App {
    @StateObject private var viewModel = SaintDanielsViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}

struct WelcomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Theme.backgroundColor.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header with logo
                    HStack {
                        Image("shield-logo") // Add shield logo asset
                            .resizable()
                            .frame(width: 40, height: 40)
                        Text("Saint Daniels")
                            .font(Theme.Typography.headlineFont)
                            .foregroundColor(Theme.primaryColor)
                        Spacer()
                        NavigationLink("Login") {
                            LoginView()
                        }
                        .foregroundColor(Theme.secondaryColor)
                    }
                    .padding()
                    .background(Color.white)
                    
                    ScrollView {
                        VStack(spacing: 40) {
                            // Hero Image and Text
                            Image("royal-hero") // Add medieval painting asset
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 400)
                                .clipped()
                            
                            VStack(spacing: 16) {
                                Text("ROYAL\nHEALTHCARE")
                                    .font(Theme.Typography.titleFont)
                                    .foregroundColor(Theme.secondaryColor)
                                    .multilineTextAlignment(.center)
                                
                                Text("Take control of your healthcare journey with rewards fit for royalty. Sign up today and begin earning points towards a healthier, more rewarding future.")
                                    .font(Theme.Typography.bodyFont)
                                    .foregroundColor(Theme.primaryColor)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                
                                NavigationLink {
                                    SignUpView()
                                } label: {
                                    Text("BEGIN YOUR ROYAL JOURNEY")
                                        .font(.system(size: 16, weight: .semibold))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 14)
                                        .foregroundColor(.white)
                                        .background(Theme.secondaryColor)
                                        .cornerRadius(8)
                                        .padding(.horizontal)
                                }
                            }
                            .padding(.bottom, 40)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: SaintDanielsViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var rememberMe = false
    @State private var showError = false
    
    var body: some View {
        ZStack {
            Theme.backgroundColor.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with logo
                HStack {
                    Image("shield-logo")
                        .resizable()
                        .frame(width: 40, height: 40)
                    Spacer()
                }
                .padding()
                .background(Color.white)
                
                ScrollView {
                    RoyalCard {
                        VStack(spacing: 24) {
                            VStack(spacing: 8) {
                                Text("Welcome Back")
                                    .font(Theme.Typography.headlineFont)
                                    .foregroundColor(Theme.primaryColor)
                                
                                Text("Please sign in to your account")
                                    .font(Theme.Typography.bodyFont)
                                    .foregroundColor(.secondary)
                            }
                            
                            VStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Email address")
                                        .font(Theme.Typography.captionFont)
                                    TextField("Enter your email", text: $email)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .textContentType(.emailAddress)
                                        .autocapitalization(.none)
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("Password")
                                            .font(Theme.Typography.captionFont)
                                        Spacer()
                                        Button("Forgot password?") {
                                            // TODO: Implement forgot password
                                        }
                                        .font(Theme.Typography.captionFont)
                                        .foregroundColor(Theme.secondaryColor)
                                    }
                                    
                                    SecureField("Enter your password", text: $password)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .textContentType(.password)
                                }
                                
                                Toggle("Remember me", isOn: $rememberMe)
                                    .font(Theme.Typography.captionFont)
                                    .tint(Theme.secondaryColor)
                            }
                            
                            VStack(spacing: 16) {
                                RoyalButton("SIGN IN") {
                                    login()
                                }
                                
                                HStack {
                                    Text("Don't have an account?")
                                        .font(Theme.Typography.captionFont)
                                    NavigationLink("Sign up") {
                                        SignUpView()
                                    }
                                    .font(Theme.Typography.captionFont)
                                    .foregroundColor(Theme.secondaryColor)
                                }
                            }
                        }
                        .padding()
                    }
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.error?.localizedDescription ?? "An error occurred")
        }
    }
    
    private func login() {
        Task {
            do {
                try await viewModel.signIn(email: email, password: password)
            } catch {
                viewModel.error = error
                showError = true
            }
        }
    }
}

struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var agreedToTerms = false
    
    var body: some View {
        ZStack {
            Theme.backgroundColor.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with logo
                HStack {
                    Image("shield-logo")
                        .resizable()
                        .frame(width: 40, height: 40)
                    Spacer()
                }
                .padding()
                .background(Color.white)
                
                ScrollView {
                    RoyalCard {
                        VStack(spacing: 24) {
                            VStack(spacing: 8) {
                                Text("Create Your Royal Account")
                                    .font(Theme.Typography.headlineFont)
                                    .foregroundColor(Theme.primaryColor)
                                
                                Text("Join our exclusive healthcare rewards program")
                                    .font(Theme.Typography.bodyFont)
                                    .foregroundColor(.secondary)
                            }
                            
                            VStack(spacing: 16) {
                                HStack(spacing: 16) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("First Name")
                                            .font(Theme.Typography.captionFont)
                                        TextField("Enter first name", text: $firstName)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Last Name")
                                            .font(Theme.Typography.captionFont)
                                        TextField("Enter last name", text: $lastName)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Email Address")
                                        .font(Theme.Typography.captionFont)
                                    TextField("Enter email", text: $email)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .textContentType(.emailAddress)
                                        .autocapitalization(.none)
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Phone Number")
                                        .font(Theme.Typography.captionFont)
                                    TextField("Enter phone number", text: $phone)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .textContentType(.telephoneNumber)
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Password")
                                        .font(Theme.Typography.captionFont)
                                    SecureField("Create password", text: $password)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .textContentType(.newPassword)
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Confirm Password")
                                        .font(Theme.Typography.captionFont)
                                    SecureField("Confirm password", text: $confirmPassword)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .textContentType(.newPassword)
                                }
                                
                                HStack {
                                    Toggle("", isOn: $agreedToTerms)
                                        .labelsHidden()
                                        .tint(Theme.secondaryColor)
                                    
                                    Text("I agree to the ")
                                        .font(Theme.Typography.captionFont) +
                                    Text("Terms of Service")
                                        .foregroundColor(Theme.secondaryColor)
                                        .font(Theme.Typography.captionFont) +
                                    Text(" and ")
                                        .font(Theme.Typography.captionFont) +
                                    Text("Privacy Policy")
                                        .foregroundColor(Theme.secondaryColor)
                                        .font(Theme.Typography.captionFont)
                                }
                            }
                            
                            VStack(spacing: 16) {
                                RoyalButton("Create Your Royal Account") {
                                    // TODO: Implement sign up
                                }
                                
                                HStack {
                                    Text("Already have an account?")
                                        .font(Theme.Typography.captionFont)
                                    Button("Login here") {
                                        dismiss()
                                    }
                                    .font(Theme.Typography.captionFont)
                                    .foregroundColor(Theme.secondaryColor)
                                }
                            }
                        }
                        .padding()
                    }
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
    }
}
