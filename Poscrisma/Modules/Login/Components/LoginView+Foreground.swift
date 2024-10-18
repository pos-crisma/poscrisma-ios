//
//  LoginView+Foreground.swift
//  Poscrisma
//
//  Created by Rodrigo Souza on 17/10/24.
//

import Foundation
import SwiftUI

extension Login {
    struct ForegroundView: View {
        let isLoading: Bool
        let handler: () -> Void
        
        init(isLoading: Bool, handler: @escaping () -> Void) {
            self.isLoading = isLoading
            self.handler = handler
        }
        
        var body: some View {
            GeometryReader { geometry in
                ZStack(alignment: .bottom) {
                    // Gradient
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.00),
                            Color.white.opacity(0.25),
                            Color.white.opacity(0.57),
                            Color.white.opacity(0.70),
                            Color.white.opacity(0.90)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .allowsHitTesting(false)
                    .frame(height: geometry.size.height * 0.59)
                    
                    VStack(spacing: 0) {
                        Spacer()
                        
                        // Meet Acamps Text
                        Text("Conheça Acamps")
                            .font(.system(size: 25, weight: .semibold))
                            .kerning(-0.43)
                            .foregroundColor(Color(red: 0.09, green: 0.09, blue: 0.09))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 20)
                            .allowsHitTesting(false)
                        
                        // Promo Text
                        Text("Facilidade na gestão de acampamentos")
                            .font(.system(size: 22, weight: .semibold))
                            .kerning(-0.40)
                            .foregroundColor(Color(red: 0.45, green: 0.45, blue: 0.45))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 18)
                            .allowsHitTesting(false)
                        
                        // Custom Button
                        
                        Button {
                            Manager.Haptic.shared.playHaptic(for: .impact(.medium))
                            handler()
                        } label: {
                            HStack(spacing: 8) {
                                if isLoading {
                                    ProgressView()
                                } else {
                                    Image(systemName: "plus")
                                        .font(.body)
                                        .fontWeight(.heavy)
                                    
                                    Text("Continua com Google")
                                        .font(.body)
                                        .fontWeight(.bold)
                                }
                                
                            }
                            .disabled(isLoading)
                            .foregroundStyle(.white)
                            .frame(height: 44)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(.black)
                            )
                        }
                        .padding(.bottom, 8)
                        .buttonStyle(.scale)
                        
                        // Terms and Conditions Text
                        Text("Ao clicar em \"Continuar\", você aceita os termos de uso do aplicativo e politicas de privacidade")
                            .font(.system(size: 12, weight: .semibold))
                            .kerning(0.20)
                            .foregroundColor(Color(red: 0.45, green: 0.45, blue: 0.45))
                            .multilineTextAlignment(.center)
                            
                            .padding(.bottom, 40)
                            .allowsHitTesting(false)
                    }
                    .padding(.horizontal, 32)
                    
                    // Arrow and Message Bubble
                    VStack {
                        MessageBubble()
                            .offset(x: 50, y: -geometry.size.height * 0.3)
                        
                        Arrow()
                            .offset(x: 50, y: -geometry.size.height * 0.27)
                    }
                    .allowsHitTesting(false)
//                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }

    struct Arrow: View {
        var body: some View {
            ArrowShape()
                .stroke(Color(red: 0.086, green: 0.639, blue: 0.290), lineWidth: 2)
                .frame(width: 39, height: 26)
        }
    }

    struct ArrowShape: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let width = rect.size.width
            let height = rect.size.height
            
            path.move(to: CGPoint(x: width * 0.6833268, y: height * 0.1401889))
            path.addCurve(
                to: CGPoint(x: width * 0.9084341, y: height * 0.03687036),
                control1: CGPoint(x: width * 0.7205854, y: height * 0.1010057),
                control2: CGPoint(x: width * 0.8177707, y: height * 0.02548514)
            )
            
            path.move(to: CGPoint(x: width * 0.9754829, y: height * 0.3726321))
            path.addCurve(
                to: CGPoint(x: width * 0.9093415, y: height * 0.03801393),
                control1: CGPoint(x: width * 0.9769780, y: height * 0.3050479),
                control2: CGPoint(x: width * 0.9658463, y: height * 0.1435043)
            )
            
            path.move(to: CGPoint(x: width * 0.02439024, y: height * 0.9642857))
            path.addCurve(
                to: CGPoint(x: width * 0.8980683, y: height * 0.05715500),
                control1: CGPoint(x: width * 0.2805171, y: height * 0.8569429),
                control2: CGPoint(x: width * 0.6689756, y: height * 0.7012036)
            )
            
            return path
        }
    }

    struct MessageBubble: View {
        @State private var scale: CGFloat = 0.95
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 100)
                    .fill(Color(red: 0.839, green: 0.961, blue: 0.882))
                    .shadow(color: Color(red: 0.467, green: 0.580, blue: 0.486).opacity(0.3), radius: 4, x: 0, y: 2)
                
                HStack(spacing: 8) {
//                    Image("avatar")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 46, height: 46)
//                        .clipShape(Circle())
                    
                    Circle()
                        .fill(Color.green.opacity(0.2))
                        .frame(width: 30, height: 30)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Ei você,")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(red: 0.392, green: 0.765, blue: 0.529))
                        
                        Text("Convite para o acamps")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(red: 0.086, green: 0.639, blue: 0.290))
                    }
                    
                    Spacer(minLength: 22)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
            .frame(width: 300, height: 50)
            .rotationEffect(.degrees(32.85))
            .scaleEffect(scale)
            .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true), value: scale)
            .onAppear {
                scale = 1.0
            }
        }
    }
}
