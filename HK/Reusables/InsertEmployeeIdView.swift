//
//  InsertPersonCodeView.swift
//  HK
//
//  Created by Peter Kresanič on 17/12/2023.
//

import SwiftUI
import CloudKit

struct InsertEmployeeIdView: View {
    
    @State var inputedCode = ""
    @Environment(\.dismiss) var dismiss
    @AppStorage("employeeID") var employeeID: String = ""
    @EnvironmentObject var behaviours: Behaviours
    @FocusState var focusedTextField: Bool
    @State var employeeError: EmployeeErrors?
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            Image(.hydrokresLogo)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            
            Spacer()
            
            Text("Zadajte identifikačný kód")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.hkBlack)
            
            TextField("123 456 789", text: $inputedCode)
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(.hkBlack)
                .focused($focusedTextField)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .padding(.vertical, 15)
                .background(Color.hkWhite)
                .clipShape(.rect(cornerRadius: 20, style: .continuous))
                .shadow(color: .hkBlack.opacity(0.15), radius: 5)
                .padding(.horizontal, 15)
                .task { focusedTextField = true }
            
            if let employeeError {
                Text(employeeError.message)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.red.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 15)
            }
                
            Button {
                getUser()
            } label: {
                PrimaryButton(title: "Overiť!", isLoading: behaviours.isGettingEmployee).padding(.top, 15)
            }
            
            Spacer()
            
        }.padding(.horizontal, 15)
            .background { Color.hkWhite.onTapGesture { dismissKeyboard() } }
            .zIndex(5)
        
    }
    
    private func showAlertMessage(of message: EmployeeErrors) {
        withAnimation(.bouncy) {
            employeeError = message
        }
    }
    
    private func getUser() {
        if let code = Int(inputedCode), code % 11 == 0, inputedCode.count == 9 {
            Task {
                behaviours.toggleIsGettingEmployee(to: true)
                do {
                    let hkUser = try await CloudKitManager.shared.getUser(employeeID: inputedCode)
                    behaviours.saveNewEmployee(employee: hkUser)
                } catch {
                    if let emplErr = error as? EmployeeErrors {
                        showAlertMessage(of: emplErr)
                    } else {
                        showAlertMessage(of: .somethingWentWrong(0))
                        print(error.localizedDescription)
                    }
                    behaviours.toggleIsGettingEmployee(to: false)
                }
            }
        } else {
            showAlertMessage(of: EmployeeErrors.invalidCode)
        }
    }
    
}

#Preview {
    InsertEmployeeIdView()
}
