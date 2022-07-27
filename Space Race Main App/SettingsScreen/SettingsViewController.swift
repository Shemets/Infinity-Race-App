//
//  SettingsViewController.swift
//  Space Race Main App
//
//  Created by Shemets on 10.06.22.
//

import UIKit
import AVFoundation

class SettingsViewController: UIViewController {
    private var descriptionLabel = UILabel()
    private var difficultyView = UIView()
    private var easyButton = UIButton()
    private var mediumButton = UIButton()
    private var hardButton = UIButton()
    private var shuttleColectionView: UICollectionView!
    private var shuttlesArray: [ShuttleStyle] = [.shuttleStyle1, .shuttleStyle2, .shuttleStyle3, .shuttleStyle4, .shuttleStyle5, .shuttleStyle6, .shuttleStyle7, .shuttleStyle8, .shuttleStyle9,.shuttleStyle10, .shuttleStyle11, .shuttleStyle12, .shuttleStyle13, .shuttleStyle14]
    private var selectBombView = UIView()
    private var bombArray: [UIImage?] = [UIImage(named: "bomb1"), UIImage(named: "bomb2"), UIImage(named: "Bomb3")]
    private var selectMapView = UIView()
    private var mapButton = UIButton()
    private var mapArray: [UIImage?] = [UIImage(named: "Background1"), UIImage(named: "Background2"), UIImage(named: "Background3"), UIImage(named: "Background4")]
    private var mapButton1 = UIButton()
    private var mapButton2 = UIButton()
    private var mapButton3 = UIButton()
    private var mapButton4 = UIButton()
    private var bomb1Button = UIButton()
    private var bomb2Button = UIButton()
    private var bomb3Button = UIButton()
    private var backButton = UIButton()
    
    
    let difficultyKey = "speedKey"
    var difficulty: Difficulty = .easy
    let shuttleStyleKey = "shuttleKey"
    var shuttleStyle: ShuttleStyle = .shuttleStyle1
    let bombStyleKey = "bombKey"
    var bombStyle: BombStyle = .bomb1
    let mapStyleKey = "mapKey"
    var mapStyle: MapStyle = .background1

    private var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        setupBackgroundVideo()
        setupBlur()
        setupUI()
        setupShuttleCollectionView()
        setupSelectBombView()
        setupBackButton()
        setupSelectMapView()
        setupUserDefaults()
        setupSelectedSettings()
        setupSelectedBomb()
        setupSelectedMap()
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
        let labelWidth: CGFloat = view.bounds.width
        let labelHeight: CGFloat = view.bounds.height / 8
        descriptionLabel.frame = CGRect(x: view.bounds.midX - labelWidth / 2,
                                        y: view.bounds.minY + labelHeight / 2,
                                        width: labelWidth,
                                        height: labelHeight)
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = "Choose your shuttle and skins"
        descriptionLabel.textColor = UIColor(hex: 0x7B68EE)
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont(name: "Orbitron", size: 35)
        descriptionLabel.alpha = 0
        UIView.animate(withDuration: 1, delay: 0) {
            self.descriptionLabel.alpha = 1
        }
        view.addSubview(descriptionLabel)
        
        let difficultyViewWidth: CGFloat = view.bounds.width - 50
        let difficultyViewHeigth: CGFloat = view.bounds.height / 6
        difficultyView.frame = CGRect(x: -view.bounds.width,
                                      y: view.bounds.midY - difficultyViewHeigth * 1.8, width: difficultyViewWidth,
                                      height: difficultyViewHeigth)
        difficultyView.layer.cornerRadius = 10
        difficultyView.backgroundColor = UIColor(hex: 0x7B68EE)
        difficultyView.alpha = 0
        UIView.animate(withDuration: 1, delay: 0) {
            self.difficultyView.frame = CGRect(x: self.view.bounds.midX - difficultyViewWidth / 2,
                                               y: self.view.bounds.midY - difficultyViewHeigth * 1.8, width: difficultyViewWidth,
                                               height: difficultyViewHeigth)
            self.difficultyView.alpha = 1
        }
        view.addSubview(difficultyView)
        
