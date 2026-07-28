//
//  MovieTableViewCell.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 12.07.2026.
//

import UIKit
import SnapKit

class MovieTableViewCell: UITableViewCell {
    
    lazy var posterImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "Movie1")
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    lazy var titleLabel = {
       let label = UILabel()
        
        label.text = "Қызғалдақтар мекені"
        label.font = UIFont(name: "SFProDisplay-Bold", size: 14)
        label.textColor = UIColor(named: "111827")
        
        return label
    }()

    lazy var subtitleLabel = {
       let label = UILabel()
        
        label.text = "2020 • Телехикая • Мультфильм"
        label.font = UIFont(name: "SFProDisplay-Regular", size: 12)
        label.textColor = UIColor(named: "9CA3AF")
        
        return label
    }()
    
    
    lazy var playView = {
        let view = UIView()
        let imageView = UIImageView(image: UIImage(named: "Play-Filled"))
        let label = UILabel()
        
        view.backgroundColor = UIColor(named: "F8EEFF")
        view.layer.cornerRadius = 8
        
        label.text = "Қарау"
        label.font = UIFont(name: "SFProDisplay-Bold", size: 12)
        label.textColor = UIColor(named: "9753F0")
        
        view.addSubview(imageView)
        view.addSubview(label)
        
        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(16)
        }
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(imageView.snp.right).offset(4)
            make.right.equalToSuperview().inset(12)
        }
        
        return view
    }()
    
    lazy var bottomView = {
       
        let view = UIView()
        
        view.backgroundColor = UIColor(named: "D1D5DB")
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    
    func setupUI(){
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(playView)
        contentView.addSubview(bottomView)
        
       
        posterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.left.equalToSuperview().inset(24)
            make.height.equalTo(104)
            make.width.equalTo(71)
            
            make.bottom.equalToSuperview().inset(12).priority(.high) //новая тема
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(17)
            make.left.equalTo(posterImageView.snp.right).offset(17)
            make.right.equalToSuperview().inset(24)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.left.equalTo(posterImageView.snp.right).offset(17)
            make.right.equalToSuperview().inset(24)
        }

        playView.snp.makeConstraints { make in
            make.left.equalTo(posterImageView.snp.right).offset(17)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(24)
            
            //новая тема
            make.width.equalTo(80)
            make.height.equalTo(26)
            
        }

        bottomView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.equalToSuperview().inset(24)
            make.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview()
        }
        
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
