//
//  ContentView.swift
//  MyWhatsUp
//
//  Created by Aram on 20.05.24.
//

import SwiftUI
import Firebase

class FirebaseManager: NSObject {
     
    let auth: Auth
    
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        super.init()
    }
}

struct LoginView: View {
    @State private var isLoginMode = false
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    Picker("my picker", selection: $isLoginMode) {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }
                    .pickerStyle(.segmented)
                    
                    
                    if !isLoginMode {
                        Button {
                            
                        } label: {
                            Image(systemName: "person.fill")
                                .font(.system(size: 64))
                                .padding()
                        }
                    }
                    
                    Group {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.none)
                            
                        SecureField("Password", text: $password)
                    }
                    .padding(12)
                    .background(.white)
                    
                    
                    
                    Button {
                        handleAction()
                    } label: {
                        Text(isLoginMode ? "Log In" : "Create Account")                        .frame(width: 360, height: 50)
                            .foregroundStyle(.white)
                            .background(.blue)
                            .cornerRadius(10)
                            .fontWeight(.semibold)
                    }
                    
                }
                
                .padding()
            }
            .navigationTitle(isLoginMode ? "Log In" : "Create Account")
            .background(Color(.init(white: 0, alpha: 0.05)))
        }
        .navigationViewStyle(.stack)
    }
    
    private func handleAction() {
        if isLoginMode {
            loginUser()
        } else {
            createUser()
        }
    }
    
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, error in
            if let error {
                print("Failed to login user")
            }
            
            print("User has successfully loged in with id \(result?.user.uid ?? "")")
        }
    }
    
    private func createUser() {
        FirebaseManager.shared.auth .createUser(withEmail: email, password: password) { result, error in
            if let error {
                print("Failed to create user \(error.localizedDescription)")
                return
            }
            
            print("Successfully created user: \(result?.user.uid ?? "")")
        }
    }
}

#Preview {
    LoginView()
}
