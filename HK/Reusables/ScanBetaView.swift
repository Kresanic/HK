////
////  ScanView.swift
////  HK
////
////  Created by Peter Kresanič on 03/02/2024.
////
//
//import SwiftUI
//import CodeScanner
//
//
//struct ScanBetaView: View {
//    
//    @Environment(\.dismiss) var dismiss
//    @EnvironmentObject var behaviours: Behaviours
//    @State var manualInput = false
//    let impactMed = UIImpactFeedbackGenerator(style: .heavy)
//    
//    var body: some View {
//        
//        ZStack(alignment: .bottom) {
//            
//            CodeScannerView(codeTypes: [.qr], scanMode: scanning.scanMode, showViewfinder: true, completion: handleIncomingScan)
//                .overlay(alignment: .center) {
//                    HStack {
//                        
//                        Spacer()
//                        
//                        VStack(spacing: 0) {
//                            
//                            if scanning.scanMode != .once {
//                                
//                                Button {
//                                    dismiss()
//                                } label: {
//                                    Image(systemName: "checkmark")
//                                        .font(.system(size: 20, weight: .medium))
//                                        .foregroundStyle(.hkBlack)
//                                        .frame(width: 40, height: 40)
//                                        .background(Color.hkWhite)
//                                        .clipShape(.circle)
//                                        .frame(width: 75, height: 75, alignment: .center)
//                                }
//                                
//                            }
//                            
//                            Button {
//                                manualInput = true
//                            } label: {
//                                Image(systemName: "number")
//                                    .font(.system(size: 20, weight: .medium))
//                                    .foregroundStyle(.hkBlack)
//                                    .frame(width: 40, height: 40)
//                                    .background(Color.hkWhite)
//                                    .clipShape(.circle)
//                                    .frame(width: 75, height: 75, alignment: .center)
//                            }
//                            
//                        }//.padding(.trailing, 10)
//                    }
//                }
//            
//            if scanning.scanMode != .once {
//                ScrollView {
//                    
//                    VStack(spacing: 0) {
//                        
//                        ForEach(scanning.itemsToRegister.reversed()) { hkItemID in
//                            
//                            HStack {
//                                
//                                Text(hkItemID.id)
//                                    .font(.system(size: 20, weight: .semibold))
//                                    .foregroundStyle(.hkWhite)
//                                Spacer()
//                                
//                                Button {
//                                    withAnimation {
//                                        scanning.itemsToRegister.removeAll(where: { $0 == hkItemID })
//                                    }
//                                } label: {
//                                    Image(systemName: "xmark")
//                                        .font(.system(size: 18, weight: .semibold))
//                                        .foregroundStyle(.hkWhite)
//                                }
//                                
//                            }
//                            .padding(.horizontal, 15)
//                            .padding(.vertical, 5)
//                            .background(.hkPurple)
//                            .clipShape(.capsule)
//                            .padding(.horizontal, 60)
//                            .padding(.vertical, 5)
//                            .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .opacity.combined(with: .scale)))
//                            
//                        }
//                        
//                    }.frame(maxWidth: .infinity)
//                    
//                }.scrollIndicators(.hidden)
//                    .frame(height: 200)
//            }
//            
//        }.ignoresSafeArea()
//            .interactiveDismissDisabled(scanning.scanMode == .once ? false : true)
//            .presentationCornerRadius(30)
//            .onDisappear { withAnimation { scanning.itemsToRegister.sort { $0.id < $1.id } } }
//        
//    }
//    
//    func handleIncomingScan(result: Result<ScanResult, ScanError>) {
//        switch result {
//        case .success(let data):
//            Task {
//                if scanning.scanMode == .once {
//                    await singularScan(data.string)
//                } else {
//                    await continuousScan(data.string)
//                }
//            }
//        case .failure(_):
//            print("Could not scan successfully.")
//        }
//    }
//    
//    @MainActor private func continuousScan(_ data: String) {
//        
//        if let url = URL(string: data) {
//            let hkItemID = HKItemID(deepLink: url)
//            withAnimation {
//                if !scanning.itemsToRegister.contains(where: { $0 == hkItemID }) {
//                    scanning.itemsToRegister.append(hkItemID)
//                }
//            }
//        }
//        
//        impactMed.impactOccurred()
//    }
//    
//    @MainActor private func singularScan(_ data: String) {
//        
//        if let url = URL(string: data) {
//            let hkItemID = HKItemID(deepLink: url)
//            withAnimation {
//                scanning.itemsToRegister = [hkItemID]
//            }
//        }
//        
//        impactMed.impactOccurred()
//        
//        dismiss()
//        
//    }
//
//}
//
//@MainActor final class ScanViewModel: ObservableObject {
//    
//    func continuousScan(_ data: String) {
//        print("yolo")
//    }
//    
//    func onceScan(_ data: String) {
//        print("nolo")
//    }
//    
//}
