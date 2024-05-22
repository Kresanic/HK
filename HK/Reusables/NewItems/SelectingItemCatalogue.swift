//
//  SelectingItemCatalogue.swift
//  HK
//
//  Created by Peter Kresanič on 09/02/2024.
//

import SwiftUI

struct SelectingItemCatalogue: View {
    
    @EnvironmentObject var behaviours: Behaviours
    @Binding var selectedHKItem: HKCatalogueItem?
    
    var body: some View {
        
        NavigationStack(path: $behaviours.catalogueNavigation) {
            
            ScrollView {
                
                VStack(spacing: 8) {
                    
                    ForEach(behaviours.catalogueCategories) { category in
                        
                        Button {
                            behaviours.catalogueNavigation.append(category)
                        } label: {
                            HStack {
                                
                                if let image = category.photo {
                                    
                                    Image(uiImage: image)
                                        .resizable()
                                        .frame(width: 55, height: 55)
                                        .clipShape(.rect(cornerRadius: 10, style: .continuous))
                                    
                                }
                                
                                Text(category.name ?? "nebavi")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(.hkBlack)
                                
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 25))
                                    .foregroundStyle(.hkBlack)
                                
                            }
                            .padding(.trailing, 15)
                            .padding(.leading, 10)
                            .padding(.vertical, 10)
                            .background(.hkGray)
                            .clipShape(.rect(cornerRadius: 20, style: .continuous))
                        }
                    }
                    
                }.headingAndTabPadding(isInNavigation: true)
                    .task {
                        if behaviours.catalogueCategories.isEmpty {
                            await behaviours.loadHKCategories()
                        }
                    }
                
            }.scrollIndicators(.hidden)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(.hidden, for: .navigationBar)
                .padding(.horizontal, 15)
                .screenHeading(tabView: .catalogue, isInNavigation: true)
                .navigationDestination(for: HKCatalogueCategory.self) { category in
                    SelectingItemInCategory(category: category, selectedHKItem: $selectedHKItem)
                }
            
        }
        
    }
    
}

