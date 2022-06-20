//
//  UserInfoView.swift
//  CombinePlay
//
//  Created by Niclas Jeppsson on 18/06/2022.
//

import SwiftUI

struct UserSignUpView: View {

    @ObservedObject var userSignUpViewModel: UserSignUpViewModel = UserSignUpViewModel()

    var body: some View {
        List {
            Section("Enter Your Details") {
                TextInputField(userInfo: $userSignUpViewModel.firstName, title: "First Name", errorMessage: userSignUpViewModel.nameErrorMessage)
                TextInputField(userInfo: $userSignUpViewModel.lastName, title: "Last Name", errorMessage: userSignUpViewModel.lastNameErrorMessage)
                TextInputField(userInfo: $userSignUpViewModel.userName, title: "User Name", errorMessage: userSignUpViewModel.userNameErrorMessage)
                TextInputField(userInfo: $userSignUpViewModel.emailAddress, title: "Email Address", errorMessage: userSignUpViewModel.emailAddressErrorMessage)
                    Button {
                        print("Submitted")
                    } label: {
                        Text("Submit")
                    }.disabled(userSignUpViewModel.submitForm)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}

struct TextInputField: View {

    @Binding var userInfo: String

    var title: String
    var errorMessage: String

    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                Text(title)
                    .modifier(FormModifier(formItem: userInfo))
                TextField("", text: $userInfo)
            }
            .modifier(AnimationModifier(formItem: userInfo))
            Text(errorMessage)
                .font(.footnote)
                .foregroundColor(.red)
                .modifier(AnimationModifier(formItem: errorMessage))
        }

    }
}

struct FormModifier: ViewModifier {

    var formItem: String

    func body(content: Content) -> some View {
        content
            .font(.callout)
            .foregroundColor(formItem.isEmpty ? .black : .blue)
            .offset(y: formItem.isEmpty ? 0 : -25)
            .scaleEffect(formItem.isEmpty ? 1 : 0.8, anchor: .leading)
    }
}

struct AnimationModifier: ViewModifier {

    var formItem: String

    func body(content: Content) -> some View {
        content
            .padding(.top, 15)
            .animation(.linear(duration: 0.15), value: formItem)
    }
}
