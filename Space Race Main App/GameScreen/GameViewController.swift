//
//  GameViewController.swift
//  Space Race Main App//

//  Created by Shemets on 6.06.22.
//

import UIKit
import QuartzCore

class GameViewController: UIViewController {
    
    private var spaceBackgroundImageView1 = UIImageView()
    private var spaceBackgroundImageView2 = UIImageView()
    private var shuttleImageView = UIImageView()
    private var shuttlesArray = [UIImage(named: "shuttle1"), UIImage(named: "shuttle2"), UIImage(named: "shuttle3"), UIImage(named: "shuttle4"), UIImage(named: "shuttle5"), UIImage(named: "shuttle6"), UIImage(named: "shuttle7"), UIImage(named: "shuttle8"), UIImage(named: "shuttle9")]
    private var bombImageView1 = UIImageView()
    private var bombImageView2 = UIImageView()
    private var bombImageView3 = UIImageView()
    private var bombImageView4 = UIImageView()
    private var bombImageView5 = UIImageView()
    private var gameOverImageView = UIImageView()
    private var gameOverLabel = UILabel()
    private var evoded = 0
    
    var difficulty = Difficulty.easy
    var difficultyKey = "speedKey"
    let shuttleStyleKey = "shuttleKey"
    var shuttleStyle: ShuttleStyle = .shuttleStyle1
    let bombStyleKey = "bombKey"
    var bombStyle: BombStyle = .bomb1
    let mapStyleKey = "mapKey"
    var mapStyle: MapStyle = .background1
    
    private var backToStartTimer = Timer()
    private var timerIntersectsView = Timer()
    
    private var pointTimer = Timer()
    private var timeResultLabel = UILabel()
    private var bombEvadedLabel = UILabel()
    private var scoreTime = Double()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        setupBackground()
        animateBackground()
        setupTimeResultLabel()
        setupBombEvadedLabel()
       setupUserDefaults()
        setupShuttle()
        shuttleControl()
        setupBombImageView1()
        setupBombAnimate1()
        setupBombImageView2()
        setupBombAnimate2()
        setupBombImageView3()
        setupBombAnimate3()
        setupBombImageView4()
        setupBombAnimate4()
        setupBombImageView5()
        setupBombAnimate5()
        checkObstracle()
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
    
    private func mapUserDefaults() -> UIImage {
        guard let mapString = UserDefaults.standard.string(forKey: mapStyleKey) else {
            return UIImage(named: MapStyle.background1.rawValue) ?? UIImage()
        }
        return UIImage(named: mapString) ?? UIImage()
    }
    
    private func setupBackground() {
        spaceBackgroundImageView1.frame = view.bounds
        spaceBackgroundImageView1.image = mapUserDefaults()
        spaceBackgroundImageView1.contentMode = .scaleAspectFill
        view.addSubview(spaceBackgroundImageView1)
        
        spaceBackgroundImageView2.frame = view.bounds
        spaceBackgroundImageView2.frame.origin = CGPoint(x: 0, y: -view.bounds.height)
        spaceBackgroundImageView2.image = mapUserDefaults()
        spaceBackgroundImageView2.contentMode = .scaleAspectFill
        view.addSubview(spaceBackgroundImageView2)
    }
    
        private func animateBackground() {
            var backgroundImageView1Y = view.bounds.height
            var backgroundImageView2Y: CGFloat = 0
            if spaceBackgroundImageView1.frame.origin.y == view.bounds.height {
                spaceBackgroundImageView1.frame.origin.y = -view.bounds.height
                backgroundImageView1Y = 0
                backgroundImageView2Y = view.bounds.height
            }else{
                spaceBackgroundImageView2.frame.origin.y = -view.bounds.height
                backgroundImageView1Y = view.bounds.height
                backgroundImageView2Y = 0
            }
            UIView.animate(withDuration: 3, delay: 0, options: [.curveLinear]) {
            self.spaceBackgroundImageView1.frame = CGRect(x: 0,
                                                          y: backgroundImageView1Y,
                                                          width: self.view.bounds.width,
                                                          height: self.view.bounds.height)
            self.spaceBackgroundImageView2.frame = CGRect(x: 0,
                                                          y: backgroundImageView2Y,
                                                          width: self.view.bounds.width,
                                                          height: self.view.bounds.height)
            
        } completion: { _ in
            self.animateBackground()
        }
     }
    
