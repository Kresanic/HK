////
////  ConenctClientToProductsView.swift
////  HK
////
////  Created by Peter Kresanič on 09/02/2024.
////
//
//import SwiftUI
//
//struct ConnectClientToProductsView: View {
//    
//    @Environment(\.dismiss) var dismiss
//    @EnvironmentObject var behaviours: Behaviours
//    
//    var body: some View {
//        
//        ScrollView {
//            
//            VStack(spacing: 15) {
//                
//                HStack {
//                    
//                    Text("Priradiť produkty")
//                        .font(.screenTitle)
//                        .foregroundStyle(.hkBlack)
//                    
//                    Spacer()
//                    
//                    Button { dismiss() } label: {
//                        Image(systemName: "xmark")
//                            .font(.system(size: 24, weight: .regular))
//                            .foregroundStyle(.hkBlack)
//                    }
//                    
//                }
//                
//                HStack {
//                 
//                    Image(systemName: "shippingbox")
//                        .font(.system(size: 20, weight: .semibold))
//                        .foregroundStyle(.hkBlack)
//                    
//                    Text("Klient")
//                        .font(.system(size: 23, weight: .semibold))
//                        .foregroundStyle(.hkBlack)
//                    
//                    Spacer()
//                    
//                    if viewModel.selectedType != nil {
//                        Button {
//                            withAnimation {
//                                viewModel.selectedType = nil
//                                viewModel.isSelectingType = true
//                            }
//                        } label: {
//                            Image(systemName: "arrow.circlepath")
//                                .font(.system(size: 16, weight: .medium))
//                                .foregroundStyle(.hkBlack)
//                        }
//                    }
//                    
//                }
//                
//                if let selectedType = viewModel.selectedType {
//                    DetailedProductView(item: selectedType)
//                } else {
//                    Button {
//                        viewModel.isSelectingType = true
//                    } label: {
//                        HStack {
//                            
//                            VStack(alignment: .leading, spacing: 0) {
//                                Text("Vyber typ produktu")
//                                    .font(.system(size: 20, weight: .medium))
//                                    .foregroundStyle(.hkBlack)
//                                
//                                Text("Vybraný typ produktu sa aplikuje na všetky vybrané kódy")
//                                    .font(.system(size: 11, weight: .medium))
//                                    .foregroundStyle(.hkBlack)
//                                    .multilineTextAlignment(.leading)
//                            }
//                            
//                            Spacer()
//                            
//                            Image(systemName: "plus")
//                                .font(.system(size: 26))
//                                .foregroundStyle(.hkBlack)
//                            
//                        }.frame(maxWidth: .infinity)
//                            .padding(15)
//                            .background(.hkGray)
//                            .clipShape(.rect(cornerRadius: 20, style: .continuous))
//                    }
//                }
//                
//                if !behaviours.itemIDsToBeRegistered.isEmpty {
//                    
//                    HStack {
//                     
//                        Image(systemName: "qrcode")
//                            .font(.system(size: 20, weight: .semibold))
//                            .foregroundStyle(.hkBlack)
//                        
//                        Text("Načítané kódy")
//                            .font(.system(size: 23, weight: .semibold))
//                            .foregroundStyle(.hkBlack)
//                        
//                        Spacer()
//                        
//                    }
//                        
//                    
//                    VStack {
//                        
//                        ForEach(behaviours.itemIDsToBeRegistered) { hkItemId in
//                            
//                                HStack {
//                                    
//                                    Text(hkItemId.id)
//                                        .font(.system(size: 19, weight: .semibold))
//                                        .foregroundStyle(Color.hkWhite)
//                                    
//                                    Spacer()
//                                    
//                                    Button {
//                                        withAnimation { behaviours.itemIDsToBeRegistered.removeAll(where: { $0 == hkItemId }) }
//                                    } label: {
//                                        Image(systemName: "trash")
//                                            .font(.system(size: 18, weight: .medium))
//                                            .foregroundStyle(Color.hkWhite)
//                                    }
//                                    
//                                }.padding(.horizontal, 15)
//                                    .padding(.vertical, 5)
//                                    .background(.hkPurple)
//                                    .clipShape(.capsule)
//                                    .padding(.vertical, 5)
//                                    .padding(.horizontal, 15)
//                                    .transition(.opacity.combined(with: .scale))
//                            
//                        }
//                        
//                    }.frame(maxWidth: .infinity)
//                        .padding(.vertical, 10)
//                        .background(.hkGray)
//                        .clipShape(.rect(cornerRadius: 30, style: .continuous))
//                }
//                
//            }.padding(.horizontal, 15)
//            .frame(maxWidth: .infinity, alignment: .leading)
//            
//        }.scrollIndicators(.hidden)
//            .presentationBackground(.hkWhite)
//            .overlay(alignment: .bottom) {
//                
//                VStack {
//                    Button { viewModel.isScanningQRCode = true } label: {
//                        PrimaryButton(title: "Naskenovať produkty", buttonRole: .option)
//                    }
//                    
//                    Button {
//                        Task {
//                            do {
//                                try await viewModel.saveAllCodes(itemIDs: behaviours.itemIDsToBeRegistered)
//                                dismiss()
//                            } catch {
//                                print(error)
//                            }
//                        }
//                    } label: {
//                        PrimaryButton(title: "Uložiť nové produkty", buttonRole: .confirmation)
//                    }
//                    .disabled(behaviours.itemIDsToBeRegistered.isEmpty)
//                }.frame(maxWidth: .infinity)
//            }
//            .onAppear {
//                if behaviours.itemIDsToBeRegistered.isEmpty {
//                    viewModel.isScanningQRCode = true
//                }
//            }
//            .sheet(isPresented: $viewModel.isScanningQRCode) {
//                ScanView(isComingFromAdding: true)
//            }
//            .sheet(isPresented: $viewModel.isSelectingType) {
//                SelectingItemCatalogue(selectedHKItem: $viewModel.selectedType)
//            }
//        
//    }
//    
//}
