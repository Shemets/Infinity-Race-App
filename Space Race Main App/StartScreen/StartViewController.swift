//
//  ViewController.swift
//  Space Race Main App
//w//  Created by Shemets on 3.06.22.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    private var extraImage = UIImageView()
    private var titleGame = UIImageView()
    private var gameNameLabel = UILabel()
    private var startButton = UIButton()
    private var settingsButton = UIButton()
    private var recordsButton = UIButton()
    private var aboutButton = UIButton()

    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBlur()
        setupBackgroundVideo()
        setupUI()
    }

    private func setupBackgroundVideo() {
        guard let path = Bundle.main.path(forResource: "Background2", ofType: "mp4") else { return }
            player = AVPlayer(url: URL(fileURLWithPath: path))
            player!.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.view.frame
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            self.view.layer.insertSublayer(playerLayer, at: 0)
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player!.currentItem)
            player!.seek(to: CMTime.zero)
            player!.play()
            self.player?.isMuted = true
        }
        
        @objc func playerItemDidReachEnd() {
            player!.seek(to: CMTime.zero)
        }
    
    private func setupBlur() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
 
    private func setupUI() {
        let imageWidth: CGFloat = view.bounds.width - 50
        let imageHeight: CGFloat = view.bounds.height / 1.5
        extraImage.frame = CGRect(x: view.bounds.midX - imageWidth / 1.9,
                                  y: view.bounds.midY - imageHeight / 1.8,
                                  width: imageWidth,
                                  height: imageHeight)
        extraImage.image = UIImage(named: "startImage")
        extraImage.contentMode = .scaleAspectFill
        extraImage.alpha = 0
        view.addSubview(extraImage)
        UIView.animate(withDuration: 3, delay: 0) {
            self.extraImage.alpha = 1
        }
        
        let nameWidth: CGFloat = view.bounds.width
        let nameHeight: CGFloat = view.bounds.height / 8
        titleGame.frame = CGRect(x: view.bounds.midX - nameWidth / 2,
                                 y: view.bounds.minY + nameWidth / 6,
                                 width: nameWidth,
                                 height: nameHeight)
        titleGame.image = UIImage(named: "titleGame")
        titleGame.contentMode = .scaleAspectFill
        titleGame.alpha = 0
        view.addSubview(titleGame)
        
        gameNameLabel.frame = titleGame.frame.offsetBy(dx: 0, dy: -nameHeight / 10)
        gameNameLabel.lineBreakMode = .byWordWrapping
        gameNameLabel.numberOfLines = 0
        gameNameLabel.font = UIFont(name: "Orbitron", size: 58)
        gameNameLabel.text = NSLocalizedString("label.game.name", comment: "")
        gameNameLabel.textColor = UIColor(hex: 0xE6E6FA)
        gameNameLabel.textAlignment = .center
        gameNameLabel.alpha = 0
        UIView.animate(withDuration: 1, delay: 0.4) {
            self.gameNameLabel.alpha = 1
            self.titleGame.alpha = 1
        }
        view.addSubview(gameNameLabel)
        
        let startButtonWidth: CGFloat = view.bounds.width - 60
        let startButtonHeight: CGFloat = view.bounds.width / 3
        startButton.frame = CGRect(x: view.bounds.midX - startButtonWidth / 2,
                                   y: view.bounds.midY + startButtonHeight,
                                   width: startButtonWidth,
                                   height: startButtonHeight)
        startButton.setImage(UIImage(named: "start"), for: .normal)
        startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
        startButton.alpha = 0
        UIView.animate(withDuration: 1, delay: 0.2) {
            self.startButton.alpha = 1
        }
        view.addSubview(startButton)
        
        let buttonWidth: CGFloat = view.bounds.width / 4
        let buttonHeight: CGFloat = view.bounds.width / 4
        settingsButton.frame = startButton.frame.offsetBy(dx: 0, dy: buttonHeight + buttonHeight / 3.5)
        settingsButton.frame.size = CGSize(width: buttonWidth, height: buttonHeight)
        settingsButton.setImage(UIImage(named: "settings"), for: .normal)
        settingsButton.addTarget(self, action: #selector(settingsButtonClicked), for: .touchUpInside)
        settingsButton.alpha = 0
        UIView.animate(withDuration: 1, delay: 0.3) {
            self.settingsButton.alpha = 1
        }
        view.addSubview(settingsButton)
        
        recordsButton.frame = settingsButton.frame.offsetBy(dx: buttonWidth + buttonWidth / 4.5, dy: 0)
        recordsButton.frame.size = CGSize(width: buttonWidth, height: buttonHeight)
        recordsButton.setImage(UIImage(named: "records"), for: .normal)
        recordsButton.addTarget(self, action: #selector(recordsButtonClicked), for: .touchUpInside)
        recordsButton.alpha = 0
        UIView.animate(withDuration: 1, delay: 0.4) {
            self.recordsButton.alpha = 1
        }
        view.addSubview(recordsButton)
        
        aboutButton.frame = recordsButton.frame.offsetBy(dx: buttonWidth + buttonWidth / 4.5, dy: 0)
        aboutButton.frame.size = CGSize(width: buttonWidth, height: buttonHeight)
        aboutButton.setImage(UIImage(named: "about"), for: .normal)
        aboutButton.addTarget(self, action: #selector(aboutButtonClicked), for: .touchUpInside)
        aboutButton.alpha = 0
        UIView.animate(withDuration: 1, delay: 0.5) {
            self.aboutButton.alpha = 1
        }
        view.addSubview(aboutButton)
    }
    
    
    @objc private func startButtonClicked() {
        transitToGameViewContrller()
    }
    
    @objc private func settingsButtonClicked() {
        transitToSettingsViewController()
    }
    
    @objc private func recordsButtonClicked() {
        transitToRecordsViewController()
    }
    
    @objc private func aboutButtonClicked() {
        
    }
    
    private func transitToGameViewContrller() {
        let storyboard = UIStoryboard(name: "GameViewController", bundle: Bundle.main)
        let gameViewController = storyboard.instantiateInitialViewController() as! GameViewController
        navigationController?.pushViewController(gameViewController, animated: true)
    }
    
    private func transitToSettingsViewController() {
        let storyboard = UIStoryboard(name: "SettingsViewController", bundle: Bundle.main)
        let settingsViewController = storyboard.instantiateInitialViewController() as! SettingsViewController
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    private func transitToRecordsViewController() {
        let storyboard = UIStoryboard(name: "RecordsViewController", bundle: Bundle.main)
        let recordsViewController = storyboard.instantiateInitialViewController() as! RecordsViewController
        navigationController?.pushViewController(recordsViewController, animated: true)
    }
    
}

