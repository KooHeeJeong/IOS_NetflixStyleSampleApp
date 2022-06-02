//
//  Content.swift
//  NetflixStyleSampleApp
//
//  Created by 구희정 on 2022/04/14.
//

import Foundation
import UIKit

struct Content: Decodable {
    let sectionType : SectionType
    let sectionName : String
    let contentItem : [Item]
    
    //4가지 타입이여도 똑같이 string으로 전달한다.
    enum SectionType : String, Decodable {
        case basic
        case main
        case large
        case rank
        
    }
}

struct Item : Decodable {
    let description : String
    let imageName : String
    
    var image : UIImage {
        //만약 imageName 과 같은 image가 없으면 빈 UIImage로 보여주기
        return UIImage(named: imageName) ?? UIImage()
    }
}
