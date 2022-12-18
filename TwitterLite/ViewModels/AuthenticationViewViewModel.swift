//
//  AuthenticationViewViewModel.swift
//  TwitterLite
//
//  Created by Al-Amin on 6/12/22.
//

import Firebase
import Combine
import UIKit

final class AuthenticationViewViewModel: ObservableObject {
    
    @Published var fullName: String?
    @Published var username: String?
    @Published var email: String?
    @Published var password: String?
    @Published var isAuthenticationFormValid: Bool = false
    @Published var user: User?
    @Published var error: String?
    
    private var subscriptions: Set<AnyCancellable> = []
    
    func validateAuthenticationForm() {
        guard let email = email,
              let password = password else {
                  isAuthenticationFormValid = false
                  return
              }
        isAuthenticationFormValid = isValidEmail(email) && password.count >= 6
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}
