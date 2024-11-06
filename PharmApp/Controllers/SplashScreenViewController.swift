//
//  SplashScreenViewController.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 19/12/23.
//

import UIKit
import AVKit
import AVFoundation

class SplashScreenViewController: UIViewController {

    let playerController = AVPlayerViewController()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        playVideo()
    }
    
    private func playVideo() {
        guard let path = Bundle.main.path(forResource: "202312190405", ofType:"mp4") else {
            debugPrint("splash.m4v not found")
            return
        }
        
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        playerController.showsPlaybackControls = false
        playerController.player = player
        playerController.videoGravity = .resizeAspectFill
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerController.player?.currentItem)
        present(playerController, animated: true) {
            player.play()
        }
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        print("Method , video is finished ")
    }
}
