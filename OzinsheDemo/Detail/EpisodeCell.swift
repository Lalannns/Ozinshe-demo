//
//  EpisodeCell.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 14.10.2026.
//

import UIKit
import SnapKit

class EpisodeCell: UITableViewCell {
    static let identifier = "EpisodeCell"

    private let previewImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.backgroundColor = UIColor(red: 31/255, green: 41/255, blue: 55/255, alpha: 1.0)
        return iv
    }()

    private let playIconImageView: UIImageView = {
        let iv = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        iv.image = UIImage(systemName: "play.circle.fill", withConfiguration: config)
        iv.tintColor = .white
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = UIColor { trait in
            return trait.userInterfaceStyle == .dark ? .white : UIColor(red: 17/255, green: 24/255, blue: 39/255, alpha: 1.0)
        }
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(previewImageView)
        previewImageView.addSubview(playIconImageView)
        contentView.addSubview(titleLabel)

        previewImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(180)
        }

        playIconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(44)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(previewImageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with video: Video) {
        titleLabel.text = "\(video.number)-ші бөлім"
        // Optional: If you have poster/thumbnail link for videos, load with SDWebImage here
    }
}
