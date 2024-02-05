//
//  VisionRecognitionHelper.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 1/31/24.
//

import Combine
import UIKit
import Vision
import VisionKit

final class VisionRecognitionHelper: ObservableObject {
    
    static let shared = VisionRecognitionHelper()
    private init() {}
    
    private var ocrStrings: [String?] = []
    private var count: Int = 0
    
    func getRecognizedText(with images: [Data]) async throws -> [String?] {
        defer {
            print(ocrStrings, "📌📌📌📌📌")
            ocrStrings = []
        }
        for imageData in images {
            await recognizeText(with: UIImage(data: imageData) ?? UIImage())
        }
        return ocrStrings
    }

    private func recognizeText(with image: UIImage) async {
        guard let image = image.cgImage else {
            ocrStrings.append(nil)
            count += 1
            return }
        
        let handler = VNImageRequestHandler(cgImage: image, options: [:])
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let result = request.results as? [VNRecognizedTextObservation], error == nil else { return }
            let text = result.compactMap { $0.topCandidates(1).first?.string }
                .joined(separator: "\n")
            
            self?.ocrStrings.append(text)
            self?.count += 1
        }
        request.revision = VNRecognizeTextRequestRevision3
        request.recognitionLanguages = ["ko-KR", "en-US"]
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
        do {
            try handler.perform([request])
        } catch let error {
            print(error)
            ocrStrings.append(nil)
            self.count += 1
        }
    }
}

// 참조: https://leetaek.tistory.com/76
