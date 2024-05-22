//
//  ClientsScreen.swift
//  HK
//
//  Created by Peter Kresanič on 19/12/2023.
//

import SwiftUI

struct ClientsScreen: View {
    
    @EnvironmentObject var behaviours: Behaviours
    
    var body: some View {
        
        NavigationStack(path: $behaviours.clientsNavigation) {
            
            ScrollView {
                
                VStack(spacing: 8) {
                    
                    if behaviours.clients.isEmpty {
                        Text("Načítava sa..") } else {
                            
                            ForEach(behaviours.clients) { client in
                                
                                Button {
                                    behaviours.clientsNavigation.append(client)
                                } label: {
                                    HStack {
                                        
                                        VStack(alignment: .leading, spacing: 0) {
                                            
                                            Text(client.name ?? "nebavi")
                                                .font(.system(size: 23, weight: .semibold))
                                                .foregroundStyle(.hkBlack)
                                                .lineLimit(1)
                                            
                                            Text(client.businessID ?? "nebavi")
                                                .font(.system(size: 10, weight: .medium))
                                                .foregroundStyle(.hkBlack)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 25))
                                            .foregroundStyle(.hkBlack)
                                        
                                    }
                                    .padding(.trailing, 15)
                                    .padding(.leading, 10)
                                    .padding(.vertical, 15)
                                    .background(.hkGray)
                                    .clipShape(.rect(cornerRadius: 20, style: .continuous))
                                }
                            }
                        }
                    
                }.headingAndTabPadding(isInNavigation: true)
                   
                
            }.scrollIndicators(.hidden)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(.hidden, for: .navigationBar)
                .padding(.horizontal, 15)
                .screenHeading(tabView: .clients, isInNavigation: true)
                .navigationDestination(for: HKClient.self) { client in
                    ClientDetailView(client: client)
                }
                
        }.task {
            await behaviours.populateClients()
        }
        
    }
    
}

