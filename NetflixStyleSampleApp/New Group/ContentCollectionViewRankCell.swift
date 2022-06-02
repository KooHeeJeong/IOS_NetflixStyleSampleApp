//
//  ContentCollectionViewRankCell.swift
//  NetflixStyleSampleApp
//
//  Created by 구희정 on 2022/04/18.
//

import UIKit

class ContentCollectionViewRankCell : UICollectionViewCell {
    let imageView = UIImageView()
    let rankLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //ContentView
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
        
        //ImageView
        imageView.contentMode = .scaleToFill
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            //슈퍼뷰와 똑같이 맞춰준다.
            $0.top.trailing.bottom.equalToSuperview()
            //슈퍼뷰와 똑같이 맞추지만, 조금 작은 0.8 사이즈로
            $0.width.equalToSuperview().multipliedBy(0.8)
        }
        
        //rankLabel
        rankLabel.font = .systemFont(ofSize: 100, weight: .black)
        rankLabel.textColor = .white
        //ContentView 에 rankLaber을 추가해준다.
        contentView.addSubview(rankLabel)
        rankLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            //offset으로 25정도 맞춰준다.
            $0.bottom.equalToSuperview().offset(25)
        }
    }
}
