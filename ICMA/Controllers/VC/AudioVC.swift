//
//  AudioVC.swift
//  ICMA
//
//  Created by Ucreate on 12/10/21.
//

import UIKit
import AVFoundation
import MediaPlayer

class AudioVC: UIViewController {
    var music = String()
    var bgImg = String()
    var musicTitle = String()
    var iscommingfrom:Bool?
    var fromAppDelegate: String?
    var isPlaying = false
    var isdrig = false
    var timer:Timer!
    var fromIntro = false
    var closeTapped:(()->Void)?
    @IBOutlet weak var sliderValue: UISlider!
    @IBOutlet weak var lblEndTime: ICMediumLabel!
    @IBOutlet weak var lblStartTime: ICMediumLabel!
    @IBOutlet weak var lblTitle: ICMediumLabel!
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var playPauseImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblTitle.text = musicTitle
       // sliderValue.minimumValue = 0
        sliderValue.isContinuous = false
        MediaPlayerManager.shared.delegate = self
        MediaPlayerManager.shared.stop()
        MediaPlayerManager.shared.play(withURL: music)
        self.playPauseImg.image = UIImage(named: "crlcpause")
        self.imgMain.sd_setImage(with: URL(string: bgImg), placeholderImage: UIImage(named: "placehldr"))
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSlider(_ sender: UISlider) {
        let audioUrl = music
        if MediaPlayerManager.shared.isPlaying(on: audioUrl){
            let seconds : Int64 = Int64(sender.value)
            let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
            MediaPlayerManager.shared.audioPlayer.seek(to: targetTime)
        }else{
            MediaPlayerManager.shared.play(withURL: audioUrl)
        }
    }
    
    @objc func musicProgress()  {
       // self.sliderValue.progress = normalizedTime
        //self.sliderValue.p
        
    }
    
    @IBAction func btnClose(_ sender: Any) {
        MediaPlayerManager.shared.stop()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBckwrd(_ sender: Any) {
        let player = MediaPlayerManager.shared.audioPlayer
        let currentTime = CMTimeGetSeconds(player.currentTime())
        var newTime = currentTime - 5.0
        if newTime < 0{
            newTime = 0
        }
        let targetTime:CMTime = CMTimeMake(value: Int64(newTime), timescale: 1)
        MediaPlayerManager.shared.audioPlayer.seek(to: targetTime)
    }
   
    
    
    @IBAction func btnForward(_ sender: Any) {
        let player = MediaPlayerManager.shared.audioPlayer
        guard let duration = player.currentItem?.duration else { return }
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let newTime = currentTime + 5.0
        if newTime < (CMTimeGetSeconds(duration) - 5.0){
            let targetTime:CMTime = CMTimeMake(value: Int64(newTime), timescale: 1)
            MediaPlayerManager.shared.audioPlayer.seek(to: targetTime)
        }
    }
    
    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider) {
        let seconds : Int64 = Int64(sliderValue.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        MediaPlayerManager.shared.audioPlayer.seek(to: targetTime)
        if MediaPlayerManager.shared.audioPlayer.rate == 0 {
            MediaPlayerManager.shared.audioPlayer.play()
        }
    }
    
    @IBAction func btnPlay(_ sender: Any) {
        let audioUrl = self.music
        if MediaPlayerManager.shared.isPause() && MediaPlayerManager.shared.isPlaying(on: audioUrl) {
            debugPrint("existing play")
            MediaPlayerManager.shared.resume()
            playPauseImg.image = UIImage(named: "crlcpause")
          //  musicindicator.stopAnimating()
           // musicindicator.isHidden = true
        }else if MediaPlayerManager.shared.isPlaying() && MediaPlayerManager.shared.isPlaying(on: audioUrl) {
            debugPrint("existing pause")
            MediaPlayerManager.shared.puase()
          //  musicindicator.stopAnimating()
           // musicindicator.isHidden = true
            playPauseImg.image = UIImage(named: "crlcplay")
        } else {
            debugPrint("new play")
            MediaPlayerManager.shared.play(withURL: audioUrl)
            playPauseImg.image = UIImage(named: "crlcpause")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: PMNotificationName.startSleepTimer.rawValue), object: nil)
        }
    }
}
extension AudioVC: MediaPlayerManagerDelegate{
    func mediaPlayer(manager: MediaPlayerManager, didFailed error: ErrorModal) {
        print(error.message)
       print("start...")
        self.setCellToInitialState()
    }
    
    func mediaPlayer(manager: MediaPlayerManager, currentPlayingAt second: TimeInterval) {
        //
        if let durationCmtime = manager.audioPlayer.currentItem?.asset.duration{
            let duration = CMTimeGetSeconds(durationCmtime)
          //  self.sliderValue.setProgress(Float(second/duration), animated: false)
       // self.sliderValue.value = Float(second/duration)
            self.sliderValue.value = Float(second)
            print(Mains().convertToHMS(number: Int(second)))
            self.lblStartTime.text = Mains().convertToHMS(number: Int(second))
           // sliderValue.addTarget(self, action: #selector(playbackSliderValueChanged(_:)), for: .valueChanged)
        }
       // lblStartTime.text = Mains().convertToHMS(number: Int(second))
    }
    
    func mediaPlayer(manager: MediaPlayerManager, didFinishPlayingSuccessfully flag: Bool) {
        
    }
    func completedPlaying(manager: MediaPlayerManager) {
        MediaPlayerManager.shared.stop()
        self.setCellToInitialState()
    }
    
    func loadedAndReadyToPlay(manager: MediaPlayerManager) {
       // musicindicator.stopAnimating()
       // musicindicator.isHidden = true
        if let durationCmtime = manager.audioPlayer.currentItem?.asset.duration{
            let duration = CMTimeGetSeconds(durationCmtime)
            self.sliderValue.maximumValue = Float(duration)
            print(Mains().convertToHMS(number: Int(duration)))
            lblEndTime.text = Mains().convertToHMS(number: Int(duration))
        }else {
            self.CustomAlert(title: "ICMA", message: "Time_up")
           // self.presentSimpleAlert(withTitle: "Forgivity", andMessage: "TIme_up")
        }
    }
    func setCellToInitialState(){
        lblStartTime.text = Mains().convertToHMS(number: 0)
        sliderValue.value = 0
        playPauseImg.image = UIImage(named: "crlcplay")
        //pausePlayBtn.setImage(UIImage(named: "play"), for: .normal)
       // loaderView.stopAnimating()
    }
    
}