    private func setupShuttle() {
        let shuttleWidth: CGFloat = view.bounds.width / 7
        let shuttleHeigth: CGFloat = view.bounds.width / 7
        shuttleImageView.frame = CGRect(x: view.bounds.midX - shuttleWidth / 2,
                                        y: view.bounds.maxY - shuttleWidth * 5.5,
                                        width: shuttleWidth,
                                        height: shuttleHeigth)
        shuttleImageView.contentMode = .scaleAspectFill
        shuttleImageView.image = UIImage(named: UserDefaults.standard.string(forKey: shuttleStyleKey) ?? ShuttleStyle.shuttleStyle1.rawValue)
        view.addSubview(shuttleImageView)
    }
    
    
    private func shuttleControl() {
        let shuttleControlRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.shuttleControlMove))
        self.view.addGestureRecognizer(shuttleControlRecognizer)
    }
    
    @objc private func shuttleControlMove(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
            shuttleImageView.transform = CGAffineTransform(translationX: translation.x, y: 0)
    }
    
    private func bombUserDefaults() -> UIImage {
        guard let bombString = UserDefaults.standard.string(forKey: bombStyleKey) else {
            return UIImage(named: BombStyle.bomb1.rawValue) ?? UIImage()
        }
        return UIImage(named: bombString) ?? UIImage()
    }
    
    private func setupTimeResultLabel() {
        pointTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(pointTimerON), userInfo: NSDate(), repeats: true)
        let timeResultWidth: CGFloat = view.bounds.width / 2.5
        let timeResultHeight: CGFloat = view.bounds.height / 10
        timeResultLabel.frame = CGRect(x: view.bounds.minX,
                                       y: view.bounds.minY + timeResultHeight / 2,
                                       width: timeResultWidth,
                                       height: timeResultHeight)
        timeResultLabel.text = "Score: 0"
        timeResultLabel.textAlignment = .center
        timeResultLabel.font = UIFont(name: "Orbitron", size: 25)
        timeResultLabel.textColor = .white
        timeResultLabel.backgroundColor = .clear
        timeResultLabel.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.timeResultLabel.alpha = 1
            self.view.addSubview(self.timeResultLabel)
        }
    }
    @objc private func pointTimerON() {
        scoreTime = -(self.pointTimer.userInfo as! NSDate).timeIntervalSinceNow
        timeResultLabel.text = String(format: "Score: %.0f", scoreTime * 10)
    }
    
    private func setupBombEvadedLabel() {
        let bombCount = 0
        let labelWidth: CGFloat = view.bounds.width 
        let labelHeight: CGFloat = view.bounds.height / 10
        bombEvadedLabel.frame = CGRect(x: view.bounds.maxX - labelWidth / 1.4,
                                       y: view.bounds.minY + labelHeight / 2.2,
                                       width: labelWidth,
                                       height: labelHeight)
        bombEvadedLabel.text = "Evaded: \(bombCount)"
        bombEvadedLabel.textAlignment = .center
        bombEvadedLabel.font = UIFont(name: "Orbitron", size: 25)
        bombEvadedLabel.textColor = .white
        bombEvadedLabel.backgroundColor = .clear
        bombEvadedLabel.alpha = 0
        UIView.animate(withDuration: 0.7, delay: 0) {
            self.bombEvadedLabel.alpha = 1
            self.view.addSubview(self.bombEvadedLabel)
        }
    }
    
    private func setupBombImageView1() {
        let bombWidth: CGFloat = view.bounds.width / 9
        let bombHeight: CGFloat = view.bounds.width / 4
        bombImageView1.frame = CGRect(x: .random(in: bombWidth...view.bounds.width - bombWidth),
                                      y: -bombHeight * 3,
                                      width: bombWidth,
                                      height: bombHeight)
        bombImageView1.image = bombUserDefaults()
        bombImageView1.contentMode = .scaleAspectFit
        view.addSubview(bombImageView1)
    }
    
    private func setupBombImageView2() {
        let bombWidth: CGFloat = view.bounds.width / 9
        let bombHeight: CGFloat = view.bounds.width / 4
        bombImageView2.frame = CGRect(x: .random(in: bombWidth...view.bounds.width - bombWidth),
                                      y: -bombWidth * 3,
                                      width: bombWidth,
                                      height: bombHeight)
        bombImageView2.image = bombUserDefaults()
        bombImageView2.contentMode = .scaleAspectFit
        view.addSubview(bombImageView2)
        
    }
    
    private func setupBombImageView3() {
        let bombWidth: CGFloat = view.bounds.width / 9
        let bombHeight: CGFloat = view.bounds.width / 4
        bombImageView3.frame = CGRect(x: .random(in: bombWidth...view.bounds.width - bombWidth),
                                      y: -bombHeight * 3,
                                      width: bombWidth,
                                      height: bombHeight)
        bombImageView3.image = bombUserDefaults()
        bombImageView3.contentMode = .scaleAspectFit
        view.addSubview(bombImageView3)
    }
    
    private func setupBombImageView4() {
        let bombWidth: CGFloat = view.bounds.width / 9
        let bombHeight: CGFloat = view.bounds.width / 4
        bombImageView4.frame = CGRect(x: .random(in: bombWidth...view.bounds.width - bombWidth),
                                      y: -bombHeight * 3,
                                      width: bombWidth,
                                      height: bombHeight)
        bombImageView4.image = bombUserDefaults()
        bombImageView4.contentMode = .scaleAspectFit
        view.addSubview(bombImageView4)
    }
    
    private func setupBombImageView5() {
        let bombWidth: CGFloat = view.bounds.width / 9
        let bombHeight: CGFloat = view.bounds.width / 4
        bombImageView5.frame = CGRect(x: .random(in: bombWidth...view.bounds.width - bombWidth),
                                      y: -bombHeight * 3,
                                      width: bombWidth,
                                      height: bombHeight)
        bombImageView5.image = bombUserDefaults()
        bombImageView5.contentMode = .scaleAspectFit
        view.addSubview(bombImageView5)
    }
    
    private func setupBombAnimate1() {
        setupBombImageView1()
        UIView.animate(withDuration: Double(difficulty.rawValue), delay: 0.5, options: []) {
            self.bombImageView1.frame = self.bombImageView1.frame.offsetBy(dx: 0, dy: self.view.bounds.height + self.view.bounds.height / 2)
        } completion: { _ in
            self.setupBombAnimate1()
            self.evoded += 1
            self.bombEvadedLabel.text = "Evaded: \(self.evoded)"
        }
    }
    
    private func setupBombAnimate2() {
       setupBombImageView2()
        UIView.animate(withDuration: Double(difficulty.rawValue), delay: 1.18, options: []) {
            self.bombImageView2.frame = self.bombImageView2.frame.offsetBy(dx: 0, dy: self.view.bounds.height + self.view.bounds.height / 2)
        } completion: { _ in
            self.setupBombAnimate2()
            self.evoded += 1
            self.bombEvadedLabel.text = "Evaded: \(self.evoded)"
        }
    }
    
    private func setupBombAnimate3() {
        setupBombImageView3()
        UIView.animate(withDuration: Double(difficulty.rawValue), delay: 2, options: []) {
            self.bombImageView3.frame = self.bombImageView3.frame.offsetBy(dx: 0, dy: self.view.bounds.height + self.view.bounds.height / 2)
        } completion: { _ in
            self.setupBombImageView3()
            self.evoded += 1
            self.bombEvadedLabel.text = "Evaded: \(self.evoded)"
        }
    }
    
    private func setupBombAnimate4() {
        setupBombImageView4()
        UIView.animate(withDuration: Double(difficulty.rawValue), delay: 3.33, options: []) {
            self.bombImageView4.frame = self.bombImageView4.frame.offsetBy(dx: 0, dy: self.view.bounds.height + self.view.bounds.height / 2)
        } completion: { _ in
            self.setupBombAnimate4()
            self.evoded += 1
            self.bombEvadedLabel.text = "Evaded: \(self.evoded)"
        }
    }
    
    private func setupBombAnimate5() {
       setupBombImageView5()
        UIView.animate(withDuration: Double(difficulty.rawValue), delay: 3.66 , options: []) {
            self.bombImageView5.frame = self.bombImageView5.frame.offsetBy(dx: 0, dy: self.view.bounds.height + self.view.bounds.height / 2)
        } completion: { _ in
            self.setupBombAnimate5()
            self.evoded += 1
            self.bombEvadedLabel.text = "Evaded: \(self.evoded)"
        }
    }
    
    private func setupGameOverLabel() {
        let ImageWidth: CGFloat = view.bounds.width - 50
        let ImageHeight: CGFloat = view.bounds.height / 2
        gameOverImageView.frame = CGRect(x: view.bounds.midX - ImageWidth / 2,
                                         y: view.bounds.minY - ImageHeight,
                                         width: ImageWidth,
                                         height: ImageHeight)
        gameOverImageView.image = UIImage(named: "gameOver")
        gameOverImageView.contentMode = .scaleAspectFill
        view.addSubview(gameOverImageView)
        
        let labelWidth: CGFloat = gameOverImageView.bounds.width - 50
        let labelHeight: CGFloat = gameOverImageView.bounds.height / 5
        gameOverLabel.frame = CGRect(x: view.bounds.midX - labelWidth / 2,
                                     y: view.bounds.minY - labelHeight,
                                     width: labelWidth,
                                     height: labelHeight)
        gameOverLabel.alpha = 0
            self.gameOverLabel.frame = CGRect(x: gameOverImageView.bounds.midX - labelWidth / 2,
                                              y: gameOverImageView.bounds.minY - labelHeight / 6,
                                              width: labelWidth,
                                              height: labelHeight)
            gameOverLabel.text = "Game Over"
            gameOverLabel.textAlignment = .center
            gameOverLabel.font = UIFont(name: "Orbitron", size: 40)
            gameOverLabel.textColor = .white
            gameOverLabel.layer.masksToBounds = true
            gameOverLabel.layer.cornerRadius = 15
            gameOverLabel.alpha = 1
            gameOverImageView.addSubview(self.gameOverLabel)
        UIView.animate(withDuration: 1, delay: 0) {
            self.gameOverImageView.frame = CGRect(x: self.view.bounds.midX - ImageWidth / 2,
                                                  y: self.view.bounds.midY - ImageHeight / 2,
                                                  width: ImageWidth,
                                                  height: ImageHeight)
            self.gameOverLabel.alpha = 1
        }

    }
    
    private func checkObstracle() {
        timerIntersectsView = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(viewsDidIntersected), userInfo: nil, repeats: true)
    }
    
    @objc private func viewsDidIntersected() {
        let timeResultWidth: CGFloat = view.bounds.width
        let timeResultHeight: CGFloat = view.bounds.height / 10
        guard let shuttle = self.shuttleImageView.layer.presentation(),
              let bomb1 = self.bombImageView1.layer.presentation(),
              let bomb2 = self.bombImageView2.layer.presentation(),
              let bomb3 = self.bombImageView3.layer.presentation(),
              let bomb4 = self.bombImageView4.layer.presentation(),
              let bomb5 = self.bombImageView5.layer.presentation() else {
            return
        }
        if shuttle.frame.intersects(bomb1.frame) ||
            shuttle.frame.intersects(bomb2.frame) ||
            shuttle.frame.intersects(bomb3.frame) ||
            shuttle.frame.intersects(bomb4.frame) ||
            shuttle.frame.intersects(bomb5.frame) {
            
            shuttleImageView.image = UIImage(named: "boom")
            self.bombImageView1.layer.speed = 0
            self.bombImageView2.layer.speed = 0
            self.bombImageView3.layer.speed = 0
            self.bombImageView4.layer.speed = 0
            self.bombImageView5.layer.speed = 0
            self.spaceBackgroundImageView1.layer.speed = 0
            self.spaceBackgroundImageView2.layer.speed = 0
            bombImageView1.removeFromSuperview()
            bombImageView2.removeFromSuperview()
            bombImageView3.removeFromSuperview()
            bombImageView4.removeFromSuperview()
            bombImageView5.removeFromSuperview()
            timerIntersectsView.invalidate()
            pointTimer.invalidate()
            setupGameOverLabel()
            UIView.animate(withDuration: 1.5, delay: 0.5) {
                self.timeResultLabel.frame = CGRect(x: self.gameOverLabel.bounds.midX - timeResultWidth / 2.3,
                                                    y: self.gameOverLabel.bounds.minY + timeResultHeight,
                                                    width: timeResultWidth,
                                                    height: timeResultHeight)
                self.timeResultLabel.font = UIFont(name: "Orbitron", size: 50)
                self.timeResultLabel.textColor = .white
                
                self.bombEvadedLabel.frame = self.timeResultLabel.frame.offsetBy(dx: 0, dy: timeResultHeight - timeResultHeight / 2)
                self.bombEvadedLabel.font = UIFont(name: "Orbitron", size: 50)
                self.bombEvadedLabel.textColor = .white
                
                self.gameOverImageView.addSubview(self.bombEvadedLabel)
                self.gameOverImageView.addSubview(self.timeResultLabel)
                
                ResultsManager.saveResults(result: GameResults(date: Date()))
            }
        
            backToStartTimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(backToStart), userInfo: nil, repeats: true)
        }
    }
    @objc private func backToStart() {
        navigationController?.popToRootViewController(animated: true)
    }
}
    
    
       
 


