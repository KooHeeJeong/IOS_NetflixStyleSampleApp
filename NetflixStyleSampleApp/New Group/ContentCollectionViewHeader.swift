//
//  ContentCollectionViewHeader.swift
//  NetflixStyleSampleApp
//
//  Created by 구희정 on 2022/04/17.
//

import UIKit

//Header & footer를 사용하기 위해서는 UICollectionReusableView 를 사용해야한다.
class ContentCollectionViewHeader : UICollectionReusableView {
    let sectionNameLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        sectionNameLabel.font = .systemFont(ofSize: 17, weight: .bold)
        sectionNameLabel.textColor = .white
        sectionNameLabel.sizeToFit()
        
        addSubview(sectionNameLabel)
        
        sectionNameLabel.snp.makeConstraints{
            //전체 뷰와 동일하게 사용 할 것이다.
            $0.centerY.equalToSuperview()
            //위 아래 리딩이 10씩 떨어진 라벨이 위치
            $0.top.bottom.leading.equalToSuperview().offset(10)
            
        }
    }
}
