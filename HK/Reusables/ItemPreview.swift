//
//  ItemPreview.swift
//  HK
//
//  Created by Peter Kresanič on 22/12/2023.
//

import SwiftUI

struct ItemPreview: View {
    
    var item: String
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
    
        ScrollView {
            
            Image(.placeholderPalette)
                .resizable()
                .scaledToFit()
                .frame(height: 350)
                .frame(maxWidth: .infinity)
                .overlay(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        
                        Spacer()
                        
                        Text("#\(item)")
                            .font(.system(size: 35, weight: .bold))
                            .foregroundStyle(.hkBlack)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 15)
                        
                    }.frame(height: 300)
                    .background { LinearGradient(gradient: Gradient(colors: [.hkWhite.opacity(0.0), .hkWhite.opacity(0.3), .hkWhite]), startPoint: .top, endPoint: .bottom) }
                }
            
            VStack(spacing: 14) {
                
                VStack(spacing: 2) {
                    
                    SectionHeading(title: "Detaily", sfSymbol: "list.bullet.clipboard.fill")
                    
                    DetailedBubble(details: [
                        .init(key: "Typ", value: "AC 25/1150"),
                        .init(key: "Záruka", value: "Platná"),
                        .init(key: "Predné kolesá", value: "Guma"),
                        .init(key: "Zadné kolesá", value: "Polyuretán")
                    ])
                    
                }
                
                VStack(spacing: 2) {
                    
                    SectionHeading(title: "Klient", sfSymbol: "person.fill")
                    
                    DetailedBubble(details: [
                        .init(key: "Meno", value: "Janko Rusnák"),
                        .init(key: "IČO", value: "12345679"),
                        .init(key: "Telefón", value: "+421904056655"),
                        .init(key: "Stav", value: "Vpohode")
                    ])
                    
                }
                
                VStack(spacing: 2) {
                    
                    SectionHeading(title: "História", sfSymbol: "point.filled.topleft.down.curvedto.point.bottomright.up")
                    
                    HStack {
                        Spacer()
                        Text("Čoskoro...")
                            .padding(.vertical, 50)
                        Spacer()
                    }.background(.hkGray)
                        .clipShape(.rect(cornerRadius: 25, style: .continuous))
                    
                }
                
            }
            .padding(.horizontal, 15)
                .frame(maxWidth: .infinity)
            
        }.scrollIndicators(.hidden)
            .overlay(alignment: .topLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24, weight: .regular))
                        .foregroundStyle(.hkDarkGray)
                        .padding(20)
                }
            }
        
        
    }
    
}

fileprivate struct SectionHeading: View {
    
    var title: String
    var sfSymbol: String
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 3) {
            
            Image(systemName: sfSymbol)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.hkBlack)
            
            Text(title)
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(.hkBlack)
                .lineLimit(1)
            
            Spacer()
            
        }
        
    }
    
}

fileprivate struct DetailedBubble: View {
    
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
        .padding(15)
        .background(.hkGray)
        .clipShape(.rect(cornerRadius: 25, style: .continuous))
        
        
    }
    
}

struct DetailPair: Identifiable {
    
    var id = UUID()
    var key: String
    var value: String
    
}
