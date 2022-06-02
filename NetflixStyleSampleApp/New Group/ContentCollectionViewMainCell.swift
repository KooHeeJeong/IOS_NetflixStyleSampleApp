//
//  ContentCollectionViewMainCell.swift
//  NetflixStyleSampleApp
//
//  Created by 구희정 on 2022/04/28.
//

import UIKit

class ContentCollectionViewMainCell : UICollectionViewCell {
    let baseStackView = UIStackView()
    let menuStackView = UIStackView()
    
    let tvButton = UIButton()
    let moviewButton = UIButton()
    let categoryButton = UIButton()
    
    let imageView = UIImageView()
    let descriptionLabel = UILabel()
    let contentStackView = UIStackView()
    
    let plusButton = UIButton()
    let playButton = UIButton()
    let InfoButton = UIButton()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        [baseStackView, menuStackView].forEach {
            contentView.addSubview($0)
        }
        
        //baseStackView
        baseStackView.axis = .vertical
        baseStackView.alignment = .center
        baseStackView.distribution = .fillProportionally
        baseStackView.spacing = 5
        
        [imageView, descriptionLabel, contentStackView].forEach {
            baseStackView.addArrangedSubview($0)
        }
        
        //IamageView
        imageView.contentMode = .scaleToFill
        imageView.snp.makeConstraints {
            $0.width.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(imageView.snp.width)
        }
        
        //DescriptionLabel
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.textColor = .white
        descriptionLabel.sizeToFit()
        
        baseStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        //ContentStackView
        contentStackView.axis = .horizontal
        contentStackView.alignment = .center
        contentStackView.distribution = .equalCentering
        contentStackView.spacing = 20
        
        [plusButton,InfoButton].forEach {
            
            $0.titleLabel?.font = .systemFont(ofSize: 13)
            $0.setTitleColor(.white, for: .normal)
            $0.imageView?.tintColor = .white
            $0.adjustVerticalLayout(5)
        }
        
        plusButton.setTitle("내가 찜한 콘텐츠", for: .normal)
        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        
        InfoButton.setTitle("정보", for: .normal)
        InfoButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
        InfoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        
        playButton.setTitle("▶︎ 재생", for: .normal)
        playButton.setTitleColor(.black, for: .normal)
        playButton.backgroundColor = .white
        playButton.layer.cornerRadius = 3
        playButton.snp.makeConstraints {
            $0.width.equalTo(90)
            $0.height.equalTo(30)
        }
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        
        
        [plusButton,playButton,InfoButton].forEach {
            contentStackView.addArrangedSubview($0)
        }
        
        //오토 레이아웃 지정
        contentStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(60)
        }
        
        //menuStackView
        menuStackView.axis = .horizontal
        menuStackView.alignment = .center
        menuStackView.distribution = .equalSpacing
        menuStackView.spacing = 20
        
        [tvButton,moviewButton,categoryButton].forEach {
            menuStackView.addArrangedSubview($0)
            $0.setTitleColor(.white, for: .normal)
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 1
            $0.layer.shadowRadius = 3
        }
        
        tvButton.setTitle("TV 프로그램", for: .normal)
        moviewButton.setTitle("정보", for: .normal)
        categoryButton.setTitle("카테고리 ▾", for: .normal)
        
        tvButton.addTarget(self, action: #selector(tvButtonTapped), for: .touchUpInside)
        moviewButton.addTarget(self, action: #selector(moviewButtonTapped), for: .touchUpInside)
        categoryButton.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        
        
        menuStackView.snp.makeConstraints {
            $0.top.equalTo(baseStackView)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
    }
    
    @objc func tvButtonTapped(sender : UIButton!) {
        print("TEST : TV BUTTON Tapped")
    }
    
    @objc func moviewButtonTapped(sender : UIButton!) {
        print("TEST : MOVIEW BUTTON Tapped")
    }
    
    @objc func categoryButtonTapped(sender : UIButton!) {
        print("TEST : CATEGORY BUTTON Tapped")
    }
    
    @objc func plusButtonTapped(sender : UIButton!) {
        print("TEST : PLUS BUTTON Tapped")
    }
    
    @objc func infoButtonTapped(sender : UIButton!) {
        print("TEST : INFO BUTTON Tapped")
    }
    
    @objc func playButtonTapped(sender : UIButton!) {
        print("TEST : PLAY BUTTON Tapped")
    }
    
    
}
