//
//  ScanView.swift
//  HK
//
//  Created by Peter Kresanič on 09/02/2024.
//

import SwiftUI
import CodeScanner
import AVFoundation

struct ScanView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var behaviours: Behaviours
    let notificationGen = UINotificationFeedbackGenerator()
    let impact = UIImpactFeedbackGenerator(style: .light)
    @State var manualInput = false
    @State var firstDone = false
    @State var errorMessage = ""
    
    init(isComingFromAdding: Bool = false) { _firstDone = State(wrappedValue: isComingFromAdding) }
    
    var body: some View {
        
        ZStack {
            
            CodeScannerView(codeTypes: [.qr], scanMode: .continuous, showViewfinder: true, shouldVibrateOnSuccess: false, completion: handleIncomingScan)
                .overlay(alignment: .center) {
                    HStack {
                        
                        Spacer()
                        
                        VStack(spacing: 0) {
                            
                            if firstDone {
                                
                                Button {
                                    dismiss()
                                } label: {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundStyle(.hkBlack)
                                        .frame(width: 40, height: 40)
                                        .background(Color.hkWhite)
                                        .clipShape(.circle)
                                        .frame(width: 75, height: 75, alignment: .center)
                                }
                                
                            }
                            
                            Button {
                                manualInput = true
                            } label: {
                                Image(systemName: "number")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundStyle(.hkBlack)
                                    .frame(width: 40, height: 40)
                                    .background(Color.hkWhite)
                                    .clipShape(.circle)
                                    .frame(width: 75, height: 75, alignment: .center)
                            }
                            
                        }
                    }
                }
                .overlay(alignment: .bottom)  {
                    if firstDone {
                        
                        ScrollView {
                            
                            VStack(spacing: 0) {
                                
                                ForEach(behaviours.itemIDsToBeRegistered.reversed()) { hkItemID in
                                    
                                    HStack {
                                        
                                        Text(hkItemID.id)
                                            .font(.system(size: 20, weight: .semibold))
                                            .foregroundStyle(.hkWhite)
                                        Spacer()
                                        
                                        Button {
                                            withAnimation {
                                                behaviours.itemIDsToBeRegistered.removeAll(where: { $0 == hkItemID })
                                            }
                                        } label: {
                                            Image(systemName: "xmark")
                                                .font(.system(size: 18, weight: .semibold))
                                                .foregroundStyle(.hkWhite)
                                        }
                                        
                                    }
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 5)
                                    .background(.hkPurple)
                                    .clipShape(.capsule)
                                    .padding(.horizontal, 60)
                                    .padding(.vertical, 5)
                                    .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .opacity.combined(with: .scale)))
                                    
                                }
                                
                            }.frame(maxWidth: .infinity)
                            
                        }.scrollIndicators(.hidden)
                            .frame(height: 200)
                        
                    }
                }
                .overlay(alignment: .top) {
                    if errorMessage != "" {
                        Text(errorMessage)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(.hkWhite)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 10)
                            .background(Color.hkBlack)
                            .clipShape(.capsule)
                            .transition(.move(edge: .top))
                            .padding(.top, 15)
                    }
                }
                        
        }
//        }.blur(radius: behaviours.isCheckingExistence ? 10 : 0)
            .sheet(isPresented: $manualInput) { SearchHKItemInputView(action: handleIncomingInput) }
            .ignoresSafeArea()
        
    }
    
    
    func handleIncomingInput(inputCode: String) {
        
        withAnimation { manualInput = false }
        let itemID = HKItemID(numberID: inputCode)
        let stringURL = "hydrokresItem://find-item?HKItemID=\(itemID.id)"
        Task {
            if !firstDone {
               await firstScan(stringURL)
            } else {
               await remainingScans(stringURL)
            }
        }
        
    }
    
    func handleIncomingScan(result: Result<ScanResult, ScanError>) {
        switch result {
        case .success(let data):
            Task {
                if !firstDone {
                   await firstScan(data.string)
                } else {
                   await remainingScans(data.string)
                }
            }
        case .failure(_):
            print("Could not scan successfully.")
        }
    }
    
    @MainActor private func firstScan(_ data: String) async {
        
        if let url = URL(string: data) {
            let hkItemID = HKItemID(deepLink: url)
            let hkItem = await behaviours.checkForExistence(of: hkItemID)
            if let hkItem {
//                notificationGen.notificationOccurred(.success)
                impact.impactOccurred()
                behaviours.previewedHKItem = hkItem
                dismiss()
            } else {
                withAnimation {
                    firstDone = true
                    if !behaviours.itemIDsToBeRegistered.contains(where: { $0 == hkItemID }) {
                        behaviours.itemIDsToBeRegistered.append(hkItemID)
//                        notificationGen.notificationOccurred(.success)
                        impact.impactOccurred()
                    } else {
                        manageErrorMessage("Kód už je naskenovaný.")
                    }
                }
            }
        }
        
    }
    
    @MainActor private func remainingScans(_ data: String) async {
        if let url = URL(string: data) {
            let hkItemID = HKItemID(deepLink: url)
            let hkItem = await behaviours.checkForExistence(of: hkItemID)
            if hkItem != nil {
                manageErrorMessage("Kód už je priradený k produktu.")
            } else {
                withAnimation {
                    if !behaviours.itemIDsToBeRegistered.contains(where: { $0 == hkItemID }) {
                        behaviours.itemIDsToBeRegistered.append(hkItemID)
//                        notificationGen.notificationOccurred(.success)
                        impact.impactOccurred()
                    } else {
                        manageErrorMessage("Kód už je naskenovaný.")
                    }
                }
            }
            
        }
        
    }
    
    @MainActor private func manageErrorMessage(_ message: String) {
        
        withAnimation(.bouncy) { errorMessage = message}
        notificationGen.notificationOccurred(.error)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            withAnimation(.bouncy) { errorMessage = "" }
        }
        
        
    }
    
    
//    
//    @MainActor private func continuousScan(_ data: String) async {
//        
//        if let url = URL(string: data) {
//            let hkItemID = HKItemID(deepLink: url)
//            if await behaviours.checkForExistence(of: hkItemID) {
//                impactMed.impactOccurred()
//                impactMed.impactOccurred()
//                impactMed.impactOccurred()
//            } else {
//                withAnimation {
//                    if !behaviours.itemIDsToBeRegistered.contains(where: { $0 == hkItemID }) {
//                        behaviours.itemIDsToBeRegistered.append(hkItemID)
//                    }
//                }
//                impactMed.impactOccurred()
//            }
//        }
//        
//        
//    }
//    
//    @MainActor private func singularScan(_ data: String) async {
//        
//        if let url = URL(string: data) {
//            let hkItemID = HKItemID(deepLink: url)
//            if await behaviours.checkForExistence(of: hkItemID) {
//                impactMed.impactOccurred()
//                await behaviours.hideScanningAndOpenItem(of: hkItemID)
//            } else {
//                impactMed.impactOccurred()
//                behaviours.hideScanningAndOpenAdditionOfNewItems(of: hkItemID)
//            }
//        }
//        
//    }
//    
    
}
