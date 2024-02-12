//
//  RegisterNewMedicationView.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 1/30/24.
//

import Combine
import SwiftUI
import UIKit

import ComposableArchitecture

struct RegisterNewMedicationView: View {
    @State var store: StoreOf<RegisterNewMedicationReducer>
    @State var isAnimating = true
    private let timer = Timer.publish(every: 1.2, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color(hex: "FBFBFB").ignoresSafeArea()
            
            VStack(alignment: .center) {
                Image(systemName: isAnimating ? "pill.circle.fill": "cross.vial.fill")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color(hex: "FFBE98"), Color(hex: "FCece2"))
                    .contentTransition(.symbolEffect(.replace))
                    .frame(width: 200, height: 200)
                    .padding(.bottom, 40)
                
                NavigationLink(state: HomeReducer.Path.State.captureImageScene()) {
                    Image(systemName: "text.viewfinder")
                        .scaledToFit()
                        .scaleEffect(2)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color(hex: "F7821b"), .gray)
                        .frame(width: 64, height: 64)
                        .background(Color(hex: "ECEEED"))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(color: Color(hex: "F7821b").opacity(0.7), radius: 10, x: 0, y: 1)
                }
                .padding(.bottom, 8)
                
                Text("약 찍기")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color(hex: "6a6a6a"))
                    .padding(.bottom, -2)
                
                Text("최대 8장")
                    .font(.system(size: 13, weight: .heavy))
                    .foregroundStyle(Color(hex: "EEBDA1"))
                    .padding(.bottom, 4)
                
                Text("약 봉투의 약의 이름을\n하나하나 잘 보이게\n찍어주세요")
                    .font(.system(size: 13, weight: .ultraLight))
                    .foregroundStyle(Color(hex: "848484"))
                    .multilineTextAlignment(.center)
            }
            
        }
        .onReceive(timer, perform: { _ in
            isAnimating.toggle()
        })
        .navigationTitle("새로운 약 등록")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    print("Something")
                }, label: {
                    Image(systemName: "questionmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.teal)
                })
            }
        }
    }
}

#Preview {
    RegisterNewMedicationView(store: Store(initialState: RegisterNewMedicationReducer.State(), reducer: {
        RegisterNewMedicationReducer()
    }))
}
