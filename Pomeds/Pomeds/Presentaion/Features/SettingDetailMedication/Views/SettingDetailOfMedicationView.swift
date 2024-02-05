//
//  SettingDetailOfMedicationView.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 2/5/24.
//

import SwiftUI

import ComposableArchitecture

struct SettingDetailOfMedicationView: View {
    @State var store: StoreOf<SettingDetailOfMedicationReducer>
    
    @State var isTitleAlertOpen = false
    @State var startDate = Date()
    @State var endDate = Date().addingTimeInterval(604800)
    @State var startTimeOfTaking = Date()
    @State var isFinalCheckAlertOpen = false
    
    @State var isAlarmOn = true
    @State var titleText = ""
    @State var intervalTaking = 1
    
    var body: some View {
        ZStack {
            Color(hex: "FBFBFB").ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("상세복용 정보")
                        .font(.system(.title, weight: .heavy))
                    
                    Spacer()
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                
                Form {
                    Section {
                        Button(action: {
                            isTitleAlertOpen = true
                        }, label: {
                            SettingDetailFormCellView(cellTitle: SettingDetailFormType.medicationTitle.title, cellSystemImageTitle: "questionmark.bubble.fill", resultText: store.medicationTitle)
                        })
                    } header: {
                        Text("어떤 이유 때문에 약을 먹나요?")
                            .foregroundStyle(.gray.opacity(0.7))
                            .padding(.leading, -10)
                    } footer: {
                        Text("예시) 약 - 감기 약, 장염 약, 영양제 - 비타민")
                            .foregroundStyle(.gray.opacity(0.8))
                            .padding(.leading, -10)
                    }
                    
                    Section {
                        Menu {
                            Button(action: {
                                store.send(.medicationTypeDidSelected(.medication))
                            }, label: {
                                Text("약")
                            })
                            Button(action: {
                                store.send(.medicationTypeDidSelected(.supplements))
                            }, label: {
                                Text("영양제")
                            })
                        } label: {
                            SettingDetailFormCellView(cellTitle: SettingDetailFormType.type.title, cellSystemImageTitle: "pills.circle.fill", resultText: store.medicineTypeTitle)
                        }
                    } header: {
                        Text("질병 치료를 위한 약 또는, 영양제")
                            .foregroundStyle(.gray.opacity(0.7))
                            .padding(.leading, -10)
                    }
                    
                    Section {
                        DatePicker(selection: $startDate, displayedComponents: .date) {
                            SettingDetailFormCellView(cellTitle: SettingDetailFormType.startDate.title, cellSystemImageTitle: "calendar.circle", resultText: "", isImageNeeded: true)
                        }
                        
                        DatePicker(selection: $endDate, displayedComponents: .date) {
                            SettingDetailFormCellView(cellTitle: SettingDetailFormType.endDate.title, cellSystemImageTitle: "calendar.circle.fill", resultText: "", isImageNeeded: true)
                        }
                        
                        Menu {
                            ForEach((1...8), id: \.self) { count in
                                Button(action: {
                                    store.send(.numberOfTakingPerDayDidAdd(count))
                                }, label: {
                                    Text("\(count)번")
                                })
                            }
                        } label: {
                            SettingDetailFormCellView(cellTitle: SettingDetailFormType.numberOfTakingPerDay.title, cellSystemImageTitle: "checkmark.circle", resultText: store.numberOfTakingPerDay != nil ? "\(store.numberOfTakingPerDay!)번": "")
                        }
                        
                        SettingDetailFormCellWithPickerView(selectedItem: $intervalTaking, cellTitle: SettingDetailFormType.interval.title, cellSystemImageTitle: "clock.badge.questionmark")

                        DatePicker(selection: $startTimeOfTaking, displayedComponents: .hourAndMinute) {
                            SettingDetailFormCellView(cellTitle: SettingDetailFormType.startTimeOfTheTaking.title, cellSystemImageTitle: "calendar.badge.clock", resultText: "", isImageNeeded: true)
                        }
                        .pickerStyle(.menu)
                    }
                    
                    Section {
                        HStack {
                            Image(systemName: "alarm.waves.left.and.right.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                                .padding(.trailing, 4)
                                .foregroundStyle(Color(hex: "F8AB8B"))
                            
                            Text(SettingDetailFormType.isAlarmOn.title)
                                .font(.system(size: 16, weight: .regular))
                            Toggle("", isOn: $isAlarmOn)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .background(.clear)
                .listRowBackground(Color(hex: "F1F1F1"))
                .padding(.top, -24)
                
                Spacer()
                
                Text("⚠️ 뒤로가기를 하면 모두 지워지니 주의해주세요!")
                    .font(.system(size: 13, weight: .light))
                    .padding(.bottom, 5)
                    .foregroundStyle(.red.opacity(0.6))
                
                Button {
                    store.send(.startDateDidAdd(startDate))
                    store.send(.endDateDidAdd(endDate))
                    store.send(.medicationIntervalTimeDidAdd(intervalTaking))
                    store.send(.startTimeOfTakingDidAdd(startTimeOfTaking))
                    store.send(.alarmEnabled(isAlarmOn))
                    isFinalCheckAlertOpen = true
                } label: {
                    CommonCleanNextButtonView(buttonTitle: "등록하기", backgroundColor: Color(hex: "FEC5AC"))
                }
                .padding(.horizontal, 15)
            }
            
            if store.isLoading {
                ProgressLoadingView(text: "저장 중")
                    .ignoresSafeArea()
            }
            
            if store.isErrorHappened {
                VStack {
                    Spacer()
                    
                    ToastView(toastColor: .red, toastMessage: "아직 채워지지 않은 항목이 있어요!")
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.5), value: store.isErrorHappened)
                }
                
            }
        }
        .navigationBarBackButtonHidden(store.isLoading ? true: false)
        .alertWithTextField(isPresented: $isTitleAlertOpen, title: "복용 제목 설정", message: "약 - 감기 약, 혈압 약 등등\n영양제 - 밀크씨슬, 철분보충제 등등", text: $titleText, placeholder: "", doneButtonTitle: "확인", onCompleted: { title in
            store.send(.medicationTitleDidEndEditing(title))
        })
        .alert("모든 사항을 기입하셨나요?", isPresented: $isFinalCheckAlertOpen, actions: {
            Button(action: {
                store.send(.completeButtonDidTap)
            }, label: {
                Text("확인")
            })
            Button(action: {},
                   label: {
                Text("취소")
            })
        }, message: {
            Text("수정은 어려워요.\n꼭 다시 한번 확인해주세요!")
        })
        .onAppear { store.send(.onAppear) }
        .onChange(of: store.isErrorHappened) { _, newValue in
            if newValue == true {
                triggerVibration()
            }
        }
    }
    
    private func triggerVibration() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
}

#Preview {
    NavigationStack {
        SettingDetailOfMedicationView(store: Store(initialState: SettingDetailOfMedicationReducer.State(listOfMedicinesPassed: [], medicineType: .medication), reducer: {
            SettingDetailOfMedicationReducer()
        }))
    }
}

