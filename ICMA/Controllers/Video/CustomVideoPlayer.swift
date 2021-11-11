//
//  CustomVideoPlayer.swift
//  ICMA
//
//  Created by Vivek Dharmani on 10/11/21.
//

import UIKit
import Foundation
import SDWebImage
import AVFoundation

class CustomVideoPlayer : UIViewController {
    //------------------------------------------------------
    var data = String()
    var timeObserver: Any?
    var timer: Timer?
    //------------------------------------------------------
    @IBOutlet weak var playPauseBtn: UIButton!
    var isPlaying = false
    @IBOutlet weak var imgPlaceholder: UIImageView!
    @IBOutlet weak var valueSlider: UISlider!
    @IBOutlet weak var lblEndTime: ICMediumLabel!
    @IBOutlet weak var lblStartTime: ICMediumLabel!
    @IBOutlet weak var imgplayPause: UIImageView!
    @IBOutlet weak var videoPlayerVw: PlayerView!
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateVideoPlayerSlider()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleControls))
        view.addGestureRecognizer(tapGesture)
    }
    
   
    @objc func toggleControls() {
        imgplayPause.isHidden = !imgplayPause.isHidden
        valueSlider.isHidden = !valueSlider.isHidden
        lblStartTime.isHidden = !lblStartTime.isHidden
        playPauseBtn.isHidden = !playPauseBtn.isHidden
        lblEndTime.isHidden = !lblEndTime.isHidden
       // titleLabel.isHidden = !titleLabel.isHidden
        resetTimer()
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(hideControls), userInfo: nil, repeats: false)
    }
    
    @objc func hideControls() {
        valueSlider.isHidden = true
        lblStartTime.isHidden = true
        imgplayPause.isHidden = true
        playPauseBtn.isHidden = true
        lblEndTime.isHidden = true
        
    }
    
    func configureUI(){
        if let url = URL(string: data){
            let avPlayer = AVPlayer(url: url)
            avPlayer.automaticallyWaitsToMinimizeStalling = false
            self.videoPlayerVw.playerLayer.videoGravity = .resizeAspectFill
            self.videoPlayerVw?.playerLayer.player = avPlayer
            self.imgPlaceholder.isHidden = true
            self.videoPlayerVw.playerLayer.player?.play()
            resetTimer()
            let interval = CMTime(seconds: 0.01, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            timeObserver = videoPlayerVw.playerLayer.player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { elapsedTime in
                self.updateVideoPlayerSlider()
                self.updateVideoPlayerState()
            })
        }
    }
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
    @IBAction func crossBtnTapped(_ sender: UIButton) {
    self.videoPlayerVw.playerLayer.player?.pause()
    self.navigationController?.popViewController(animated: true)
    }
    @IBAction func playPauseBtnTapped(_ sender: UIButton) {
        if isPlaying == false {
            self.videoPlayerVw.playerLayer.player?.pause()
            isPlaying = true
            imgplayPause.image = UIImage(named: "crlcplay")
        } else {
            self.videoPlayerVw.playerLayer.player?.play()
            isPlaying = false
            imgplayPause.image = UIImage(named: "crlcpause")
        }
    }
    @IBAction func valueSliderMoved(_ sender: UISlider) {
        guard let duration = videoPlayerVw.playerLayer.player?.currentItem?.duration else { return }
           let value = Float64(valueSlider.value) * CMTimeGetSeconds(duration)
           let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
        videoPlayerVw.playerLayer.player?.seek(to: seekTime )
    }
    func updateVideoPlayerSlider() {
        guard let currentTime = videoPlayerVw.playerLayer.player?.currentTime() else { return }
        let currentTimeInSeconds = CMTimeGetSeconds(currentTime)
        valueSlider.value = Float(currentTimeInSeconds)
        if let currentItem = videoPlayerVw.playerLayer.player?.currentItem {
            let duration = currentItem.duration
            if (CMTIME_IS_INVALID(duration)) {
                return;
            }
            let currentTime = currentItem.currentTime()
            valueSlider.value = Float(CMTimeGetSeconds(currentTime) / CMTimeGetSeconds(duration))
        }
    }
    func updateVideoPlayerState() {
        guard let currentTime = videoPlayerVw.playerLayer.player?.currentTime() else { return }
        let currentTimeInSeconds = CMTimeGetSeconds(currentTime)
        valueSlider.value = Float(currentTimeInSeconds)
        if let currentItem = videoPlayerVw.playerLayer.player?.currentItem {
            let duration = currentItem.duration
            if (CMTIME_IS_INVALID(duration)) {
                return;
            }
            let currentTime = currentItem.currentTime()
            valueSlider.value = Float(CMTimeGetSeconds(currentTime) / CMTimeGetSeconds(duration))
            // Update time remaining label
            let currentTimeInSeconds = currentTimeInSeconds
            let mins = currentTimeInSeconds / 60
            let secs = currentTimeInSeconds.truncatingRemainder(dividingBy: 60)
            let timeformatter = NumberFormatter()
            timeformatter.minimumIntegerDigits = 2
            timeformatter.minimumFractionDigits = 0
            timeformatter.roundingMode = .down
            guard let minsStr = timeformatter.string(from: NSNumber(value: mins)), let secsStr = timeformatter.string(from: NSNumber(value: secs)) else {
                return
            }
            lblStartTime.text = "\(minsStr):\(secsStr)"
            // duration time
            let durationTime = CMTimeGetSeconds(duration)
            let min = durationTime / 60
            let sec = durationTime.truncatingRemainder(dividingBy: 60)
            let timeformatters = NumberFormatter()
            timeformatters.minimumIntegerDigits = 2
            timeformatters.minimumFractionDigits = 0
            timeformatters.roundingMode = .down
            guard let mint = timeformatters.string(from: NSNumber(value: min)), let secsStrs = timeformatter.string(from: NSNumber(value: sec)) else {
                return
            }
            lblEndTime.text = "\(mint):\(secsStrs)"
        }
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    
}

