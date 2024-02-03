//
//  ListOfRecognizedMedicineView.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 2/4/24.
//

import SwiftUI

import ComposableArchitecture

struct ListOfRecognizedMedicineView: View {
    @State var store: StoreOf<ListOfRecognizedMedicineReducer>
    @State var isExitAlertOpen = false
    @State var isNewMedicineAlertOpen = false
    @State var isEditMedicineAlertOpen = false
    @State var newMedicine = ""
    @State var editingMedicine = ""
    
    var body: some View {
        ZStack {
            Color(hex: "FBFBFB").ignoresSafeArea()
            
            VStack {
                HStack {
                    Text(store.titleText)
                        .font(.system(.title, weight: .heavy))
                    
                    Spacer()
                    
                    Button(action: {
                        isNewMedicineAlertOpen = true
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                            .foregroundStyle(Color(hex: "FEB66D"))
                    })
                    .padding(.trailing, 4)
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                
                Divider()
                    .padding(.horizontal, 20)
                
                List {
                    Section {
                        ForEach(store.recognizedList, id: \.id) { medicine in
                            HStack {
                                Text(medicine.medicineName)
                                    .font(.system(size: 18, weight: .medium))
                                Spacer()
                                Button {
                                    editingMedicine = medicine.medicineName
                                    store.send(.editMedicineDidTap(
                                        medicine.medicineName
                                        , medicine.id
                                    ))
                                    isEditMedicineAlertOpen = true
                                } label: {
                                    Image(systemName: "pencil.and.scribble")
                                        .foregroundStyle(.brown)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                        }
                        .onDelete(perform: { indexSet in
                            store.send(.removeDidTap(indexSet))
                        })
                    } footer: {
                        Text("촬영한 약 이름과 다르다면, 오른쪽의 수정 아이콘을 눌러 수정해주세요. 삭제하시려면, 왼쪽으로 스와이프 해주세요.")
                            .foregroundStyle(.gray.opacity(0.7))
                    }
                }
                .scrollContentBackground(.hidden)
                .background(.clear)
                .listRowBackground(Color(hex: "F1F1F1"))
                .padding(.top, -24)
                
                Spacer()
                
                Button {
                    store.send(.completeEditing)
                } label: {
                    CommonCleanNextButtonView(buttonTitle: "다음", backgroundColor: Color(hex: "FEC5AC"))
                }
                .padding(.horizontal, 15)
            }
        }
        .navigationTitle("약 수정하기")
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    isExitAlertOpen = true
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.gray.opacity(0.8))
                        .frame(width: 24, height: 24)
                })
                .padding(.trailing, 6)
            }
        }
        .alert("새로운 복용 추가를 그만 하기겠습니까?", isPresented: $isExitAlertOpen, actions: {
            Button("취소", role: .cancel, action: {})
            Button("확인", role: .destructive, action: { store.send(.popToRootView) })
        }, message: {
            Text("저장된 모든 정보가 사라져요")
        })
        .alertWithTextField(isPresented: $isNewMedicineAlertOpen, title: "새로운 약 추가", message: "새로운 약 이름을 추가해주세요.", text: $newMedicine, placeholder: "새로운 약을 추가하세요", doneButtonTitle: "추가", onCompleted: { newMedicineText in
            store.send(.addingNewMedicineDidEndEditing(newMedicineText))
            self.newMedicine = ""
        })
        .alertWithTextField(isPresented: $isEditMedicineAlertOpen, title: "약 이름 수정", message: "선택한 약의 이름을 수정해주세요.", text: $editingMedicine, placeholder: "수정할 약 이름", doneButtonTitle: "수정", onCompleted: { editedMedicineText in
            store.send(.editingMedicineDidEndEditing(editedMedicineText))
            self.newMedicine = ""
        })
        // 이곳에서 alert 를 사용하지 않는 이유는, 기본 alert 를 사용할 경우 알아서 잡히기 때문에 그렇다. 꼬인다 서로.
        //        .alert(store: self.store.scope(state: \.$alert, action: \.alert))
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    NavigationStack {
        ListOfRecognizedMedicineView(store: Store(initialState: ListOfRecognizedMedicineReducer.State(dataPassed: .init(nameList: ["hhhh", "pppp"], type: .medication)), reducer: {
            ListOfRecognizedMedicineReducer()
        }))
    }
}
