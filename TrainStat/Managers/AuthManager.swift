import Foundation
import FirebaseAuth
import FirebaseCore

enum AuthState {
    case authenticated // Anonymously authenticated in Firebase.
    case signedIn       // Authenticated in Firebase using one of service providers, and not anonymous.
    case signedOut      // Not authenticated in Firebase.
}

@MainActor
class AuthManager: ObservableObject {
    @Published var user: User?
    @Published var authState: AuthState = .signedOut
    
    private var authStateHandle: AuthStateDidChangeListenerHandle!
    
    init() {
        configureAuthStateChanges()
    }
    
    func signUp(email: String, password: String) async throws -> AuthDataResult? {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            print("FirebaseAuthSuccess: Signed up with email: \(email), UID: \(result.user.uid)")
            return result
        } catch {
            print("FirebaseAuthError: Failed to sign up with email: \(email), error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func signIn(email: String, password: String) async throws -> AuthDataResult? {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            print("FirebaseAuthSuccess: Signed in with email: \(email), UID: \(result.user.uid)")
            return result
        } catch {
            print("FirebaseAuthError: Failed to sign in with email: \(email), error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func signInAnonymously() async throws -> AuthDataResult? {
        do {
            let result = try await Auth.auth().signInAnonymously()
            print("FirebaseAuthSuccess: Signed in anonymously, UID: \(result.user.uid)")
            return result
        } catch {
            print("FirebaseAuthError: Failed to sign in anonymously: \(error.localizedDescription)")
            throw error
        }
    }
    
    func signOut() async throws {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                print("FirebaseAuthSuccess: Signed out successfully.")
            } catch let error as NSError {
                print("FirebaseAuthError: Failed to sign out from Firebase, \(error.localizedDescription)")
                throw error
            }
        }
    }
    
    func authenticateUser(credentials: AuthCredential) async throws -> AuthDataResult? {
        if Auth.auth().currentUser != nil {
            return try await authLink(credentials: credentials)
        } else {
            return try await authSignIn(credentials: credentials)
        }
    }
    
    private func authSignIn(credentials: AuthCredential) async throws -> AuthDataResult? {
        do {
            let result = try await Auth.auth().signIn(with: credentials)
            updateState(user: result.user)
            return result
        } catch {
            print("FirebaseAuthError: signIn(with:) failed. \(error.localizedDescription)")
            throw error
        }
    }
    
    private func authLink(credentials: AuthCredential) async throws -> AuthDataResult? {
        guard let user = Auth.auth().currentUser else { return nil }
        do {
            let result = try await user.link(with: credentials)
            updateState(user: result.user)
            return result
        } catch {
            print("FirebaseAuthError: link(with:) failed, \(error.localizedDescription)")
            throw error
        }
    }
    
    func updateDisplayName(to newName: String) async throws {
        guard let currentUser = Auth.auth().currentUser else {
            throw AuthError.userNotFound
        }
        let changeRequest = currentUser.createProfileChangeRequest()
        changeRequest.displayName = newName
        do {
            try await changeRequest.commitChanges()
            self.user = Auth.auth().currentUser
            print("FirebaseAuthSuccess: Display name updated to \(newName)")
        } catch {
            print("FirebaseAuthError: Failed to update display name. \(error.localizedDescription)")
            throw error
        }
    }
    
    func changePassword(to newPassword: String) async throws {
        guard let currentUser = Auth.auth().currentUser else {
            throw AuthError.userNotFound
        }
        do {
            try await currentUser.updatePassword(to: newPassword)
            print("FirebaseAuthSuccess: Password updated successfully.")
        } catch {
            print("FirebaseAuthError: Failed to update password. \(error.localizedDescription)")
            throw error
        }
    }
    
    private func configureAuthStateChanges() {
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            self.updateState(user: user)
        }
    }
    
    private func updateState(user: User?) {
        self.user = user
        let isAuthenticatedUser = user != nil
        let isAnonymous = user?.isAnonymous ?? false
        
        if isAuthenticatedUser {
            self.authState = isAnonymous ? .authenticated : .signedIn
        } else {
            self.authState = .signedOut
        }
    }

    enum AuthError: LocalizedError {
        case userNotFound
        case invalidPassword
        case passwordMismatch
        
        var errorDescription: String? {
            switch self {
            case .userNotFound:
                return "User not found."
            case .invalidPassword:
                return "The password provided is invalid."
            case .passwordMismatch:
                return "Passwords do not match."
            }
        }
    }
}
