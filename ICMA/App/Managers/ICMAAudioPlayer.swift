//
//  ICMAAudioPlayer.swift
//  ICMA
//
//  Created by Vivek Dharmani on 08/11/21.
//

import AVFoundation
import MediaPlayer

protocol MediaPlayerManagerDelegate {
    func mediaPlayer(manager: MediaPlayerManager, didFailed error: ErrorModal)
    func mediaPlayer(manager: MediaPlayerManager, currentPlayingAt second: TimeInterval)
    func mediaPlayer(manager: MediaPlayerManager, didFinishPlayingSuccessfully flag: Bool)
    func completedPlaying(manager: MediaPlayerManager)
    func loadedAndReadyToPlay(manager: MediaPlayerManager)
}
class MediaPlayerManager: NSObject, AVAudioPlayerDelegate {
    var delegate: MediaPlayerManagerDelegate?
    public let audioPlayer: AVPlayer = {
           let avPlayer = AVPlayer()
           avPlayer.automaticallyWaitsToMinimizeStalling = false
           return avPlayer
       }()
    
    public private(set) var episodeFile: URL? = nil
    public var isDraging: Bool = false

    
    private var stopPlayBackTimer: Timer?
    
    //------------------------------------------------------
    
    //MARK: Shared
    
    static let shared = MediaPlayerManager()
    
    //------------------------------------------------------
    
    //MARK: Customs
   
    fileprivate func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        audioPlayer.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            if self != nil {
                if self?.audioPlayer.status == .readyToPlay{
                    self?.delegate?.loadedAndReadyToPlay(manager: self!)
                }
                if self?.isDraging == false && self?.isPlaying() == true {
                    if CMTimeGetSeconds(time).isNaN {
                        self?.delegate?.mediaPlayer(manager: self!, currentPlayingAt: TimeInterval(0))
//                        MiniPlayerManager.shared.updatePlayer(currentTime: TimeInterval(0))
                    }
                    let totalSeconds = Int(CMTimeGetSeconds(time))
                    //let seconds = totalSeconds % 60
                    self?.delegate?.mediaPlayer(manager: self!, currentPlayingAt: TimeInterval(totalSeconds))
//                    MiniPlayerManager.shared.updatePlayer(currentTime: TimeInterval(totalSeconds))
                }
            }
        }
    }
    
