//
//  UIImage + VSAdditions.swift
//  VogueShopSwift
//
//  Created by wanming zhang on 10/20/16.
//  Copyright © 2016 Wanming Zhang. All rights reserved.
//

import UIKit
import CoreFoundation
import CoreGraphics

extension UIImage {
    // Returns a copy of this image that is cropped to the given bounds.
    // The bounds will be adjusted using CGRectIntegral.
    // This method ignores the image's imageOrientation setting.
//    - (CSImage *)croppedImage:(CGRect)bounds {
//    CGFloat scale = MAX(self.scale, 1.0f);
//    CGRect scaledBounds = CGRectMake(bounds.origin.x * scale, bounds.origin.y * scale, bounds.size.width * scale, bounds.size.height * scale);
//    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], scaledBounds);
//    CSImage * croppedImage = [CSImage imageWithCGImage:imageRef scale:self.scale orientation:UIImageOrientationUp];
//    CGImageRelease(imageRef);
//    
//    return croppedImage;
//    }
//    
    // Returns a copy of this image that is tinted with color.
    func imageWith(color: UIColor) -> UIImage? {
        let width : CGFloat = self.size.width
        let height : CGFloat = self.size.height
        let rect : CGRect = CGRect(x: 0, y: 0, width: width, height: height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor);
        context?.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
    
    func tintWith(color: UIColor) -> UIImage {

        let imageToTint : CGImage? = self.cgImage
        let width : CGFloat = self.size.width
        let height : CGFloat = self.size.height
        let bounds : CGRect = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace : CGColorSpace = CGColorSpaceCreateDeviceRGB()
        
        let bitsPerComponent = 8 /* bits per channel */
        let bytesPerPixel : CGFloat = 4 /* 4 channels per pixel * numPixels/row */
        let bytesPerRow = bounds.size.width * bytesPerPixel
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        let bitmapContext = CGContext(data: nil,
                                     width: Int(width),
                                    height: Int(height),
                          bitsPerComponent: bitsPerComponent,
                               bytesPerRow: Int(bytesPerRow),
                                     space: colorSpace,
                                bitmapInfo: bitmapInfo)
        
       
        bitmapContext!.clip(to: bounds, mask: imageToTint!)
        bitmapContext!.setFillColor(color.cgColor);
        bitmapContext!.fill(bounds)
        
        let cImage : CGImage  = bitmapContext!.makeImage()!;
        let tintedImage : UIImage = UIImage(cgImage: cImage)
        
        return tintedImage
        
    }
    
    // Resizes the image according to the given content mode, taking into account the image's orientation
    
    func resizedImageWithContentMode(contentMode : UIViewContentMode, bounds : CGSize, interpolationQuality : CGInterpolationQuality) -> UIImage {
        
        let horizontalRatio : CGFloat = bounds.width / self.size.width
        let verticalRatio : CGFloat = bounds.height / self.size.height
        var ratio : CGFloat = 1.0
        switch contentMode {
        case UIViewContentMode.scaleAspectFill:
            ratio = max(horizontalRatio, verticalRatio)
        case UIViewContentMode.scaleAspectFit:
            ratio = min(horizontalRatio, verticalRatio)
        default:
            let error : NSError? = nil
             NSException.raise(NSExceptionName(rawValue: "Exception"), format:"Unsupported content mode: \(contentMode)",  arguments:getVaList([error ?? "nil"]))
        }
        
        let newSize : CGSize = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)
        return self.resizedImage(newSize: newSize, interpolationQuality: interpolationQuality)
    }
    
    // Returns a rescaled copy of the image, taking into account its orientation
    // The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter
    func resizedImage(newSize : CGSize, interpolationQuality quality : CGInterpolationQuality) -> UIImage {
        var drawTransPosed : Bool
        switch self.imageOrientation {
        case UIImageOrientation.left,
             UIImageOrientation.leftMirrored,
             UIImageOrientation.right,
             UIImageOrientation.rightMirrored:
            drawTransPosed = true
        default:
            drawTransPosed = false
        }
        
        let transform : CGAffineTransform = self.transformForOrientation(newSize: newSize)
        return self.resizedImage(newSize: newSize, transform: transform, drawTransPosed: drawTransPosed, interpolationQualicy: quality)
    }
    
    // Returns a copy of the image that has been transformed using the given affine transform and scaled to the new size
    // The new image's orientation will be UIImageOrientationUp, regardless of the current image's orientation
    // If the new size is not integral, it will be rounded up
    
    func resizedImage(newSize : CGSize, transform : CGAffineTransform, drawTransPosed : Bool, interpolationQualicy : CGInterpolationQuality) -> UIImage {
        let scale : CGFloat = max(1.0, self.scale)
        let newRect : CGRect = CGRect(x: 0, y: 0, width: newSize.width * scale, height: newSize.height * scale).integral
        let transposedRect : CGRect = CGRect(x: 0, y: 0, width: newRect.size.height, height: newRect.size.width)
        
        let colorSpace : CGColorSpace = CGColorSpaceCreateDeviceRGB()
        
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        
        let bitsPerComponent = 8 /* bits per channel */
        let bytesPerPixel : CGFloat = 4 /* 4 channels per pixel * numPixels/row */
        let bytesPerRow = newRect.size.width * bytesPerPixel
        let imageContext = CGContext(data: nil,
                                    width: Int(newRect.size.width),
                                   height: Int(newRect.size.height),
                         bitsPerComponent: bitsPerComponent,
                              bytesPerRow: Int(bytesPerRow),
                                    space: colorSpace,
                               bitmapInfo: bitmapInfo,
                          releaseCallback: nil,
                              releaseInfo: nil)
        
        
        // Rotate and/or flip the image if required by its orientation
        imageContext!.concatenate(transform);
        
        // Set the quality level to use when rescaling
        imageContext!.interpolationQuality = interpolationQualicy;
    
        // Draw into the context; this scales the image
        imageContext?.draw(self.cgImage!, in: drawTransPosed ? transposedRect : newRect)
        
        
        // Get the resized image from the context and a UIImage
        let newCGImage = imageContext!.makeImage()
        let newImage : UIImage = UIImage(cgImage: newCGImage!, scale: self.scale, orientation: UIImageOrientation.up)
        
        return newImage;
}
    

    
    
    // Returns an affine transform that takes into account the image orientation when drawing a scaled image
    func transformForOrientation(newSize : CGSize) -> CGAffineTransform {
        var transform : CGAffineTransform = CGAffineTransform.identity
        switch self.imageOrientation {
        case UIImageOrientation.down,            // EXIF = 3
             UIImageOrientation.downMirrored:    // EXIF = 4
                transform = transform.translatedBy(x: newSize.width, y: newSize.height)
                transform = transform.rotated(by: CGFloat(M_PI))
        
        case UIImageOrientation.left,            // EXIF = 6
             UIImageOrientation.leftMirrored:    // EXIF = 5
            transform = transform.translatedBy(x: newSize.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
        
        case UIImageOrientation.right,
             UIImageOrientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: newSize.height)
            transform = transform.rotated(by: CGFloat(-M_PI_2))

        default:
           break
        }
        
        switch (self.imageOrientation) {
        case UIImageOrientation.upMirrored,      // EXIF = 2
             UIImageOrientation.downMirrored:    // EXIF = 4
            transform = transform.translatedBy(x: newSize.width, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
        
        case UIImageOrientation.leftMirrored,       // EXIF = 5
             UIImageOrientation.rightMirrored:       // EXIF = 7
            transform = transform.translatedBy(x: newSize.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
            
        default:
            break
        }

        
        return transform
    }
    

}
