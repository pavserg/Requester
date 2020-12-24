//
//  PhotoPickerpRESENTER.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 22.12.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit
import Foundation
import Photos

final class PhotoPickerPresenter: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let controller: UIViewController
    private var photoAssets = [PHAsset]()
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    var allowsEditing: Bool = false
    var showInNewWindow: Bool = false
    var resultClosure: ((Data?) -> Void)?
    
    init(_ controller: UIViewController, completionClosure: ((Data?) -> Void)? ) {
        self.controller = controller
        self.resultClosure = completionClosure
    }

    func present() {
        photoAssets.removeAll()
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.mediaTypes = ["public.image"]
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .fullScreen
        
        if sourceType == .camera {
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            switch status {
            case .authorized:
                if showInNewWindow {
                    controller.present(imagePicker, animated: true, completion: nil)
                } else {
                    controller.present(imagePicker, animated: true, completion: nil)
                }
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                    DispatchQueue.main.async {
                        if granted {
                           self.controller.present(imagePicker, animated: true, completion: nil)
                        }
                    }
                })
            case .denied, .restricted:
                showSettingsAlert(sourceType: sourceType)
            default:
                break
            }
        } else {
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .authorized:
                UIApplication.shared.keyWindow?.rootViewController?.present(imagePicker, animated: true, completion: nil)
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({status in
                    DispatchQueue.main.async {
                        if status == .authorized {
                            UIApplication.shared.keyWindow?.rootViewController?.present(imagePicker, animated: true, completion: nil)
                        }
                    }
                })
            case .denied, .restricted:
                showSettingsAlert(sourceType: sourceType)
            default:
                break
            }
        }
    }
    
    private func showSettingsAlert(sourceType: UIImagePickerController.SourceType) {
        let message = sourceType == .camera ? "allow_access_to_camera_settings".localized : "allow_access_to_photo_library_settings".localized
        let alertController = UIAlertController(title: "allow_access".localized, message: message, preferredStyle: .alert)
     
        alertController.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "go_to_settings".localized, style: .default) { (_) in
            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        })
        
        alertController.preferredAction = alertController.actions[1]
        
        controller.present(alertController, animated: true, completion: nil)
    }
}

extension PhotoPickerPresenter {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        if picker.sourceType == .photoLibrary {
            if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset, photoAssets.contains(asset) == false {
                photoAssets.append(asset)
            } else {
                return
            }
        }
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let representedData = pickedImage.fixOrientation()?.resizeWithPercent(percentage: 0.25)?.jpegData(compressionQuality: 0.25)
            self.resultClosure?(representedData)
        }
        
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension UIImage {
    
    // MARK: - Initializators
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    // MARK: - Functions
    func imageCropped(toRect rect: CGRect) -> UIImage {
        guard let cgImage = self.cgImage else { return self }
        guard let imageRef = cgImage.cropping(to: rect) else { return UIImage() }
        let cropped = UIImage(cgImage: imageRef)
        return cropped
    }
    
    func fixOrientation() -> UIImage? {
        
        guard let cgImage = cgImage else { return self }
        if imageOrientation == .up { return self }
        var transform = CGAffineTransform.identity
        
        switch imageOrientation {
            
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
            
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi)
            
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: -CGFloat.pi/2)
        default:
            break
        }
        
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            
        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        let bitsPerComponent = cgImage.bitsPerComponent
        let space = cgImage.colorSpace!
        if let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: bitsPerComponent, bytesPerRow: 0, space: space, bitmapInfo: bitmapInfo) {
            
            ctx.concatenate(transform)
            
            switch imageOrientation {
                
            case .left, .leftMirrored, .right, .rightMirrored:
                ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
                
            default:
                ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            }
            
            if let finalImage = ctx.makeImage() {
                return (UIImage(cgImage: finalImage))
            }
        }
        
        // something failed -- return original
        return self
    }
    
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}