//    func performLogPlayerDuration() {
//
//        let currentDuration = CMTimeGetSeconds(audioPlayer.currentTime())
//
//        if currentDuration.isNaN == false {
//
//            let totalSeconds = Int(currentDuration)
//
//            let parameter: [String: Any] = [
//                Request.Parameter.userId: RealmManager.shared.currentUser?.userID ?? String(),
//                Request.Parameter.episodeId: episode?.id ?? String(),
//                Request.Parameter.duration: totalSeconds,
//            ]
//
//            RequestManager.shared.requestPOST(requestMethod: Request.Method.logEpisodeDuration, isPodcast: false, parameter: parameter, showLoader: false, decodingType: BaseResponseModal.self, successBlock: { (response: BaseResponseModal) in
//
//                //Not to do anything.
//
//            }, failureBlock: { (error: ErrorModal) in
//
//                delay {
//                    DisplayAlertManager.shared.displayAlert(animated: true, message: error.errorDescription, handlerOK: nil)
//                }
//            })
//        }
//    }
    
    //------------------------------------------------------
    
    //MARK: Public
    
    public func play(withURL stringURL: String) {
        
        do {
//            performLogPlayerDuration()
            
            audioPlayer.pause()
            
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            guard let fileURL = URL(string: stringURL) else {
                let errorModal = ErrorModal(message: "Invalid Url")
//                let errorModal = ErrorModal(code: PodmanyError.InvalidURL._code, errorDescription: PodmanyError.InvalidURL.localizedDescription)
                delegate?.mediaPlayer(manager: self, didFailed: errorModal)
                return
            }
                        
            let playerItem = AVPlayerItem(url: fileURL)
            episodeFile = fileURL
            audioPlayer.replaceCurrentItem(with: playerItem)
            NotificationCenter.default.addObserver(self, selector: #selector(playingEnd), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            audioPlayer.play()
            audioPlayer.volume = 1.0
            observePlayerCurrentTime()
                        
//            MiniPlayerManager.shared.showPlayer()
//            MiniPlayerManager.shared.updatePlayerFrame()
            
        } catch(let error) {
            debugPrint(error.localizedDescription)
            let errorModal = ErrorModal(error: error, message: error.localizedDescription)
            delegate?.mediaPlayer(manager: self, didFailed: errorModal)
            return
        }
    }
    
    @objc func playingEnd(){
        delegate?.completedPlaying(manager: self)
    }
    
    public func isPlaying(on stringURL: String) -> Bool {
        
        guard let fileURL = URL(string: stringURL) else {
            return false
        }
        
        if fileURL == episodeFile {
            return true
        }
        return false
    }
    
    public func isPlaying() -> Bool {
        return audioPlayer.timeControlStatus == .playing || audioPlayer.timeControlStatus == .waitingToPlayAtSpecifiedRate
    }
    
    public func isPause() -> Bool {
        return audioPlayer.timeControlStatus == .paused
    }
    
    public func puase() {
        audioPlayer.pause()
    }
    
    public func resume() {
        audioPlayer.play()
    }
    
    public func stop() {
        
//        performLogPlayerDuration()
        
        audioPlayer.pause()
        let seekTime = CMTimeMakeWithSeconds(0, preferredTimescale: 1)
        audioPlayer.seek(to: seekTime)
        
//        MiniPlayerManager.shared.isPlayerController(enable: false)
//        MiniPlayerManager.shared.set(isPlaying: false)
    }
    
    public func player(playAt time: TimeInterval) {
        
        isDraging = true
        let percentage = time
        guard let duration = audioPlayer.currentItem?.duration else { return }
                 
        debugPrint("duration:\(duration)")
        let durationInSeconds = CMTimeGetSeconds(duration)
        debugPrint("time:\(time)")
        debugPrint("durationInSeconds:\(durationInSeconds)")
        
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)

        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = seekTimeInSeconds
        audioPlayer.seek(to: seekTime)
        
        if isPause() == false {
            audioPlayer.play()
        } else {
            let totalSeconds = Int(CMTimeGetSeconds(seekTime))
            delegate?.mediaPlayer(manager: self, currentPlayingAt: TimeInterval(totalSeconds))
//            MiniPlayerManager.shared.updatePlayer(currentTime: TimeInterval(totalSeconds))
        }
    }
    
    //------------------------------------------------------
    
    //MARK: AVAudioPlayerDelegate
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
//        performLogPlayerDuration()
        print("finished playing")
        delegate?.mediaPlayer(manager: self, didFinishPlayingSuccessfully: flag)
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        
        if let error = error {
            debugPrint(error.localizedDescription)
//            let errorModal = ErrorModal(code: error._code, errorDescription: error.localizedDescription)
            let errorModal = ErrorModal(error: error, message: error.localizedDescription)
            delegate?.mediaPlayer(manager: self, didFailed: errorModal)
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Notification
    
    @objc func fireSleepTime(_ sender: Any) {
        
        stopPlayBackTimer?.invalidate()
        stop()
        NotificationCenter.default.post(name: NSNotification.Name(PMNotificationName.playerPlayModeChange.rawValue), object: nil)
    }
    
    @objc func startSleepTimer(_ notification: Notification) {
        stopPlayBackTimer?.invalidate()
//        let sleepTime = RealmManager.shared.findSleepTimeObjectOf(episodeId: episode?.id ?? String())?.sleepTime
//        let minutes: Int = Int(sleepTime?.replacingOccurrences(of: "m", with: "") ?? "0") ?? 0
//        if minutes != 0 {
//            let seconds = minutes * 60
//            stopPlayBackTimer = Timer.scheduledTimer(timeInterval: TimeInterval(seconds), target: self, selector: #selector(fireSleepTime(_:)), userInfo: nil, repeats: false)
//        }
    }
    
    //------------------------------------------------------
    
    //MARK: Init
    override init() {
        super.init()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: PMNotificationName.startSleepTimer.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startSleepTimer), name: NSNotification.Name(rawValue: PMNotificationName.startSleepTimer.rawValue), object: nil)
    }
    //------------------------------------------------------
}

struct ErrorModal{
    var error: Error?
    var message: String
}

enum PMNotificationName: String {
    case updateMyInterests = "updateMyInterests"
    case updateFeature = "updateFeature"
    case playerPlayModeChange = "playerPlayModeChange"
    case startSleepTimer = "startSleepTimer"
}

