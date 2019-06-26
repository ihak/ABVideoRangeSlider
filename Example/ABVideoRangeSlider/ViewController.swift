//
//  ViewController.swift
//  ABVideoRangeSlider
//
//  Created by Oscar J. Irun on 27/11/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import ABVideoRangeSlider
import AVKit
import AVFoundation

class ViewController: UIViewController, ABVideoRangeSliderDelegate {

    @IBOutlet var videoRangeSlider: ABVideoRangeSlider!
    @IBOutlet weak var clipPositionLabel: UILabel!
    @IBOutlet weak var clipDurationLabel: UILabel!
    @IBOutlet weak var playerView: UIView!
    
    @IBOutlet weak var playPauseButtonImage: UIImageView!
    
    var player: AVPlayer!
    var timeObserverToken: Any?
    
    let path = Bundle.main.path(forResource: "test", ofType:"mp4")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupPlayer() {
        player = AVPlayer(url: URL(fileURLWithPath: path!))
        let layer = AVPlayerLayer(player: player)
        layer.backgroundColor = UIColor.clear.cgColor
        layer.frame = playerView.bounds
        layer.videoGravity = .resizeAspect
        playerView.layer.insertSublayer(layer, at: 0)
        
        addPeriodicTimeObserver()
    }
    
    func addPeriodicTimeObserver() {
        // Invoke callback every half second
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        // Queue on which to invoke the callback
        let mainQueue = DispatchQueue.main
        
        // Add time observer
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue) { time in
            self.videoRangeSlider.updateProgressIndicator(seconds: CMTimeGetSeconds(time))
        }
    }
    
    @IBAction func playVideo(_ sender: Any) {
        let player = AVPlayer(url: URL(fileURLWithPath: path!))
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        videoRangeSlider.setVideoURL(videoURL: URL(fileURLWithPath: path!))
        videoRangeSlider.delegate = self
        videoRangeSlider.minSpace = 60.0
        videoRangeSlider.maxSpace = 240.0

        
        // Set initial position of Start Indicator
        videoRangeSlider.setStartPosition(seconds: 0.0)
        
        // Set initial position of End Indicator
        videoRangeSlider.setEndPosition(seconds: 60.0)
        
        videoRangeSlider.startTimeView.isHidden = true
        videoRangeSlider.endTimeView.isHidden = true
        
        /* Uncomment to customize the Video Range Slider */
/*
        let customStartIndicator =  UIImage(named: "CustomStartIndicator")
        videoRangeSlider.setStartIndicatorImage(image: customStartIndicator!)
        
        let customEndIndicator =  UIImage(named: "CustomEndIndicator")
        videoRangeSlider.setEndIndicatorImage(image: customEndIndicator!)
        
        let customBorder =  UIImage(named: "CustomBorder")
        videoRangeSlider.setBorderImage(image: customBorder!)
         
        let customProgressIndicator =  UIImage(named: "CustomProgress")
        videoRangeSlider.setProgressIndicatorImage(image: customProgressIndicator!)
*/

        
      
        // Customize starTimeView
        let customView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: 60,
                                              height: 40))
        customView.backgroundColor = .black
        customView.alpha = 0.5
        customView.layer.borderColor = UIColor.black.cgColor
        customView.layer.borderWidth = 1.0
        customView.layer.cornerRadius = 8.0
        videoRangeSlider.startTimeView.backgroundView = customView
        videoRangeSlider.startTimeView.marginLeft = 2.0
        videoRangeSlider.startTimeView.marginRight = 2.0
        videoRangeSlider.startTimeView.timeLabel.textColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupPlayer()
    }
    
    @IBAction func playerViewTapped(_ sender: UITapGestureRecognizer) {
        playPauseButtonImage.alpha = 1
        
        if player.rate == 0.0 {
            player.play()
            playPauseButtonImage.image = #imageLiteral(resourceName: "play")
            
            UIView.animate(withDuration: 0.5) {
                self.playPauseButtonImage.alpha = 0
            }
        }
        else {
            player.pause()
            playPauseButtonImage.image = #imageLiteral(resourceName: "pause")
        }
    }
    
    // MARK: ABVideoRangeSlider Delegate - Returns time in seconds
    
    func didChangeValue(videoRangeSlider: ABVideoRangeSlider, startTime: Float64, endTime: Float64) {
        let component = DateComponents(calendar: Calendar(identifier: .gregorian), year: 1970, month: 1, day: 1, hour: 0, minute: 0, second: 0)
        
        let sinceDate = component.date!
        let start = Date(timeInterval: Double(startTime), since: sinceDate)
        let end = Date(timeInterval: Double(endTime), since: sinceDate)
        let duration = Date(timeInterval: Double(endTime-startTime), since: sinceDate)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm:ss"
        clipPositionLabel.text = "\(dateFormatter.string(from: start)) - \(dateFormatter.string(from:end))"
        clipDurationLabel.text = "\(dateFormatter.string(from: duration))"
        
    }
    
    func indicatorDidChangePosition(videoRangeSlider: ABVideoRangeSlider, position: Float64) {
        print("position of indicator: \(position)")
        player.seek(to: CMTimeMakeWithSeconds(position, preferredTimescale: 600))
    }

}
