//
//  ImageCollectionViewCell.swift
//  Space Race Main App
//
//  Created by Shemets on 10.06.22.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        imageView = UIImageView()
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let imageWidht: CGFloat = contentView.bounds.width
        let imageHeight: CGFloat = contentView.bounds.height / 1.2
        imageView.frame = CGRect(x: contentView.bounds.midX - imageWidht / 2,
                                 y: contentView.bounds.midY - imageHeight / 2,
                                 width: imageWidht,
                                 height: imageHeight)
    }
    
}

