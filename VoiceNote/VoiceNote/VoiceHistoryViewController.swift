//
//  VoiceHistoryViewController.swift
//  VoiceNote
//
//  Created by HideOnBush on 2017/8/4.
//  Copyright © 2017年 HideOnBush. All rights reserved.
//

import UIKit
import AVFoundation

class VoiceHistoryViewController: UIViewController {
    //数据
    fileprivate var voiceData: [VoiceInformation]? = nil
    //计时器
    fileprivate var timer: Timer? = nil
    //时间
    fileprivate var times: Int16 = 0
    //播放器
    fileprivate var audioPlayer: AVAudioPlayer? = nil
    
    fileprivate var currentCellInexPathRow: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        setUpUI()
        getData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        audioPlayer?.stop()
        timer?.invalidate()
        timer = nil
    }
    
    //MARK: - 添加控件
    private func setUpUI() {
        view.addSubview(voiceHistoryTableView)
    }
    
    //MARK: - 页面控件
    /// tableView
    fileprivate lazy var voiceHistoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.frame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64)
        tableView.backgroundColor = .white
        tableView.register(VoiceTableViewCell.self, forCellReuseIdentifier: "VOICE_CELL")
        tableView.rowHeight = 100
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: - 私有方法
extension VoiceHistoryViewController {
    fileprivate func getData() {
        DispatchQueue.global().async {
            self.voiceData = VoiceInformationManager.queryData()
            DispatchQueue.main.async {
                self.voiceHistoryTableView.reloadData()
            }
        }
    }
    
    fileprivate func playClick(voiceURL: String) {
        let url = URL(string: voiceURL)
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: url!)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            audioPlayer?.volume = 1.0
            
        } catch {
            print("error")
        }
    }
    
//    fileprivate func addTimer() {
//        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(self.changeTimes), userInfo: nil, repeats: true)
//        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
//        timer?.fireDate = Date.distantFuture
//    }
//    
//    @objc func changeTimes() {
//        times = times - 1
//        
//    }
}

//MARK: - 代理 数据源
extension VoiceHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return voiceData?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VOICE_CELL", for: indexPath) as! VoiceTableViewCell
        cell.selectionStyle = .none
        cell.voiceNameLable.text = voiceData?[indexPath.row].voiceName ?? "name"
        cell.voiceTimeLable.text = String(describing: voiceData?[indexPath.row].voiceTime ?? 0)
        return cell
    }
    
    //点击cell播放/暂停音乐
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard audioPlayer == nil || currentCellInexPathRow != indexPath.row else {
            guard (audioPlayer?.isPlaying)! else {
                audioPlayer?.play()
                timer?.fireDate = Date.distantPast
                return
            }
            audioPlayer?.pause()
            timer?.fireDate = Date.distantFuture
            return
        }
        guard audioPlayer == nil else {
            let cell = tableView.cellForRow(at: indexPath) as! VoiceTableViewCell
            currentCellInexPathRow = indexPath.row
            let url = voiceData?[indexPath.row].voiceURL
            playClick(voiceURL: url!)
            times = (voiceData?[indexPath.row].voiceTime)!
            timer = Timer(timeInterval: 1.0, repeats: true, block: { [weak self] Timer in
                self?.times = (self?.times)! - 1
                cell.voiceTimeLable.text = String(describing: self?.times)
                print(String(describing: (self?.times)))
            })
            RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
            return
        }
        
        audioPlayer?.stop()
        timer?.fireDate = Date.distantFuture
        let cell = tableView.cellForRow(at: indexPath) as! VoiceTableViewCell
        currentCellInexPathRow = indexPath.row
        let url = voiceData?[indexPath.row].voiceURL
        playClick(voiceURL: url!)
        
        times = (voiceData?[indexPath.row].voiceTime)!
        timer = Timer(timeInterval: 1.0, repeats: true, block: { [weak self] Timer in
            self?.times = (self?.times)! - 1
            cell.voiceTimeLable.text = String(describing: (self?.times))
            print(String(describing: (self?.times)))
        })
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
    }
}


extension VoiceHistoryViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        timer?.fireDate = Date.distantFuture
        times = 0
    }
}


