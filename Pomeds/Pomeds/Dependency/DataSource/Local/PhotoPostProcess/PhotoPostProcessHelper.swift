//
//  PhotoPostProcessHelper.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 2/4/24.
//

import Combine
import UIKit

final class PhotoPostProcessHelper {
    static func cropDataInTheMiddle(of data: Data) async throws -> Data {
        guard let image = UIImage(data: data),
              let cgImage = image.cgImage else {
            return data
        }
        
        let originalWidth = CGFloat(cgImage.width)
        let originalHeight = CGFloat(cgImage.height)
        let cropHeight = originalHeight/3.3
        let cropYOffset = cropHeight
        
        let cropRect = CGRect(x: 0, y: cropYOffset, width: originalWidth, height: cropHeight).integral
        
        if let croppedImage = cgImage.cropping(to: cropRect) {
            let croppedImage = UIImage(cgImage: croppedImage)
            return croppedImage.jpegData(compressionQuality: 1.0) ?? data
        }
            
        print("Cropping data failed")
        
        return data
    }
}
