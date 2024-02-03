//
//  CameraView.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 2/2/24.
//

import AVFoundation
import SwiftUI
import UIKit

struct CameraView: UIViewRepresentable {
    let session: AVCaptureSession
    
    // UIKit 베이스의 Video 프리뷰 생성
    func makeUIView(context: Context) -> VideoPreview {
        let view = VideoPreview()
        view.backgroundColor = .gray
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.videoGravity = .resizeAspect
        view.videoPreviewLayer.connection?.videoRotationAngle = 0
        return view
    }
    
    // Video 프리뷰 업데이트
    func updateUIView(_ uiView: VideoPreview, context: Context) {}
    
    // 카메라의 프리뷰를 보여주는 UIKit 베이스 뷰
    class VideoPreview: UIView {
        // 어떤 레이어의 클래스가 사용되는지 특정
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }
        
        // config 를 위해 프리뷰 레이러를 fetch
        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }
}

