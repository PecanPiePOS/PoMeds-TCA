//
//  HomeView.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 1/30/24.
//

import SwiftUI

import ComposableArchitecture
import RealmSwift

struct HomeView: View {
    @State var store: StoreOf<HomeReducer>
    
    init(store: StoreOf<HomeReducer>) {
        self.store = store
    }
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            ZStack {
                Color(hex: "FBFBFB").ignoresSafeArea()
                VStack {
                    Spacer()
                        .frame(height: 28)
                    HStack {
                        Image("logoLight")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 26, height: 26)
                            .padding(.leading)
                        Text("PoMeds")
                            .font(.system(size: 28, weight: .semibold))
                        Spacer()
                        Button(action: {
                            print("fffff")
                        }, label: {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28, alignment: .center)
                                .clipShape(Circle())
                                .foregroundStyle(.black)
                                .padding(.trailing)
                        })
                    }
                    
                    HomeCircularView(store: self.store)
                        .frame(width: 260, height: 260)
                        .padding(.top, 40)
                    
                    if !store.takingMedicationList.isEmpty {
                        
                    }
                    
                    NavigationLink(state: HomeReducer.Path.State.registerNewMedicationScene()) {
                        HomeCTAButtonView(primaryText: "New Medication", secondaryText: "새로운 약 등록하기", backgroundColor: Color(hex: "FEC5AC"))
                            .padding(.horizontal, 15)
                            .padding(.top, 30)
                    }
                    
                    Divider()
                        .background(.gray.opacity(0.1))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                    
                    NavigationLink(state: HomeReducer.Path.State.listOfOngoingMedicationScene()) {
                        HomeCTAButtonView(primaryText: "New Medication", secondaryText: "현재 복용 리스트", backgroundColor: Color(hex: "F5D0B5"))
                            .padding(.horizontal, 15)
                    }
                    
                    NavigationLink(state: HomeReducer.Path.State.listOfPastMedicationScene()) {
                        HomeCTAButtonView(primaryText: "Medication History", secondaryText: "과거 복용 리스트", backgroundColor: Color(hex: "E0D6D3"))
                            .padding(.horizontal, 15)
                    }
                    
                    Spacer()
                }
                
                if store.hasSucceededRegisteringNewMeds {
                    VStack {
                        Spacer()
                        
                        ToastView(toastColor: Color(hex: "85DD7D"), toastMessage: "새로운 약을 등록했어요!")
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .animation(.easeInOut(duration: 0.7), value: store.hasSucceededRegisteringNewMeds)
                    }
                }
            }
            .navigationTitle("Home")
            .toolbar(.hidden, for: .navigationBar)
        } destination: { store in
            switch store.state {
            case .registerNewMedicationScene:
                if let store = store.scope(state: \.registerNewMedicationScene, action: \.registerNewMedication) {
                    RegisterNewMedicationView(store: store)
                }
            case .captureImageScene:
                if let store = store.scope(state: \.captureImageScene, action: \.captureImage) {
                    CaptureMedicineView(store: store)
                }
            case .listOfRecognizedMedicinesScene:
                if let store = store.scope(state: \.listOfRecognizedMedicinesScene, action: \.listOfRecognizedMedicines) {
                    ListOfRecognizedMedicineView(store: store)
                }
            case .settingDetailOfMedicationScene:
                if let store = store.scope(state: \.settingDetailOfMedicationScene, action: \.settingDetailOfMedication) {
                    SettingDetailOfMedicationView(store: store)
                }
            case .listOfOngoingMedicationScene:
                if let store = store.scope(state: \.listOfOngoingMedicationScene, action: \.listOfOngoingMedication) {
                    ListOfOngoingMedicationsView(store: store)
                }
            case .listOfPastMedicationScene:
                if let store = store.scope(state: \.listOfPastMedicationScene, action: \.listOfPastMedication) {
                    ListOfPastMedicationsView(store: store)
                }
            case .detailOfOngoingMedicationScene:
                if let store = store.scope(state: \.detailOfOngoingMedicationScene, action: \.detailOfOngoingMedication) {
                    CommonDetailListView(store: store)
                }
            case .detailOfPastMedicationScene:
                if let store = store.scope(state: \.detailOfPastMedicationScene, action: \.detailOfPastMedication) {
                    CommonDetailListView(store: store)
                }
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
        .onChange(of: store.hasSucceededRegisteringNewMeds) { _, newValue in
            if newValue == true {
                store.send(.onAppear)
            }
        }
    }
}

#Preview {
    HomeView(store: PomedsApp.store)
}
