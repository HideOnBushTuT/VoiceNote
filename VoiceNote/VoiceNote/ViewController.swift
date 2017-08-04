//
//  ViewController.swift
//  VoiceNote
//
//  Created by HideOnBush on 2017/8/3.
//  Copyright © 2017年 HideOnBush. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    /// 音频录音机
    fileprivate var audioRecoder: AVAudioRecorder? = nil
    
    /// 音频播放器
    fileprivate var audioPlayer: AVAudioPlayer? = nil
    
    /// 音频参数 编码格式、声音采集率、采集音轨、音频质量
    fileprivate let settings = [AVFormatIDKey: kAudioFormatMPEG4AAC,
                                AVSampleRateKey: NSNumber(value: Float(44100.0)),
                                AVNumberOfChannelsKey: NSNumber(value: 1),
                                AVEncoderAudioQualityKey: NSNumber(value: Int32(AVAudioQuality.medium.rawValue))
        ] as [String : Any]
    
    /// 计时器
    fileprivate var timer: Timer? = nil
    fileprivate var times: Int = 0
    fileprivate var currentDateTime: Date? = nil
    fileprivate var recordName: String? = nil
    fileprivate var recordURL: String? = nil
    //MARK: - 页面控件
    @IBOutlet weak var TimeRecordLable: UILabel!
    /// 记录按钮
    @IBOutlet weak var racordHistoryButton: UIBarButtonItem!
    
    /// 播放按钮
    @IBOutlet weak var playButton: UIButton!
    
    /// 录音按钮
    @IBOutlet weak var recordButton: UIButton!
    
    //MARK: - 控件点击事件
    /// 用于跳转到录音数据页面
    ///
    @IBAction func recordHistoryButtonClick(_ sender: UIBarButtonItem) {
        print("记录界面")
    }
    
    ///录音
    
    @IBAction func StartRecordClick(_ sender: UIButton) {
        setAudioSession()
        addTimer()
        if !(audioRecoder?.isRecording)! {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setActive(true)
                audioRecoder?.record()
                print("recording")
            } catch {
                
            }
            playButton.isEnabled = false
            times = 0
            timer?.fireDate = Date.distantPast
        }
    }
    
    @IBAction func StopRecordClick(_ sender: UIButton) {
        audioRecoder?.stop()
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setActive(false)
            print("stop")
        } catch {
            
        }
        
        timer?.fireDate = Date.distantFuture
        saveData()
        playButton.isEnabled = true
    }
    
    /// 播放
    ///
    /// - Parameter sender: 播放按钮
    @IBAction func playButtonClick(_ sender: UIButton) {
        if !(audioRecoder?.isRecording)! {
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: (audioRecoder?.url)!)
                audioPlayer?.play()
                audioPlayer?.volume = 1.0
                print("play")
            } catch {
                
            }
        }
    }
    
    //MARK: - 页面周期
    override func viewDidLoad() {
        super.viewDidLoad()
        setAudioSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        audioPlayer?.stop()
        timer?.invalidate()
        timer = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - 私有方法
    fileprivate func setAudioSession() {
        let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioRecoder = AVAudioRecorder(url: self.makeURL(), settings: settings)
            audioRecoder?.prepareToRecord()
        } catch {
            
        }
        
    }
    
    //设置路径和文件名
    private func makeURL() -> URL {
        currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyddMMHHmmss"
        recordName = formatter.string(from: currentDateTime!) + ".caf"
        print("recordName:", recordName!)
        
        let fileMamger = FileManager.default
        let urls = fileMamger.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as URL
        let voiceURL = documentDirectory.appendingPathComponent(recordName!)
        recordURL = String(describing: voiceURL)
        print(voiceURL, recordURL!)
        return voiceURL
    }
    
    
    //添加计时器
    private func addTimer() {
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(self.changeTimes), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
        timer?.fireDate = Date.distantFuture
    }
    
    //计时器
    @objc func changeTimes() {
        times = times + 1
        TimeRecordLable.text = "\(times)"
    }

    //存储数据
    private func saveData() {
        DispatchQueue.global().async {
            VoiceInformationManager.insertData(voiceName: self.recordName!, voiceTime: Int16(self.times), voiceDate: self.currentDateTime!, voiceURL: self.recordURL!)
            let result = VoiceInformationManager.queryData()
            print(result)
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "成功", message: "录音保存成功", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}



