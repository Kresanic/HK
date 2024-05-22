//
//  NewItemsSheet.swift
//  HK
//
//  Created by Peter Kresanič on 23/12/2023.
//

import SwiftUI
import CodeScanner

struct NewItemsSheet: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var behaviours: Behaviours
    @StateObject var viewModel = NewItemsViewModel()
    
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 15) {
                
                HStack {
                    
                    Text("Nové produkty")
                        .font(.screenTitle)
                        .foregroundStyle(.hkBlack)
                    
                    Spacer()
                    
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 24, weight: .regular))
                            .foregroundStyle(.hkBlack)
                    }
                    
                }
                
                HStack {
                 
                    Image(systemName: "shippingbox")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.hkBlack)
                    
                    Text("Typ produktu")
                        .font(.system(size: 23, weight: .semibold))
                        .foregroundStyle(.hkBlack)
                    
                    Spacer()
                    
                    if viewModel.selectedType != nil {
                        Button {
                            withAnimation {
                                viewModel.selectedType = nil
                                viewModel.isSelectingType = true
                            }
                        } label: {
                            Image(systemName: "arrow.circlepath")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.hkBlack)
                        }
                    }
                    
                }
                
                if let selectedType = viewModel.selectedType {
                    DetailedProductView(item: selectedType)
                } else {
                    Button {
                        viewModel.isSelectingType = true
                    } label: {
                        HStack {
                            
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Vyber typ produktu")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundStyle(.hkBlack)
                                
                                Text("Vybraný typ produktu sa aplikuje na všetky vybrané kódy")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundStyle(.hkBlack)
                                    .multilineTextAlignment(.leading)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "plus")
                                .font(.system(size: 26))
                                .foregroundStyle(.hkBlack)
                            
                        }.frame(maxWidth: .infinity)
                            .padding(15)
                            .background(.hkGray)
                            .clipShape(.rect(cornerRadius: 20, style: .continuous))
                    }
                }
                
                if !behaviours.itemIDsToBeRegistered.isEmpty {
                    
                    HStack {
                     
                        Image(systemName: "qrcode")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.hkBlack)
                        
                        Text("Načítané kódy")
                            .font(.system(size: 23, weight: .semibold))
                            .foregroundStyle(.hkBlack)
                        
                        Spacer()
                        
                    }
                        
                    
                    VStack {
                        
                        ForEach(behaviours.itemIDsToBeRegistered) { hkItemId in
                            
                                HStack {
                                    
                                    Text(hkItemId.id)
                                        .font(.system(size: 19, weight: .semibold))
                                        .foregroundStyle(Color.hkWhite)
                                    
                                    Spacer()
                                    
                                    Button {
                                        withAnimation { behaviours.itemIDsToBeRegistered.removeAll(where: { $0 == hkItemId }) }
                                    } label: {
                                        Image(systemName: "trash")
                                            .font(.system(size: 18, weight: .medium))
                                            .foregroundStyle(Color.hkWhite)
                                    }
                                    
                                }.padding(.horizontal, 15)
                                    .padding(.vertical, 5)
                                    .background(.hkPurple)
                                    .clipShape(.capsule)
                                    .padding(.vertical, 5)
                                    .padding(.horizontal, 15)
                                    .transition(.opacity.combined(with: .scale))
                            
                        }
                        
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(.hkGray)
                        .clipShape(.rect(cornerRadius: 30, style: .continuous))
                }
                
            }.padding(.horizontal, 15)
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }.scrollIndicators(.hidden)
            .presentationBackground(.hkWhite)
            .overlay(alignment: .bottom) {
                
                VStack {
                    Button { viewModel.isScanningQRCode = true } label: {
                        PrimaryButton(title: "Naskenovať produkty", buttonRole: .option)
                    }
                    
                    Button {
                        Task {
                            do {
                                try await viewModel.saveAllCodes(itemIDs: behaviours.itemIDsToBeRegistered)
                                dismiss()
                            } catch {
                                print(error)
                            }
                        }
                    } label: {
                        PrimaryButton(title: "Uložiť nové produkty", buttonRole: .confirmation)
                    }
                    .disabled(behaviours.itemIDsToBeRegistered.isEmpty)
                }.frame(maxWidth: .infinity)
            }
            .onAppear {
                if behaviours.itemIDsToBeRegistered.isEmpty {
                    viewModel.isScanningQRCode = true
                }
            }
            .sheet(isPresented: $viewModel.isScanningQRCode) {
                ScanView(isComingFromAdding: true)
            }
            .sheet(isPresented: $viewModel.isSelectingType) {
                SelectingItemCatalogue(selectedHKItem: $viewModel.selectedType)
            }
        
    }
    
}


fileprivate struct DetailedProductView: View {
    
    var item: HKCatalogueItem
    @State var isShowingDetailed = false
    
    var body: some View {
        
        VStack(spacing: 0) {
                
                HStack {
                    
                    if let image = item.firstPhoto {
                        
                        let size = CGFloat( isShowingDetailed ? 70 : 55)
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: size, height: size)
                            .clipShape(.rect(cornerRadius: isShowingDetailed ? 15: 12, style: .continuous))
                    }
                    
                    Text(item.type ?? "nebavi")
                        .font(.system(size: isShowingDetailed ? 24 : 20, weight: .semibold))
                        .foregroundStyle(.hkBlack)
                    
                    
                    Spacer()
                    
                Button {
                    withAnimation(.bouncy) { isShowingDetailed.toggle() }
                } label: {
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 25))
                        .foregroundStyle(.hkBlack)
                        .rotationEffect(.degrees(isShowingDetailed ? 90 : 0))
                        .frame(width: 100, height: 40, alignment: .trailing)
                    
                }
            }
            
            if isShowingDetailed {
                
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .foregroundStyle(.hkWhite)
                    .frame(height: 1)
                    .padding(.vertical, 10)
                
                DetailedItemBubble(details: [
                    .init(key: "Nosnosť", value: item.capacity ?? 0),
                    .init(key: "Cena", value: (item.price ?? 0.0).formatted(.currency(code: "EUR"))),
                    .init(key: "Dĺžka", value: item.length ?? 0),
                    .init(key: "Šírka", value: item.width ?? 0)
                ])
                
            }
            
            
        }.frame(maxWidth: .infinity)
            .padding(.horizontal, 15)
            .padding(.vertical, isShowingDetailed ? 15 : 10)
            .background(.hkGray)
            .clipShape(.rect(cornerRadius: 20, style: .continuous))
            .onTapGesture {
                withAnimation(.bouncy) { isShowingDetailed.toggle() }
            }
            .transition(.scale.combined(with: .opacity))
        
    }
    
}

fileprivate struct DetailedItemBubble: View {
    
    var details: [DetailPair]
    
    var body: some View {
        
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 10) {
            ForEach(details) { detail in
                VStack(alignment: .leading, spacing: 0) {
                    Text(detail.key)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.hkBlack)
                        .lineLimit(1)
                    
                    Text(detail.value)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.hkBlack)
                        .lineLimit(1)
                }.frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        
    }
    
}
