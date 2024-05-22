//
//  ProductsInCategoryView.swift
//  HK
//
//  Created by Peter Kresanič on 03/02/2024.
//

import SwiftUI

struct ProductsInCategoryView: View {
    
    var category: HKCatalogueCategory
    @State var productsInCategory: [HKCatalogueItem] = []
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
                        DetailedProductView(item: product)
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
                    .init(key: "Nosnosť", value: "\(item.capacity ?? 0)kg"),
                    .init(key: "Cena", value: (item.price ?? 0.0).formatted(.currency(code: "EUR"))),
                    .init(key: "Dĺžka", value: "\(item.length ?? 0)mm"),
                    .init(key: "Šírka", value: "\(item.width ?? 0)mm")
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
