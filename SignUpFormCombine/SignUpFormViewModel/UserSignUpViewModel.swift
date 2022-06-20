//
//  LogInViewModel.swift
//  CombinePlay
//
//  Created by Niclas Jeppsson on 18/06/2022.
//

import Foundation
import Combine

class UserSignUpViewModel: ObservableObject {

    // Input
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var userName: String = ""
    @Published var emailAddress: String = ""

    // Output
    @Published var submitForm: Bool = true
    @Published var firstNameEligable: Bool = false
    @Published var lastNameEligable: Bool = false
    @Published var userNameEligable: Bool = false
    @Published var emailAddressEligable: Bool = false

    @Published var nameErrorMessage: String = ""
    @Published var lastNameErrorMessage: String = ""
    @Published var userNameErrorMessage: String = ""
    @Published var emailAddressErrorMessage: String = ""

    private lazy var signupFormEligable: AnyPublisher<Bool, Never> = {
        Publishers.CombineLatest4($firstNameEligable, $lastNameEligable, $userNameEligable, $emailAddressEligable)
            .allSatisfy {
                guard $0, $1, $2, $3 == true else { return true }
                return false
            }
            .eraseToAnyPublisher()
    }()

    private var cancellables = Set<AnyCancellable>()

    init() {
        subscribe()
    }

    private func subscribe() {

        $firstName
            .debounce(for: 1, scheduler: RunLoop.main)
            .map { name in
                guard !name.isEmpty else { return false }
                guard name.count > 1 else { self.nameErrorMessage = "1 charachter not allowed"; return false }
                self.nameErrorMessage = ""
                return true
            }
            .assign(to: &$firstNameEligable)

        $lastName
            .debounce(for: 1, scheduler: RunLoop.main)
            .map { lastName in
                guard !lastName.isEmpty else { return false }
                guard lastName.count > 1 else { self.lastNameErrorMessage = "1 charachter not allowed"; return false }
                self.lastNameErrorMessage = ""
                return true
            }
            .assign(to: &$lastNameEligable)

        $userName
            .debounce(for: 1, scheduler: RunLoop.main)
            .map { userName in
                guard !userName.isEmpty else { return false }
                guard userName.count > 1 else { self.userNameErrorMessage = "1 charachter not allowed"; return false }
                self.userNameErrorMessage = ""
                return true
            }
            .assign(to: &$userNameEligable)

        $emailAddress
            .debounce(for: 1, scheduler: RunLoop.main)
            .map { emailAddress in

                guard !emailAddress.isEmpty else { return false }
                guard emailAddress.count > 1 else { self.emailAddressErrorMessage = "1 charachter not allowed"; return false }
                guard emailAddress.contains("@") else { self.emailAddressErrorMessage = "Missing '@'"; return false }
                guard emailAddress.contains(".") else { self.emailAddressErrorMessage = "Missing '.'"; return false }
                self.emailAddressErrorMessage = ""

                return true
            }
            .assign(to: &$emailAddressEligable)

        signupFormEligable
            .assign(to: &$submitForm)

    }
}
