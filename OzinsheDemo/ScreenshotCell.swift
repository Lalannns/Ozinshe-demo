//
//  ScreenshotCell.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 08.09.2026.
//

import UIKit
import SnapKit
import SDWebImage

class ScreenshotCell: UICollectionViewCell {
    static let identifier = "ScreenshotCell"
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.backgroundColor = .systemGray6
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with screenshot: Screenshot) {
        if let link = screenshot.link, let url = URL(string: link) {
            imageView.sd_setImage(with: url)
        }
    }
    
}
