//
//  CustomTabView.swift
//  HK
//
//  Created by Peter Kresanič on 08/12/2023.
//

import SwiftUI
import CodeScanner

struct CustomTabView: View {
    
    @EnvironmentObject var behaviours: Behaviours
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            if behaviours.activeTab == .home {
                
                HStack(spacing: 15) {
                    
                    Button {
                        behaviours.isScanning = true
                    } label: {
                        NarrowButton(title: "Skenovať", sfSymbol: "qrcode", buttonRole: .confirmation)
                    }
                    
                }.padding(.horizontal, 15)
                    .padding(.top, 10)
                    .zIndex(3)
                    .background {
                        Color.hkWhite.opacity(0.5)
                            .background(.ultraThinMaterial)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                
            } else if behaviours.activeTab == .clients {
                
                HStack(spacing: 15) {
                    
                    Button {
                        behaviours.isConnectingToClient = true
                    } label: {
                        NarrowButton(title: "Priradiť produkt", sfSymbol: "person.fill.badge.plus", buttonRole: .confirmation)
                    }
                    
                }.padding(.horizontal, 15)
                    .padding(.top, 10)
                    .zIndex(3)
                    .background {
                        Color.hkWhite.opacity(0.5)
                            .background(.ultraThinMaterial)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                
            }
//            } else if behaviours.activeTab == .clients {
//                HStack(spacing: 15) {
//                    
//                    Button {
//                        behaviours.isAddingNewItems = true
//                    } label: {
//                        NarrowButton(title: "Priradiť produkty ku klientovi", sfSymbol: "rectangle.stack.badge.person.crop", buttonRole: .confirmation)
//                    }
//                    
//                }.padding(.horizontal, 15)
//                    .padding(.top, 10)
//                    .zIndex(3)
//                    .background {
//                        Color.hkWhite.opacity(0.5)
//                            .background(.ultraThinMaterial)
//                    }
//                    .transition(.move(edge: .bottom).combined(with: .opacity))
//            }
            
            HStack(alignment: .center) {
                
                Spacer()
                
                TabViewIcon(tabView: .home)
                
                Spacer()
                
                TabViewIcon(tabView: .clients)
                
                Spacer()
                
                TabViewIcon(tabView: .catalogue)
                
                Spacer()
                
            }.frame(maxHeight: 80)
                .background {
                    Color.hkWhite.opacity(0.5)
                        .background(.ultraThinMaterial)
                }
                .zIndex(4)
        }
        .padding(.bottom, 10)
            .frame(maxWidth: .infinity)
            
    }
    
}

fileprivate struct TabViewIcon: View {
    
    let tabView: TabViews
    @EnvironmentObject var behaviours: Behaviours
    
    var body: some View {
        
        Button {
            withAnimation(.easeInOut(duration: 0.15)) { behaviours.activeTab = tabView }
        } label: {
            
            VStack(spacing: 5) {
                
                Image(systemName: behaviours.activeTab != tabView ? tabView.sfSymbol.0 : tabView.sfSymbol.1)
                    .font(.system(size: 27))
                    .frame(height: 28)
                
                Text(tabView.readable)
                    .font(.system(size: 10, weight: .medium))
                
            }.foregroundColor(behaviours.activeTab == tabView ? .hkBlack : .hkBlack.opacity(0.9))
            
        }.frame(width: 60)
        
    }
    
}
