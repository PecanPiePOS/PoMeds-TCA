//
//  ListOfOngoingMedicationsView.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 2/8/24.
//

import SwiftUI

import ComposableArchitecture

struct ListOfOngoingMedicationsView: View {
    @State var store: StoreOf<ListOfOngoingMedicationsReducer>
    let rootStore: StoreOf<HomeReducer>
    
    var body: some View {
        ZStack {
            Color(hex: "FBFBFB").ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text("약")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.black)
                    .padding(.bottom, 10)
                if store.ongoingMedicationList.isEmpty {
                    Text("현재 복용 중인 약이 없어요.")
                        .foregroundStyle(.gray)
                        .font(.system(size: 15, weight: .light))
                        .padding(.bottom, 20)
                } else {
                    LazyVStack(content: {
                        ForEach(store.ongoingMedicationList, id: \.self) { medicine in
                            Button {
                                store.send(.cellDidTapWith(id: medicine._id, title: medicine.reasonForMedication))
                            } label: {
                                HomeCTAButtonView(primaryText: medicine.reasonForMedication, secondaryText: "", backgroundColor: Color(hex: "FEC5AC"))
                            }
                        }
                    })
                    .padding(.bottom, 10)
                }
                
                Divider()
                    .padding(.bottom, 20)
                
                Text("영양제")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.black)
                    .padding(.bottom, 10)
                
                if store.ongoingSupplementList.isEmpty {
                    Text("현재 복용 중인 영양제가 없어요.")
                        .foregroundStyle(.gray)
                        .font(.system(size: 15, weight: .light))
                        .padding(.bottom, 20)
                } else {
                    LazyVStack(content: {
                        ForEach(store.ongoingSupplementList, id: \.self) { medicine in
                            Button {
                                store.send(.cellDidTapWith(id: medicine._id, title: medicine.reasonForMedication))
                            } label: {
                                HomeCTAButtonView(primaryText: medicine.reasonForMedication, secondaryText: "", backgroundColor: Color(hex: "E8B7DD"))
                            }
                        }
                    })
                    .padding(.bottom, 10)
                }
                
                Text("각 항목당 최대 10개까지만 표시됩니다.")
                    .foregroundStyle(.red.opacity(0.5))
                    .font(.system(size: 13, weight: .light))
                    .padding(.bottom, 20)
                
                Spacer()
            }
            .padding(.top, 35)
            .padding(.horizontal, 15)
            .onAppear { store.send(.onAppear) }
            .navigationTitle("현재 복용")
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear {
                rootStore.send(.onAppear)
            }
        }
    }
}

//#Preview {
//    NavigationView {
//        ListOfOngoingMedicationsView(store: Store(initialState: ListOfOngoingMedicationsReducer.State(), reducer: {
//            ListOfOngoingMedicationsReducer()
//        }))
//    }
//}
