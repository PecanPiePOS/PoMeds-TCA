//
//  ListOfPastMedicationsView.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 2/8/24.
//

import SwiftUI

import ComposableArchitecture

struct ListOfPastMedicationsView: View {
    @State var store: StoreOf<ListOfPastMedicationsReducer>
    let rootStore: StoreOf<HomeReducer>
    
    var body: some View {
        ZStack {
            Color(hex: "FBFBFB").ignoresSafeArea()

            VStack(alignment: .leading) {
                Text("약")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.black)
                    .padding(.bottom, 10)
                if store.pastMedicationList.isEmpty {
                    Text("과거 복용했던 약이 없어요.")
                        .foregroundStyle(.gray)
                        .font(.system(size: 15, weight: .light))
                        .padding(.bottom, 20)
                } else {
                    LazyVStack(content: {
                        ForEach(store.pastMedicationList, id: \.self) { medicine in
                            Button {
                                store.send(.cellDidTapWith(id: medicine._id, title: medicine.reasonForMedication))
                            } label: {
                                HomeCTAButtonView(primaryText: medicine.reasonForMedication, secondaryText: "", backgroundColor: Color(hex: "FFC1A7"))
                            }
                        }
                    })
                    .padding(.bottom, 20)
                }
                
                Divider()
                    .padding(.bottom, 20)
                
                Text("영양제")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.black)
                    .padding(.bottom, 10)
                
                if store.pastSupplementList.isEmpty {
                    Text("과거 복용했던 영양제가 없어요.")
                        .foregroundStyle(.gray)
                        .font(.system(size: 15, weight: .light))
                        .padding(.bottom, 20)
                } else {
                    LazyVStack(content: {
                        ForEach(store.pastSupplementList, id: \.self) { medicine in
                            Button {
                                store.send(.cellDidTapWith(id: medicine._id, title: medicine.reasonForMedication))
                            } label: {
                                HomeCTAButtonView(primaryText: medicine.reasonForMedication, secondaryText: "", backgroundColor: Color(hex: "E09DD1"))
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
            .navigationTitle("과거 복용")
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear {
                rootStore.send(.onAppear)
            }
        }
    }
}
//
//#Preview {
//    ListOfPastMedicationsView(store: Store(initialState: ListOfPastMedicationsReducer.State(), reducer: {
//        ListOfPastMedicationsReducer()
//    }))
//}
