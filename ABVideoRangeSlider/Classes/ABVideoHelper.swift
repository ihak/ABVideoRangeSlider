//
//  ABVideoHelper.swift
//  selfband
//
//  Created by Oscar J. Irun on 27/11/16.
//  Copyright © 2016 appsboulevard. All rights reserved.
//

import UIKit
import AVFoundation

class ABVideoHelper: NSObject {

    static func thumbnailFromVideo(videoUrl: URL, time: CMTime) -> UIImage{
        let asset: AVAsset = AVAsset(url: videoUrl) as AVAsset
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.appliesPreferredTrackTransform = true
        do{
            let cgImage = try imgGenerator.copyCGImage(at: time, actualTime: nil)
            let uiImage = UIImage(cgImage: cgImage)
            return uiImage
        }catch{
            
        }
        return UIImage()
    }
    
    static func videoDuration(videoURL: URL) -> Float64{
        let source = AVURLAsset(url: videoURL)
        return CMTimeGetSeconds(source.duration)
    }
    
    static func trimVideo(atURL url:URL, withStartTime start: Double, duration: Double, handler: @escaping (_ outputUrl: URL, _ error: Error?)-> Void) {
        let asset = AVURLAsset(url: url)
        let exportSession = AVAssetExportSession.init(asset: asset, presetName: AVAssetExportPresetHighestQuality)!
        let outputURL = URL(fileURLWithPath: NSTemporaryDirectory() + "output.mp4")
        
        // Remove existing one
        do {
            try FileManager.default.removeItem(at: outputURL)
        }
        catch {
        }
        
        exportSession.outputURL = outputURL
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.outputFileType = AVFileTypeMPEG4
        let start = CMTime(seconds: start, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let duration = CMTime(seconds: duration, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let range = CMTimeRangeMake(start, duration)
        exportSession.timeRange = range
        exportSession.exportAsynchronously {
            switch(exportSession.status) {
            case .completed:
                handler(outputURL, nil)
            case .failed:
                handler(outputURL, exportSession.error)
            case .cancelled:
                handler(outputURL, exportSession.error)
            default: break
            }
        }
    }
}