        let buttonWidth: CGFloat = view.bounds.width / 4
        let buttonHeight: CGFloat = view.bounds.height / 12
        easyButton.frame = CGRect(x: difficultyView.bounds.minX + buttonWidth / 7,
                                  y: difficultyView.bounds.midY - buttonHeight / 2,
                                  width: buttonWidth,
                                  height: buttonHeight)
        easyButton.titleLabel?.font = UIFont(name: "Orbitron", size: 20)
        easyButton.setTitle("Easy", for: .normal)
        easyButton.backgroundColor = UIColor(hex: 0x9370DB)
        easyButton.layer.cornerRadius = 10
        easyButton.addTarget(self, action: #selector(easyButtonCliced), for: .touchUpInside)
        easyButton.alpha = 0
        UIView.animate(withDuration: 1, delay: 0.4) {
            self.easyButton.alpha = 1
        }
        difficultyView.addSubview(easyButton)
        
        mediumButton.frame = easyButton.frame.offsetBy(dx: buttonWidth + buttonWidth / 9, dy: 0)
        mediumButton.titleLabel?.font = UIFont(name: "Orbitron", size: 20)
        mediumButton.setTitle("Medium", for: .normal)
        mediumButton.layer.cornerRadius = 10
        mediumButton.backgroundColor = UIColor(hex: 0x9370DB)
        mediumButton.addTarget(self, action: #selector(mediumButtonCliked), for: .touchUpInside)
        mediumButton.alpha = 0
        UIView.animate(withDuration: 1, delay: 0.4) {
            self.mediumButton.alpha = 1
        }
        difficultyView.addSubview(mediumButton)
        
        hardButton.frame = mediumButton.frame.offsetBy(dx: buttonWidth + buttonWidth / 9, dy: 0)
        hardButton.titleLabel?.font = UIFont(name: "Orbitron", size: 20)
        hardButton.setTitle("Hard", for: .normal)
        hardButton.layer.cornerRadius = 10
        hardButton.backgroundColor = UIColor(hex: 0x9370DB)
        hardButton.addTarget(self, action: #selector(hardButtonClicked), for: .touchUpInside)
        hardButton.alpha = 0
        UIView.animate(withDuration: 1, delay: 0.4) {
            self.hardButton.alpha = 1
        }
        difficultyView.addSubview(hardButton)
    }
    
    private func setupSelectedSettings() {
         updateSelectedDifficulty()
    }
    
           private func updateSelectedDifficulty() {
        easyButton.isSelected = difficulty == .easy
                easyButton.backgroundColor = easyButton.isSelected ? .purple : UIColor(hex: 0x9370DB)
        
        mediumButton.isSelected = difficulty == .medium
                mediumButton.backgroundColor = mediumButton.isSelected ? .purple : UIColor(hex: 0x9370DB)
        
        hardButton.isSelected = difficulty == .hard
                hardButton.backgroundColor = hardButton.isSelected ? .purple : UIColor(hex: 0x9370DB)
    }
 
    @objc private func easyButtonCliced() {
        difficulty = .easy
        setupSelectedSettings()
        let bounds = easyButton.bounds
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10 , options: .curveEaseInOut) {
            self.easyButton.bounds = CGRect(x: bounds.origin.x,
                                           y: bounds.origin.y + 30,
                                           width: bounds.width,
                                           height: bounds.height)
        }
    }
    
    @objc private func mediumButtonCliked() {
        difficulty = .medium
        setupSelectedSettings()
        let bounds = mediumButton.bounds
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10 , options: .curveEaseInOut) {
            self.mediumButton.bounds = CGRect(x: bounds.origin.x,
                                           y: bounds.origin.y + 30,
                                           width: bounds.width,
                                           height: bounds.height)
        }
    }
    
