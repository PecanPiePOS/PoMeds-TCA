//
//  CameraViewModel.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 2/3/24.
//

import AVFoundation
import Combine
import Foundation
import SwiftUI

final class CameraViewModel: ObservableObject {
    @ObservedObject var cameraManager = CameraManager()
    @Published var showAlertError = false
    @Published var showSettingErrorAlert = false
    @Published var isPermitted = false
    
    var alertError: AlertError!
    
    var session: AVCaptureSession = .init()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        session = cameraManager.session
    }
    
    func setupBindings() {
        cameraManager.$shouldShowAlertView.sink { [weak self] value in
            self?.alertError = self?.cameraManager.alertError
            self?.showAlertError = value
        }
        .store(in: &cancellables)
    }
    
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] isGranted in
            guard let self else { return }
            if isGranted {
                self.checkForDevicePermission()
                cameraManager.configureCaptureSession()
                DispatchQueue.main.async {
                    self.isPermitted = true
                }
            }
        }
    }
    
    func checkForDevicePermission() {
        let videoPermissionStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        DispatchQueue.main.async { [weak self] in
            if videoPermissionStatus == .authorized {
                self?.isPermitted = true
            } else if videoPermissionStatus == .notDetermined {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { _ in })
            } else if videoPermissionStatus == .denied {
                self?.isPermitted = false
                self?.showSettingErrorAlert = true
            }
        }
    }
    
    func zoom(with factor: CGFloat) {
        cameraManager.setZoomScale(factor: factor)
    }
    
    func setFocus(to point: CGPoint) {
        cameraManager.setFocusOnTap(devicePoint: point)
    }
    
    func captureImage(handler: @escaping (_: Data) -> Void) {
        requestCameraPermission()
        cameraManager.captureImage { dataSet in
            guard let data = dataSet?.data else { return }
            handler(data)
        }
    }
    
    deinit {
        print("Camera Deinited")
        cameraManager.stopCapturing()
    }
}
