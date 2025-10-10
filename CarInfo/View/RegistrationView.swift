//
//  RegistrationView.swift
//  CarInfo
//
//  Created by window1 on 10/6/25.
//

import SwiftUI

struct RegistrationView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AuthViewModel.self) private var authVM
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmedPassward = ""
    @State private var passwordsMatch = false
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .font(.system(size: 220, weight: .light))
                .foregroundStyle(Color.green.gradient)

            Group {
                TextField(text: $email, label: {
                    Text("이메일")
                        .foregroundStyle(Color.primary)
                })
                ZStack(alignment:.trailing) {
                    SecureField(text: $password, label: {
                        Text("비밀번호")
                            .foregroundStyle(Color.primary)
                    })
                    if !password.isEmpty && !confirmedPassward.isEmpty {
                        Image(systemName:  passwordsMatch ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundStyle(passwordsMatch ? .green : .red)
                            .padding(.horizontal)
                    }
                }
                ZStack(alignment:.trailing) {
                    SecureField(text: $confirmedPassward, label: {
                        Text("비밀확인")
                            .foregroundStyle(Color.primary)
                    })
                    if !password.isEmpty && !confirmedPassward.isEmpty {
                        Image(systemName:  passwordsMatch ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundStyle(passwordsMatch ? .green : .red)
                            .padding(.horizontal)
                    }
                }
                .onChange(of: confirmedPassward) { old, new in
                    passwordsMatch = (new == password)
                }
            }
            .padding(15)
            .background(Color.gray.secondary)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            
            Button{
                Task {
                    await authVM.signUp(email: email, password: password)
                }
            } label: {
                Text("회원가입")
                    .padding(15)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1.0 : 0.5)
            
            Spacer()
            
            Divider()
            
            
            HStack {
                Text("이미 계정이 있습니까?")
                    .font(.system(size: 17, weight: .light))
                    .foregroundStyle(Color.blue)
                Button {
                    dismiss()
                } label: {
                    Text("로그인하기")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(Color.blue)
                }
            }
            .padding()
        }
        .padding(10)
    }
}

private extension RegistrationView {
    var formIsValid: Bool {
        return email.isVaildEmail() && passwordsMatch
    }
}

#Preview {
    RegistrationView()
        .environment(AuthViewModel())
}
