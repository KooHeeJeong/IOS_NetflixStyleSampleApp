//
//  ContentCollectionViewCell.swift
//  NetflixStyleSampleApp
//
//  Created by 구희정 on 2022/04/17.
//

import UIKit
import SnapKit

class ContentCollectionViewCell :UICollectionViewCell {
    let imageView = UIImageView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //self 로 하는 것이 아닌 contentView 로 컨트롤을 해줘야 한다.
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
        
        //이미지를 ScaleAspectFill 로 표시를 해준다.
        imageView.contentMode = .scaleToFill
        
        //ContentView에 ImageView 를 추가해준다.
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints{
            //ContentView의 모든 edge에 맞게 그려준다.
            $0.edges.equalToSuperview()
        }
        
    }
}
