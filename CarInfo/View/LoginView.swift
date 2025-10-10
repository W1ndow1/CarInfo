//
//  LoginView.swift
//  CarInfo
//
//  Created by window1 on 10/6/25.
//

import SwiftUI

struct LoginView: View {
    @Environment(AuthViewModel.self) private var authVM
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "globe")
                    .font(.system(size: 220, weight: .light))
                    .foregroundStyle(Color.green.gradient)
                
                
                Group {
                    TextField(text: $email, label: {
                        Text("이메일")
                            .foregroundStyle(Color.primary)
                    })
                    
                    SecureField(text: $password, label: {
                        Text("비밀번호")
                            .foregroundStyle(Color.primary)
                    })
                }
                .padding(15)
                .background(Color.gray.secondary)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                
                Button{
                    Task {
                        await authVM.signIn(email: email, password: password)
                    }
                } label: {
                    Text("로그인")
                        .padding(15)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                .disabled(!formIsValidEmail)
                .opacity(formIsValidEmail ? 1.0 : 0.5)
                
                Spacer()
                
                Divider()
                
                HStack  {
                    Text("계정이 없으십니까?")
                        .font(.system(size: 17, weight: .light))
                        .foregroundStyle(Color.blue)
                    NavigationLink {
                        RegistrationView()
                            .navigationBarBackButtonHidden()
                    } label: {
                        Text("가입하기")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(Color.blue)
                    }
                }
                .padding()
            }
            .padding(10)
        }
    }
}


private extension LoginView {
    var formIsValidEmail: Bool {
        return email.isVaildEmail() && !password.isEmpty
    }
}

extension String {
    func isVaildEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return range(of: emailRegex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

#Preview {
    let vm = AuthViewModel()
    Task {
        await vm.signIn(email: "doserack@gmail.com", password: "1234567a")
    }
    return LoginView()
        .environment(vm)
}
