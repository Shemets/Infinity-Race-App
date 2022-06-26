//
//  CustomTableViewCell.swift
//  Space Race Main App
//
//  Created by Shemets on 22.06.22.
//
    
import UIKit

class CustomTableViewCell: UITableViewCell {
    var starImageView = UIImageView()
    var dateLabel = UILabel()
    var scoreLabel = UILabel()
    var evadedLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        starImageView = UIImageView()
        dateLabel = UILabel()
        scoreLabel = UILabel()
        evadedLabel = UILabel()
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func setupUI() {
        let starWidth: CGFloat = contentView.bounds.height
        let starHeight: CGFloat = contentView.bounds.height
        starImageView.frame = CGRect(x: contentView.bounds.minX + 5,
                                     y: contentView.bounds.midY - starHeight / 10 ,
                                     width: starWidth,
                                     height: starHeight)
        starImageView.image = UIImage(named: "star")
        starImageView.contentMode = .scaleAspectFill
        contentView.addSubview(starImageView)
        
        
        let labelWidth: CGFloat = contentView.bounds.width
        let labelHeight: CGFloat = contentView.bounds.height / 1.6
        dateLabel.frame = CGRect(x: contentView.bounds.minX + starWidth * 1.4,
                                 y: contentView.bounds.minY,
                                 width: labelWidth,
                                 height: labelHeight)
        dateLabel.font = UIFont(name: "Orbitron", size: 15)
        contentView.addSubview(dateLabel)
        
        scoreLabel.frame = dateLabel.frame.offsetBy(dx: 0, dy: labelHeight)
        scoreLabel.font = UIFont(name: "Orbitron", size: 15)
        contentView.addSubview(scoreLabel)
        
        evadedLabel.frame = scoreLabel.frame.offsetBy(dx: 0, dy: labelHeight)
        evadedLabel.font = UIFont(name: "Orbitron", size: 15)
        contentView.addSubview(evadedLabel)
    }
    
}
