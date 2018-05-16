//
//  ABThumbnailsHelper.swift
//  selfband
//
//  Created by Oscar J. Irun on 27/11/16.
//  Copyright © 2016 appsboulevard. All rights reserved.
//

import UIKit
import AVFoundation

let THUMBNAILS_CONTAINER = 999999

class ABThumbnailsManager: NSObject {
    private func addImagesToView(images: [UIImage], view: UIView){
        var xPos: CGFloat = 0.0
        var width: CGFloat = 0.0
        for image in images{
            DispatchQueue.main.async {
                if xPos + view.frame.size.height < view.frame.width{
                    width = view.frame.size.height
                }else{
                    width = view.frame.size.width - xPos
                }
                
                let imageView = UIImageView(image: image)
                imageView.alpha = 0
                imageView.contentMode = UIViewContentMode.scaleAspectFill
                imageView.clipsToBounds = true
                imageView.frame = CGRect(x: xPos,
                                         y: 0.0,
                                         width: width,
                                         height: view.frame.size.height)
                
                view.addSubview(imageView)
                UIView.animate(withDuration: 0.2, animations: {() -> Void in
                    imageView.alpha = 1.0
                })
                view.sendSubview(toBack: imageView)
                xPos = xPos + view.frame.size.height
            }
        }
    }
    
    private func add(image: UIImage, toView view: UIView, atPosition position: Int) {
        var xPos: CGFloat = 0.0
        var width: CGFloat = 0.0
        
        DispatchQueue.main.async {
            xPos = CGFloat(position) * view.frame.size.height
            width = view.frame.size.height
            
            let imageView = UIImageView(image: image)
            imageView.alpha = 0
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.frame = CGRect(x: xPos, y: 0.0, width: width, height: view.frame.size.height)
            
            view.addSubview(imageView)
            UIView.animate(withDuration: 0.2, animations: {
                imageView.alpha = 1.0
            })
            view.sendSubview(toBack: imageView)
        }
    }
    
    private func thumbnailCount(inView: UIView) -> Int {
		
		var num : Double = 0;
		
		DispatchQueue.main.sync {
        	num = Double(inView.frame.size.width) / Double(inView.frame.size.height)
		}

        return Int(ceil(num))
    }
    
    func updateThumbnails(view: UIView, videoURL: URL, duration: Float64) {
        var thumbnailsContainer: UIView?
        var thumbnails = [UIImage]()
        var offset: Float64 = 0
        
        DispatchQueue.main.async {
            if let container = view.viewWithTag(THUMBNAILS_CONTAINER) {
                thumbnailsContainer = container
                thumbnailsContainer?.frame = view.bounds
                _ = thumbnailsContainer?.subviews.map({ (view) in
                    view.removeFromSuperview()
                })
            }
            else {
                thumbnailsContainer = UIView()
                thumbnailsContainer?.tag = THUMBNAILS_CONTAINER
                thumbnailsContainer?.frame = view.bounds
                thumbnailsContainer?.clipsToBounds = true
                view.addSubview(thumbnailsContainer!)
                view.sendSubview(toBack: thumbnailsContainer!)
            }
        }
        
        
        let imagesCount = self.thumbnailCount(inView: view)
        
        for i in 0..<imagesCount{
            let thumbnail = ABVideoHelper.thumbnailFromVideo(videoUrl: videoURL,
                                                             time: CMTimeMake(Int64(offset), 1))
            offset = Float64(i) * (duration / Float64(imagesCount))
            thumbnails.append(thumbnail)
            self.add(image: thumbnail, toView: thumbnailsContainer!, atPosition: i)
        }
    }
}
