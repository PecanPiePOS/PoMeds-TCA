//
//  CameraManager.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 2/4/24.
//

import AVFoundation
import SwiftUI
import UIKit

// 이 @Observable Macro 는 아직 Combine 에 연결되지 못하는구나
final class CameraManager: ObservableObject {
    enum Status {
        case configured
        case unconfigured
        case unauthorized
        case failed
    }
    
    @Published var capturedImageSet: CapturedImageSet? = nil
    @Published var status = Status.unconfigured
    @Published var shouldShowAlertView = false
    var alertError: AlertError = AlertError()
    
    let session = AVCaptureSession()
    private let imageOutput = AVCapturePhotoOutput()
    private var videoDeviceInput: AVCaptureDeviceInput?
    private let position: AVCaptureDevice.Position = .back
    
    private var cameraDelegate: CameraDelegate?
    private let sessionQueue = DispatchQueue(label: "captureQueue")
    
    func configureCaptureSession() {
        sessionQueue.async { [weak self] in
            guard let self, self.status == .unconfigured else { return }
            
            self.session.beginConfiguration()
            self.session.sessionPreset = .photo
            self.setupVideoInput()
            self.setupPhotoOutput()
            self.session.commitConfiguration()
            self.startCapturing()
        }
    }
    
    private func setupVideoInput() {
        do {
            let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position)
            guard let camera else {
                print("Video Device is unavailable")
                status = .unconfigured
                session.commitConfiguration()
                return
            }
            
            let videoInput = try AVCaptureDeviceInput(device: camera)
            
            if session.canAddInput(videoInput) {
                session.addInput(videoInput)
                videoDeviceInput = videoInput
                status = .configured
            } else {
                print("Video Input can't be added to the session")
                status = .unconfigured
                session.commitConfiguration()
                return
            }
        } catch {
            print("Can't create Video Input: \(error)")
            status = .failed
            session.commitConfiguration()
            return
        }
    }
    
    private func setupPhotoOutput() {
        if session.canAddOutput(imageOutput) {
            session.addOutput(imageOutput)
            
            imageOutput.isHighResolutionCaptureEnabled = true
            imageOutput.maxPhotoQualityPrioritization = .quality
            status = .configured
        } else {
            print("Can't add photo output to the session")
            // Set an error status and return
            status = .failed
            session.commitConfiguration()
            return
        }
    }
    
    private func startCapturing() {
        if status == .configured {
            self.session.startRunning()
        } else if status == .unconfigured || status == .unauthorized {
            DispatchQueue.main.async {
                self.alertError = AlertError(title: "Camera Error", message: "Camera configuration failed. Either your device camera is not available or its missing permissions", primaryButtonTitle: "ok", secondaryButtonTitle: nil, primaryAction: nil, secondaryAction: nil)
                self.shouldShowAlertView = true
            }
        }
    }
    
    func captureImage(completion: @escaping (_: CapturedImageSet?) -> Void) {
        sessionQueue.async { [weak self] in
            guard let self else { return }
            
            var photoSettings = AVCapturePhotoSettings()
            
            if imageOutput.availablePhotoCodecTypes.contains(.hevc) {
                photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
            }
            
            photoSettings.isHighResolutionPhotoEnabled = true
            
            if let previewFormatType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
                photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
            }
            photoSettings.photoQualityPrioritization = .quality
            
            if let videoConnection = imageOutput.connection(with: .video), videoConnection.isVideoRotationAngleSupported(0) {
                videoConnection.videoRotationAngle = 0
            }
            
            cameraDelegate = CameraDelegate { [weak self] data in
                self?.capturedImageSet = data
                completion(data)
            }
            
            if let cameraDelegate {
                self.imageOutput.capturePhoto(with: photoSettings, delegate: cameraDelegate)
            }
        }
    }
    
    func stopCapturing() {
        sessionQueue.async { [weak self] in
            guard let self else { return }
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }
    
    func setFocusOnTap(devicePoint: CGPoint) {
        guard let cameraDevice = self.videoDeviceInput?.device else { return }
        do {
            try cameraDevice.lockForConfiguration()
            if cameraDevice.isFocusModeSupported(.autoFocus) {
                cameraDevice.focusMode = .autoFocus
                cameraDevice.focusPointOfInterest = devicePoint
            }
            cameraDevice.exposureMode = .autoExpose
            cameraDevice.exposurePointOfInterest = devicePoint
            cameraDevice.isSubjectAreaChangeMonitoringEnabled = true
            cameraDevice.unlockForConfiguration()
        } catch {
            print("Failed to configure focus: \(error)")
        }
    }
    
    func setZoomScale(factor: CGFloat) {
        guard let cameraDevice = self.videoDeviceInput?.device else { return }
        do {
            try cameraDevice.lockForConfiguration()
            cameraDevice.videoZoomFactor = max(
                cameraDevice.minAvailableVideoZoomFactor,
                max(factor, cameraDevice.minAvailableVideoZoomFactor)
            )
            cameraDevice.unlockForConfiguration()
        } catch  {
            print(error.localizedDescription)
        }
    }
}

final class CameraDelegate: NSObject, AVCapturePhotoCaptureDelegate {
    
    private let completion: (CapturedImageSet?) -> Void
    
    init(completion: @escaping (CapturedImageSet?) -> Void) {
        self.completion = completion
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error {
            print("Error occured with capturing photo: \(error)")
            completion(nil)
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else {
            print("Error saving captured image")
            completion(nil)
            return
        }

        if let orientedImage = correctOrientation(for: imageData) {
            completion(.init(image: orientedImage, data: imageData))
        } else {
            print("Error orienting image.")
            completion(nil)
        }
    }
    
    private func correctOrientation(for imageData: Data) -> UIImage? {
        guard let ciImage = CIImage(data: imageData) else { return nil }
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        let image = UIImage(cgImage: cgImage, scale: 1.0, orientation: .right)
        return image
    }
}

// TODO: Not Needed - 리펙토링 할 때 제거하자.
struct AlertError {
    var title: String = ""
    var message: String = ""
    var primaryButtonTitle = "Accept"
    var secondaryButtonTitle: String?
    var primaryAction: (() -> ())?
    var secondaryAction: (() -> ())?
    
    public init(title: String = "", message: String = "", primaryButtonTitle: String = "Accept", secondaryButtonTitle: String? = nil, primaryAction: (() -> ())? = nil, secondaryAction: (() -> ())? = nil) {
        self.title = title
        self.message = message
        self.primaryAction = primaryAction
        self.primaryButtonTitle = primaryButtonTitle
        self.secondaryAction = secondaryAction
    }
}