    @objc private func hardButtonClicked() {
        difficulty = .hard
        setupSelectedSettings()
        let bounds = hardButton.bounds
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10 , options: .curveEaseInOut) {
            self.hardButton.bounds = CGRect(x: bounds.origin.x,
                                           y: bounds.origin.y + 30,
                                           width: bounds.width,
                                           height: bounds.height)
        }
    }
    
    private func setupShuttleCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: view.bounds.width / 3.5 - 2,
                                     height: view.bounds.width / 3.5 - 2)
        let collectionViewWidth: CGFloat = view.bounds.width - 50
        let collectionViewHeight: CGFloat = view.bounds.height / 6
        let collectionViewFrame = CGRect(x: view.bounds.width,
                                         y: view.bounds.midY - collectionViewHeight / 1.5,
                                         width: collectionViewWidth,
                                         height: collectionViewHeight)
        self.shuttleColectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: flowLayout)
        shuttleColectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        shuttleColectionView.delegate = self
        shuttleColectionView.dataSource = self
        shuttleColectionView.backgroundColor = UIColor(hex: 0x7B68EE)
//        shuttleColectionView.alpha = 0.7
        shuttleColectionView.layer.cornerRadius = 10
        shuttleColectionView.showsHorizontalScrollIndicator = false
        shuttleColectionView.alpha = 0
        UIView.animate(withDuration: 1, delay: 0) {
            self.shuttleColectionView.frame = CGRect(x: self.view.bounds.midX - collectionViewWidth / 2,
                                                     y: self.view.bounds.midY - collectionViewHeight / 1.5,
                                                     width: collectionViewWidth,
                                                     height: collectionViewHeight)
            self.shuttleColectionView.alpha = 1
        }
        view.addSubview(shuttleColectionView)
    }
    
    private func setupSelectBombView() {
        let bombViewWidth: CGFloat = view.bounds.width / 2
        let bombViewHeight: CGFloat = view.bounds.height / 6
        selectBombView.frame = CGRect(x: -view.bounds.width,
                                      y: view.bounds.midY + bombViewHeight / 2.1,
                                      width: bombViewWidth,
                                      height: bombViewHeight)
        selectBombView.backgroundColor = UIColor(hex: 0x7B68EE)
        selectBombView.alpha = 0
        selectBombView.layer.cornerRadius = 10
         
        let bombButtonWidth: CGFloat = selectBombView.bounds.width / 4
        let bombButtonHeight: CGFloat = selectBombView.bounds.height / 1.1
        bomb1Button.frame = CGRect(x: selectBombView.bounds.minX + bombButtonWidth / 6,
                                   y: selectBombView.bounds.midY - bombButtonHeight / 2,
                                   width: bombButtonWidth,
                                   height: bombButtonHeight)
        bomb1Button.layer.cornerRadius = 10
        bomb1Button.backgroundColor = .clear
        bomb1Button.setImage(UIImage(named: "bomb1"), for: .normal)
        bomb1Button.addTarget(self, action: #selector(bomb1ButtonClicked), for: .touchUpInside)
        selectBombView.addSubview(bomb1Button)
        
        bomb2Button.frame = bomb1Button.frame.offsetBy(dx: bombButtonWidth + bombViewWidth / 15, dy: 0)
        bomb2Button.layer.cornerRadius = 10
        bomb2Button.backgroundColor = .clear
        bomb2Button.setImage(UIImage(named: "bomb2"), for: .normal)
        bomb2Button.addTarget(self, action: #selector(bomb2ButtonClicked), for: .touchUpInside)
        selectBombView.addSubview(bomb2Button)
        
        
        bomb3Button.frame = bomb2Button.frame.offsetBy(dx: bombButtonWidth + bombViewWidth / 15, dy: 0)
        bomb3Button.layer.cornerRadius = 10
        bomb3Button.backgroundColor = .clear
        bomb3Button.setImage(UIImage(named: "bomb3"), for: .normal)
        bomb3Button.addTarget(self, action: #selector(bomb3ButtonClicked), for: .touchUpInside)
        selectBombView.addSubview(bomb3Button)
        
        
        UIView.animate(withDuration: 1, delay: 0) {
            self.selectBombView.frame = CGRect(x: self.view.bounds.midX - bombViewWidth / 2,
                                               y: self.view.bounds.midY + bombViewHeight / 2.1,
                                               width: bombViewWidth,
                                               height: bombViewHeight)
            self.selectBombView.alpha = 1
            self.view.addSubview(self.selectBombView)
        }
        
    }
    
    private func setupSelectedBomb() {
        updateSelectedBomb()
    }
    
    private func updateSelectedBomb() {
        bomb1Button.isSelected = bombStyle == .bomb1
        bomb1Button.backgroundColor = bomb1Button.isSelected ? .purple : .clear
    
        bomb2Button.isSelected = bombStyle == .bomb2
        bomb2Button.backgroundColor = bomb2Button.isSelected ? .purple : .clear
        
        bomb3Button.isSelected = bombStyle == .bomb3
        bomb3Button.backgroundColor = bomb3Button.isSelected ? .purple : .clear
    }
    
    @objc private func bomb1ButtonClicked() {
        bombStyle = .bomb1
        setupSelectedBomb()
    }
    
    @objc private func bomb2ButtonClicked() {
        bombStyle = .bomb2
        setupSelectedBomb()
    }
    
    @objc private func bomb3ButtonClicked() {
        bombStyle = .bomb3
        setupSelectedBomb()
    }
    
    private func setupSelectMapView() {
        let mapButtonWidth: CGFloat = view.bounds.width / 5
        let mapButtonHeight: CGFloat = view.bounds.width / 5
        mapButton.frame = CGRect(x: view.bounds.midX - mapButtonWidth / 2,
                                 y: view.bounds.maxY - mapButtonWidth * 2.6,
                                 width: mapButtonWidth,
                                 height: mapButtonHeight)
        mapButton.setImage(UIImage(named: UserDefaults.standard.string(forKey: mapStyleKey) ?? MapStyle.background1.rawValue), for: .normal)
        mapButton.layer.cornerRadius = 20
        mapButton.alpha = 0
        mapButton.addTarget(self, action: #selector(mapButtonClicked), for: .touchUpInside)
        view.addSubview(mapButton)

        
        let mapViewWidth: CGFloat = view.bounds.width / 2.5
        let mapViewHeight: CGFloat = view.bounds.height
        selectMapView.frame = CGRect(x: view.bounds.width + mapViewWidth,
                                     y: view.bounds.midY - mapViewHeight / 2,
                                     width: mapViewWidth,
                                     height: mapViewHeight)
        selectMapView.backgroundColor = UIColor(hex: 0x9370DB)
        view.addSubview(selectMapView)
        
        let chooseMapButtonWidth: CGFloat = selectMapView.bounds.width - 20
        let chooseMapButtonHeight: CGFloat = selectMapView.bounds.width - 20
        mapButton1.frame = CGRect(x: selectMapView.bounds.midX - chooseMapButtonWidth / 2,
                                  y: selectMapView.bounds.minY + chooseMapButtonWidth / 1.3,
                                  width: chooseMapButtonWidth,
                                  height: chooseMapButtonHeight)
        mapButton1.layer.cornerRadius = 5
        mapButton1.setImage(UIImage(named: "background1"), for: .normal)
        mapButton1.addTarget(self, action: #selector(mapButton1Clicked), for: .touchUpInside)
        selectMapView.addSubview(mapButton1)
        
        mapButton2.frame = mapButton1.frame.offsetBy(dx: 0, dy: chooseMapButtonHeight + chooseMapButtonHeight / 10)
        mapButton2.setImage(UIImage(named: "background2"), for: .normal)
        mapButton2.addTarget(self, action: #selector(mapButton2Clicked), for: .touchUpInside)
        selectMapView.addSubview(mapButton2)
        
        mapButton3.frame = mapButton2.frame.offsetBy(dx: 0, dy: chooseMapButtonHeight + chooseMapButtonHeight / 10)
        mapButton3.setImage(UIImage(named: "background3"), for: .normal)
        mapButton3.addTarget(self, action: #selector(mapButton3Clicked), for: .touchUpInside)
        selectMapView.addSubview(mapButton3)
        
        mapButton4.frame = mapButton3.frame.offsetBy(dx: 0, dy: chooseMapButtonHeight + chooseMapButtonHeight / 10)
        mapButton4.setImage(UIImage(named: "background4"), for: .normal)
        mapButton4.addTarget(self, action: #selector(mapButton4Clicked), for: .touchUpInside)
        selectMapView.addSubview(mapButton4)
        
        
        UIView.animate(withDuration: 1, delay: 0) {
            self.mapButton.alpha = 1
        }
    }
    
    private func setupSelectedMap() {
        updateSelectedMap()
    }
    
    private func updateSelectedMap() {
        mapButton1.isSelected = mapStyle == .background1
        mapButton2.isSelected = mapStyle == .background2
        mapButton3.isSelected = mapStyle == .background3
        mapButton4.isSelected = mapStyle == .background4
    }
    
    @objc private func mapButton1Clicked() {
        let mapViewWidth: CGFloat = view.bounds.width / 2.5
        mapStyle = .background1
        setupSelectedMap()
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.selectMapView.frame = self.selectMapView.frame.offsetBy(dx: mapViewWidth, dy: 0)
        }
    }
    
    @objc private func mapButton2Clicked() {
        let mapViewWidth: CGFloat = view.bounds.width / 2.5
        mapStyle = .background2
        setupSelectedMap()
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.selectMapView.frame = self.selectMapView.frame.offsetBy(dx: mapViewWidth, dy: 0)
        }
    }
    
    @objc private func mapButton3Clicked() {
        let mapViewWidth: CGFloat = view.bounds.width / 2.5
        mapStyle = .background3
        setupSelectedMap()
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.selectMapView.frame = self.selectMapView.frame.offsetBy(dx: mapViewWidth, dy: 0)
        }
    }
    
    @objc private func mapButton4Clicked() {
        let mapViewWidth: CGFloat = view.bounds.width / 2.5
        mapStyle = .background4
        setupSelectedMap()
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.selectMapView.frame = self.selectMapView.frame.offsetBy(dx: mapViewWidth, dy: 0)
        }
    }
    
    @objc private func mapButtonClicked() {
        let mapViewWidth: CGFloat = view.bounds.width / 2.5
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.selectMapView.frame = self.selectMapView.frame.offsetBy(dx: -mapViewWidth * 2, dy: 0)
        }
    }
    
    private func setupBackButton() {
        let buttonWidth: CGFloat = view.bounds.width / 3
        let buttonHeight: CGFloat = view.bounds.height / 12
        backButton.frame = CGRect(x: view.bounds.midX - buttonWidth / 2,
                                  y: view.bounds.maxY - buttonHeight * 1.5,
                                  width: buttonWidth,
                                  height: buttonHeight)
        backButton.titleLabel?.font = UIFont(name: "Orbitron", size: 25)
        backButton.setTitle("Save", for: .normal)
        backButton.layer.cornerRadius = 10
        backButton.backgroundColor = UIColor(hex: 0x7B68EE)
        backButton.addTarget(self, action: #selector(backButtonCliked), for: .touchUpInside)
        backButton.alpha = 0
        UIView.animate(withDuration: 1, delay: 0.6) {
            self.backButton .alpha = 1
        }
        view.addSubview(backButton)
    }
    @objc private func backButtonCliked() {
        UserDefaults.standard.set(difficulty.rawValue, forKey: difficultyKey)
        UserDefaults.standard.set(bombStyle.rawValue, forKey: bombStyleKey)
        UserDefaults.standard.set(mapStyle.rawValue, forKey: mapStyleKey)
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func setupUserDefaults() {
        let difficultyValue = UserDefaults.standard.double(forKey: difficultyKey)
        difficulty = Difficulty(rawValue: difficultyValue) ?? .easy
        
        if let bombStyleValue = UserDefaults.standard.string(forKey: bombStyleKey){
        bombStyle = BombStyle(rawValue: bombStyleValue) ?? .bomb1
        }
        
        if let mapStyleValue = UserDefaults.standard.string(forKey: mapStyleKey) {
            mapStyle = MapStyle(rawValue: mapStyleValue) ?? .background1
        }
    }
}
// Shuttle CollectionView
extension SettingsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shuttlesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
        cell.imageView.image = UIImage(named: shuttlesArray[indexPath.row].rawValue)
        cell.backgroundColor = UIColor(hex: 0x9370DB)
        cell.layer.cornerRadius = 10
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectShuttle = shuttlesArray[indexPath.row]
        UserDefaults.standard.set(selectShuttle.rawValue, forKey: shuttleStyleKey)
        guard let cell = shuttleColectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell else {
            return
        }
        cell.backgroundColor = cell.isSelected ? .purple : .red
        // easyButton.isSelected = difficulty == .easy
    }
}

