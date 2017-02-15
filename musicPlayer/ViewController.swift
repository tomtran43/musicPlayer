//
//  ViewController.swift
//  musicPlayer
//
//  Created by Loc Tran on 2/14/17.
//  Copyright © 2017 LocTran. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var sliderVolume: UISlider!
    @IBOutlet weak var buttonPlay: UIButton!
    var audio = AVAudioPlayer()
    var play = false
    var timer = Timer()
    var musicList = ["music","Cold Summer","noinaycoanh"]
    @IBOutlet weak var labelCurrentTime: UILabel!
    @IBOutlet weak var labelTotalTime: UILabel!
    @IBOutlet weak var sliderTime: UISlider!
    @IBOutlet weak var switchRepeat: UISwitch!
    @IBOutlet weak var labelMusic: UILabel!
    @IBOutlet weak var textviewMusicList: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addThumbImgForSlider()
    }
    
    func updateTime(){
        let currenttime = Int(audio.currentTime)
        let minCurrent = currenttime/60
        let secCurrent = currenttime - minCurrent * 60
        self.labelCurrentTime.text = String(format: "%2d:%02d", minCurrent, secCurrent)
        
        self.sliderTime.value = Float(audio.currentTime/audio.duration)
        
        let totaltime = Int(audio.duration)
        let minTotal = totaltime/60
        let secTotal = totaltime - minTotal * 60
        
        labelTotalTime.text = String(format: "%2d:%02d", minTotal, secTotal)
    }
    
    func addThumbImgForSlider(){
        sliderVolume.setThumbImage(UIImage(named: "thumb.png"), for: .normal)
        sliderVolume.setThumbImage(UIImage(named: "thumbHightLight.png"), for: .highlighted)
    }
    
    func playpause(){
        if play == false{
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            audio = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: getMusic(), ofType: ".mp3")!))
            audio.delegate = self
            audio.prepareToPlay()
            audio.play()
            buttonPlay.setImage(UIImage(named: "pause.png"), for: .normal)
            checkRepeat()
            getMusicList()
            play = true
        }else{
            audio.stop()
            timer.invalidate()
            buttonPlay.setImage(UIImage(named: "play.png"), for: .normal)
            play = false
        }
    }
    
    func getMusic()->String{
        let random = Int(arc4random_uniform(UInt32(musicList.count)))
        let music = musicList[random]
        labelMusic.text = music
        
        return music
    }
    
    func getMusicList(){
        
    var list = ""
        for index in 0..<musicList.count{
            list += "\(index+1). \(musicList[index]).mp3\n"
        }
        textviewMusicList.text = list
    }
    
    func checkRepeat(){
        if switchRepeat.isOn == true {
            audio.numberOfLoops = -1
        }else{
            audio.numberOfLoops = 0
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
            buttonPlay.setImage(UIImage(named: "play.png"), for: .normal)
        
    }

    @IBAction func actionVolumeSlider(_ sender: UISlider) {
        audio.volume = sender.value
    }

    @IBAction func actionPlay(_ sender: UIButton) {
        playpause()
    }
    
    @IBAction func sliderTime(_ sender: UISlider) {
        audio.currentTime = TimeInterval(Float(sender.value) * Float(audio.duration))
    }
    
    @IBAction func switchRepeat(_ sender: UISwitch) {
        checkRepeat()
    }
}

