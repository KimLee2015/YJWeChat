//
//  AudioPlayerManager.swift
//  TSWeChat
//
//  Created by Lee on 12/22/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import Foundation
import AVFoundation
import Alamofire
import TSVoiceConverter

let AudioPlayInstance = AudioPlayManager.sharedInstance

class AudioPlayManager: NSObject {
  fileprivate var audioPlayer: AVAudioPlayer?
  weak var delegate: PlayAudioDelegate?
  
  class var sharedInstance : AudioPlayManager {
    struct Static {
      static let instance : AudioPlayManager = AudioPlayManager()
    }
    return Static.instance
  }
  
  fileprivate override init() {
    super.init()
    //监听听筒和扬声器
    let notificationCenter = NotificationCenter.default
    notificationCenter.ts_addObserver(self, name: NSNotification.Name.UIDeviceProximityStateDidChange.rawValue, object: UIDevice.current, handler: {
        observer, notification in
      if UIDevice.current.proximityState {
        do {
          try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch _ {}
      } else {
        do {
          try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch _ {}
      }
    })
  }
  
  // MARK: - public
  func startPlaying(_ audioModel: ChatAudioModel) {
    if AVAudioSession.sharedInstance().category == AVAudioSessionCategoryRecord {
      do {
          try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
      } catch _ {}
    }
    let hasKeyHash = audioModel.keyHash != nil && audioModel.keyHash?.length != 0;
    let hasAudioURL = audioModel.audioURL != nil && audioModel.audioURL?.length != 0;
    if !hasKeyHash && !hasAudioURL {
      self.delegate?.audioPlayFailed()
      return
    }
    if hasKeyHash {
      let keyHash = audioModel.keyHash!
      let wavFilePath = AudioFilesManager.wavPathWithName(keyHash)
      if FileManager.default.fileExists(atPath: wavFilePath.path) { // 已有 wav 文件，直接播放
        self.playSoundWithPath(wavFilePath.path)
        return
      }
      let amrFilePath = AudioFilesManager.amrPathWithName(keyHash)
      if FileManager.default.fileExists(atPath: amrFilePath.path) { // 已有 amr 文件，转换，再进行播放
        self.convertAmrToWavAndPlaySound(audioModel)
        return
      }
    }else {
      let audioPath = Bundle.main.path(forResource: audioModel.audioURL!, ofType: "wav")
      self.playSoundWithPath(audioPath!);
    }
  }
  
  func stopPlayer() {
    if self.audioPlayer == nil {
      return
    }
    self.audioPlayer!.delegate = nil
    self.audioPlayer!.stop()
    self.audioPlayer = nil
    UIDevice.current.isProximityMonitoringEnabled = false
  }
  
  // MARK: - private
  // AVAudioPlayer 只能播放 wav 格式，不能播放 amr
  fileprivate func playSoundWithPath(_ path: String) {
    let fileData = try? Data(contentsOf: URL(fileURLWithPath: path))
    do {
      self.audioPlayer = try AVAudioPlayer(data: fileData!)
      
      guard let player = self.audioPlayer else { return }
      
      player.delegate = self
      player.prepareToPlay()
      
      guard let delegate = self.delegate else {
        log.error("delegate is nil")
        return
      }
      
      if player.play() {
        UIDevice.current.isProximityMonitoringEnabled = true
        delegate.audioPlayStart()
      } else {
        delegate.audioPlayFailed()
      }
    } catch {
      self.destroyPlayer()
    }
  }
  
  // 转换，并且播放声音
  fileprivate func convertAmrToWavAndPlaySound(_ audioModel: ChatAudioModel) {
    if self.audioPlayer != nil {
      self.stopPlayer()
    }
    guard let fileName = audioModel.keyHash, fileName.length > 0 else { return }
    let amrPath = AudioFilesManager.amrPathWithName(fileName).path
    let wavPath = AudioFilesManager.wavPathWithName(fileName).path
    if FileManager.default.fileExists(atPath: wavPath) {
      self.playSoundWithPath(wavPath)
    } else {
      if TSVoiceConverter.convertAmrToWav(amrPath, wavSavePath: wavPath) {
        self.playSoundWithPath(wavPath)
      } else {
        if let delegate = self.delegate {
          delegate.audioPlayFailed()
        }
      }
    }
  }
  
  // 使用 Alamofire 下载并且存储文件
  fileprivate func downloadAudio(_ audioModel: ChatAudioModel) {
    let fileName = audioModel.keyHash!
    let filePath = AudioFilesManager.amrPathWithName(fileName)
    Alamofire.download(audioModel.audioURL!)
      .downloadProgress { progress in
        print("Download Progress: \(progress.fractionCompleted)")
      }
      .responseData { response in
        if let error = response.result.error, let delegate = self.delegate {
          log.error("Failed with error: \(error)")
          delegate.audioPlayFailed()
        } else {
          log.info("Downloaded file successfully")
          self.convertAmrToWavAndPlaySound(audioModel)
        }
    }
  }
  
  fileprivate func destroyPlayer() {
    self.stopPlayer()
  }
}

extension AudioPlayManager: AVAudioPlayerDelegate {
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    log.info("Finished playing the song")
    UIDevice.current.isProximityMonitoringEnabled = false
    if flag {
        self.delegate?.audioPlayFinished()
    } else {
        self.delegate?.audioPlayFailed()
    }
    self.stopPlayer()
  }
  
  func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
    self.stopPlayer()
    self.delegate?.audioPlayFailed()
  }
  
  func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
    self.stopPlayer()
    self.delegate?.audioPlayFailed()
  }
  
  func audioPlayerEndInterruption(_ player: AVAudioPlayer, withOptions flags: Int) {}
}











