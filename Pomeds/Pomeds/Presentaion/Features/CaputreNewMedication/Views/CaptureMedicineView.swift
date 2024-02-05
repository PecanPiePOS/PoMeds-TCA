//
//  CaptureMedicineView.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 2/2/24.
//

import SwiftUI

import ComposableArchitecture

struct CaptureMedicineView: View {
    @State var store: StoreOf<CaptureMedicinesReducer>
    @State var isScaled = false
    @State var currentZoomFactor: CGFloat = 1.0
    @State var isCaptureInProgress = false
    @State var isCaptureButtonEnabled = true
    @ObservedObject var viewModel = CameraViewModel()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            Color(hex: "292929").ignoresSafeArea()

            VStack {
                Spacer()
                    .frame(height: 30)
                
                ZStack {
                    CameraView(session: viewModel.session)
                        .aspectRatio(3/4, contentMode: .fit)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    self.currentZoomFactor += value - 1.0
                                    self.currentZoomFactor = min(max(self.currentZoomFactor, 0.5), 10)
                                    self.viewModel.zoom(with: self.currentZoomFactor)
                                }
                        )
                    
                    VStack {
                        Rectangle()
                            .fill(Color(hex: "292929").opacity(0.5))
                        
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .stroke(Color.orange, lineWidth: 2)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 3)
                        
                        Rectangle()
                            .fill(Color(hex: "292929").opacity(0.5))
                    }
                }
                .aspectRatio(3/4, contentMode: .fit)
                .padding(.horizontal, 30)
                .padding(.bottom, 10)
                
                HStack {
                    Spacer()
                    if store.photoCount != 0 {
                        Button {
                            store.send(.removeLastPhotoDidTap)
                        } label: {
                            Image(systemName: "trash.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                                .foregroundStyle(.red.opacity(0.8))
                            Text("이전 사진 지우기")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.red.opacity(0.8))
                        }
                    }
                }
                .frame(height: 20)
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
                
                Spacer()
                
                ZStack {
                    HStack {
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: UIImage(data: store.caputredPhotoStack.last ?? Data()) ?? UIImage())
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .rotationEffect(.degrees(90))
                            
                            Text("\(store.photoCount)")
                                .font(.footnote)
                                .padding(7)
                                .background(Color(hex: "FF5050"))
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .offset(x: 10, y: -10)
                        }
                        .opacity(store.photoCount == 0 ? 0: 1)
                        
                        Spacer()
                        
                        Button {
                            store.send(.moveToNextDidTap)
                        } label: {
                            Image(systemName: "arrow.right.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(Color(hex: "DDDDDD"))
                                .frame(width: 40, height: 40)
                        }
                    }
                    
                    ZStack {
                        Button {
                            store.send(.captureDisable)
                            viewModel.captureImage { [store = self.store] data in
                                store.send(.captureDidTap(data))
                            }
                        } label: {
                            Image(systemName: "circle.inset.filled")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle( store.isCaptureEnabled ? Color(hex: "DDDDDD"): .gray)
                                .frame(width: 70, height: 70)
                        }
                        .disabled(!store.isCaptureEnabled)
                        
                        if store.isCapturingProcessLoading != false {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .foregroundStyle(.orange)
                                .controlSize(.large)
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
            }
            
            if store.isRecognizingLoading {
                ProgressLoadingView(text: "인식 중")
                    .ignoresSafeArea()
            }
        }
        .toolbar(store.isRecognizingLoading ? .hidden: .visible, for: .navigationBar)
        .alert(store: self.store.scope(state: \.$alert, action: \.alert))
        .navigationTitle("약 찍기")
        .navigationBarBackButtonHidden()
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Color(hex: "292929"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.white.opacity(0.8))
                })
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    store.send(.moveToSupplementsDidTap)
                }, label: {
                    Text("영양제")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Color(hex: "FFBD70"))
                })
            }
        }
        .onAppear {
            store.send(.resetLoading)
            viewModel.setupBindings()
            viewModel.requestCameraPermission()
        }
    }
}

#Preview {
    CaptureMedicineView(store: Store(initialState: CaptureMedicinesReducer.State(), reducer: {
        CaptureMedicinesReducer()
    }))
}