enum SettingDetailFormType {
    case medicationTitle
    case type
    case startDate
    case endDate
    case interval
    case numberOfTakingPerDay
    case startTimeOfTheTaking
    case isAlarmOn
    
    var title: String {
        switch self {
        case .medicationTitle:
            return "복용 제목"
        case .type:
            return "약의 종류"
        case .startDate:
            return "시작 날짜"
        case .endDate:
            return "종료 날짜"
        case .interval:
            return "하루 복용 간격"
        case .numberOfTakingPerDay:
            return "하루 복용 횟수"
        case .startTimeOfTheTaking:
            return "하루의 첫 복용 시간"
        case .isAlarmOn:
            return "알림 설정"
        }
    }
}

struct SettingDetailFormCellView: View {
    var cellTitle: String
    var cellSystemImageTitle: String
    var resultText: String
    var isImageNeeded = false
    
    var body: some View {
        HStack {
            Image(systemName: cellSystemImageTitle)
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
                .padding(.trailing, 4)
                .foregroundStyle(Color(hex: "F8AB8B"))
            
            Text(cellTitle)
                .font(.system(size: 16, weight: .regular))
            
            Spacer()
            
            if isImageNeeded != true {
                if resultText.isEmpty {
                    Image(systemName: "chevron.right")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12, height: 12)
                        .foregroundStyle(.gray.opacity(0.5))
                } else {
                    HStack {
                        Text(resultText)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundStyle(.gray)
                            .padding(.trailing, 2)
                        Image(systemName: "chevron.right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12, height: 12)
                            .foregroundStyle(.gray.opacity(0.5))
                    }
                }
            }
        }
    }
}

struct SettingDetailFormCellWithPickerView: View {
    @Binding var selectedItem: Int
    var cellTitle: String
    var cellSystemImageTitle: String
    
    var body: some View {
        HStack {
            Image(systemName: cellSystemImageTitle)
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
                .padding(.trailing, 4)
                .foregroundStyle(Color(hex: "F8AB8B"))
            
            Text(cellTitle)
                .font(.system(size: 16, weight: .regular))
            
            Spacer()
            
            Picker("간격", selection: $selectedItem) {
                ForEach(Array(1...23), id: \.self) {
                    Text("\($0)시간")
                }
            }
            .labelsHidden()
            .pickerStyle(.menu)
        }
    }
}

struct ToastView: View {
    let toastColor: Color
    let toastMessage: String
    
    var body: some View {
        Text(toastMessage)
            .padding()
            .padding(.horizontal, 15)
            .font(.system(size: 17, weight: .semibold))
            .background(toastColor.opacity(0.6))
            .foregroundColor(.white)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.5), radius: 8)
            .padding(.bottom, 40)
    }
}
