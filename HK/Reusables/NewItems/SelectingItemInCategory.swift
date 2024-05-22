//
//  SelectingItemInCategory.swift
//  HK
//
//  Created by Peter Kresanič on 09/02/2024.
//

import SwiftUI

struct SelectingItemInCategory: View {
    
    var category: HKCatalogueCategory
    @State var productsInCategory: [HKCatalogueItem] = []
    @Binding var selectedHKItem: HKCatalogueItem?
    
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 5) {
                
                HStack {
                    
                    Text("Produkty")
                        .font(.screenTitle)
                        .foregroundStyle(.hkBlack)
                    
                    Spacer()
                    
                }
                
                if productsInCategory.isEmpty {
                    Text("Načítava sa..")
                } else {
                    ForEach(productsInCategory) { product in
                        DetailedProductView(item: product, selectedHKItem: $selectedHKItem)
                    }
                }
                
            }.padding(.horizontal, 15)
                .frame(maxWidth: .infinity)
        }
        .task {
            do {
                let products = try await CloudKitManager.shared.getHKItems(in: category)
                withAnimation {
                    productsInCategory = products
                }
            } catch { print(error.localizedDescription) }
        }
        
    }
    
}

fileprivate struct DetailedProductView: View {
    
    var item: HKCatalogueItem
    @Binding var selectedHKItem: HKCatalogueItem?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        Button {
            withAnimation(.bouncy) {
                selectedHKItem = item
            }
        } label: {
            
            HStack {
                
                if let image = item.firstPhoto {
                    
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 55, height: 55)
                        .clipShape(.rect(cornerRadius: 12, style: .continuous))
                }
                
                Text(item.type ?? "nebavi")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.hkBlack)
                
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 25))
                    .foregroundStyle(.hkBlack)
                    .rotationEffect(.degrees(0))
                    .frame(width: 100, height: 40, alignment: .trailing)
                
            }
            
            //            if isShowingDetailed {
            //
            //                RoundedRectangle(cornerRadius: 4, style: .continuous)
            //                    .foregroundStyle(.hkWhite)
            //                    .frame(height: 1)
            //                    .padding(.vertical, 10)
            //
            //                DetailedItemBubble(details: [
            //                    .init(key: "Nosnosť", value: item.capacity ?? 0),
            //                    .init(key: "Cena", value: (item.price ?? 0.0).formatted(.currency(code: "EUR"))),
            //                    .init(key: "Dĺžka", value: item.length ?? 0),
            //                    .init(key: "Šírka", value: item.width ?? 0)
            //                ])
            //
            //            }
            
            
        }.frame(maxWidth: .infinity)
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(.hkGray)
            .clipShape(.rect(cornerRadius: 20, style: .continuous))
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
