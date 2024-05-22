//
//  ClientDetailView.swift
//  HK
//
//  Created by Peter Kresanič on 09/02/2024.
//

import SwiftUI

struct ClientDetailView: View {
    
    var client: HKClient
    @State var associatedProductsToClient: [HKItem] = []
    
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 5) {
                
                HStack {
                    
                    Text(client.name ?? "Nebavi")
                        .font(.screenTitle)
                        .foregroundStyle(.hkBlack)
                    
                    Spacer()
                    
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    VStack(alignment: .leading, spacing: 1) {
                        
                        Text("IČO")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.hkBlack)
                        
                        Text(client.businessID ?? "0342592")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.hkBlack)
                        
                    }
                    
                    VStack(alignment: .leading, spacing: 1) {
                        
                        Text("Email")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.hkBlack)
                        
                        Text(client.email ?? "test@test.sk")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.hkBlack)
                        
                    }
                    
                }.frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text("Kúpené produkty")
                        .font(.system(size: 25, weight: .semibold))
                        .foregroundStyle(.hkBlack)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 15)
                    
                    ForEach(associatedProductsToClient) { product in
                        
                        DetailedProductView(item: product)
                        
                    }
                    
                }
                
            }.padding(.horizontal, 15)
            .frame(maxWidth: .infinity)
            
        }
        .task {
            do {
                let items = try await CloudKitManager.shared.getItemsAssociatedToClient(client)
                withAnimation { associatedProductsToClient = items }
            } catch {
                print(error)
            }
        }
        
    }
    
}

fileprivate struct DetailedProductView: View {
    
    var item: HKItem
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        HStack {
            
            if let image = item.firstPhoto {
                
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 55, height: 55)
                    .clipShape(.rect(cornerRadius: 12, style: .continuous))
            }
            
            VStack(alignment: .leading, spacing: 1) {
                
                Text(item.type ?? "nebavi")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.hkBlack)
                
                Text(item.id ?? "HK00000")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(.hkBlack)
                
            }
            
            Spacer()
//            
//            Image(systemName: "chevron.right")
//                .font(.system(size: 25))
//                .foregroundStyle(.hkBlack)
//                .rotationEffect(.degrees(0))
//                .frame(width: 100, height: 40, alignment: .trailing)
             
            
        }.frame(maxWidth: .infinity)
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(.hkGray)
            .clipShape(.rect(cornerRadius: 20, style: .continuous))
            .transition(.scale.combined(with: .opacity))
        
    }
    
}
