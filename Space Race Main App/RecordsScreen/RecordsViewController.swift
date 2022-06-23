//
//  RecordsViewController.swift
//  Space Race Main App
//
//  Created by Shemets on 17.06.22.
//

import UIKit

class RecordsViewController: UIViewController {
    
    private var backButton = UIButton()
    private var backgroundImageView = UIImageView()
    private var ratingImageView = UIImageView()
    private var ratingLabel = UILabel()
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        setupBackground()
        setupUI()
        setupTableView()
    }
    
    private func setupBackground() {
        backgroundImageView.frame = view.bounds
        backgroundImageView.image = UIImage(named: "recordsBG")
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
    }
    
    private func setupUI() {
        let ratingImageWidth: CGFloat = view.bounds.width - 50
        let ratingImageHeight: CGFloat = view.bounds.height / 8
        ratingImageView.frame = CGRect(x: -view.bounds.width,
                                       y: view.bounds.minY + ratingImageHeight / 2,
                                       width: ratingImageWidth,
                                       height: ratingImageHeight)
        ratingImageView.image = UIImage(named: "titleGame")
        ratingImageView.contentMode = .scaleAspectFill
        view.addSubview(ratingImageView)
        UIView.animate(withDuration: 1, delay: 1) {
            self.ratingImageView.frame = CGRect(x: self.view.bounds.midX - ratingImageWidth / 2,
                                                y: self.view.bounds.minY + ratingImageHeight / 2,
                                                width: ratingImageWidth,
                                                height: ratingImageHeight)
        }
        
        let labelWidth: CGFloat = ratingImageView.bounds.width
        let labelHeight: CGFloat = ratingImageView.bounds.height
        ratingLabel.frame = CGRect(x: ratingImageView.bounds.midX - labelWidth / 2,
                                   y: ratingImageView.bounds.midY - labelHeight / 1.6,
                                   width: labelWidth,
                                   height: labelHeight)
        ratingLabel.text = "Rating"
        ratingLabel.textAlignment = .center
        ratingLabel.font = UIFont(name: "Orbitron", size: 70)
        ratingLabel.backgroundColor = .clear
        ratingLabel.textColor = UIColor(hex: 0xFFF0F5)
        ratingLabel.alpha = 0
        ratingImageView.addSubview(ratingLabel)
        UIView.animate(withDuration: 0.5, delay: 1.6) {
            self.ratingLabel.alpha = 1
        }
         
        let buttonWidth: CGFloat = view.bounds.width / 3
        let buttonHeight: CGFloat = view.bounds.height / 12
        backButton.frame = CGRect(x: view.bounds.midX - buttonWidth / 2,
                                  y: view.bounds.maxY - buttonHeight * 2,
                                  width: buttonWidth,
                                  height: buttonHeight)
        backButton.titleLabel?.font = UIFont(name: "Orbitron", size: 25)
        backButton.setTitle("Back", for: .normal)
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
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func setupTableView() {
        tableView = UITableView()
        let tableWidth: CGFloat = view.bounds.width - 50
        let tableHeight: CGFloat = view.bounds.height / 1.8
        tableView.frame = CGRect(x: view.bounds.midX - tableWidth / 2,
                                 y: -view.bounds.height,
                                 width: tableWidth,
                                 height: tableHeight)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.layer.cornerRadius = 5
        tableView.backgroundColor = UIColor(hex: 0x4169E1)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        UIView.animate(withDuration: 1.5, delay: 0) {
            self.tableView.frame = CGRect(x: self.view.bounds.midX - tableWidth / 2,
                                          y: self.view.bounds.midY - tableHeight / 2,
                                          width: tableWidth,
                                          height: tableHeight)

        }
    }
 }
extension RecordsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataArray = ResultsManager.loadData() else {
            return 0
        }
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor(hex: 0x4682B4)
        guard let dataArray = ResultsManager.loadData() else {
            return UITableViewCell()
        }
        let currentGameResult = dataArray[indexPath.row]
        cell.textLabel?.text = "Date: \(currentGameResult.date)"
        cell.textLabel?.font = UIFont(name: "Orbitron", size: 20)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height: CGFloat = 80
        return height
    }
    
}
