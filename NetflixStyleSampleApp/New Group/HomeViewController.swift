//
//  HomeViewController.swift
//  NetflixStyleSampleApp
//
//  Created by 구희정 on 2022/04/14.
//

import UIKit
import SwiftUI

class HomeViewController : UICollectionViewController {
    var contents : [Content] = []
    var mainItem : Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //네비게이션 설정
        navigationController?.navigationBar.backgroundColor = .clear
        //빈 UIImage 를 사용
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //그림자를 설정 navigationBar의 윤곽선을 준다.
        navigationController?.navigationBar.shadowImage = UIImage()
        //스크롤 액션이 이뤄질때 navigationBar 가 사라지는 효과
        navigationController?.hidesBarsOnSwipe = true
        
        //navigation Button 을 추가한다.
        //왼쪽 버튼
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "netflix_icon"), style: .plain, target: nil, action: nil)
        //오른쪽 버튼
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle"), style: .plain, target: nil, action: nil)
        
        
        
        //CollectionView Item(Cell) 설정
        collectionView.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: "ContentCollectionViewCell")
        collectionView.register(ContentCollectionViewRankCell.self, forCellWithReuseIdentifier: "ContentCollectionViewRankCell")
        collectionView.register(ContentCollectionViewMainCell.self, forCellWithReuseIdentifier: "ContentCollectionViewMainCell")
        //CollectionView Header 설정
        collectionView.register(ContentCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ContentCollectionViewHeader")
        
        
        //CollectionView 는 아래 Layout 메소드를 통해서 설정을 해라
        collectionView.collectionViewLayout = layout()
        
        
        //Data 설정, 가져오기
        contents = getContent()
        //Content 리스트의 첫번째 아이템중 램덤으로 뽑아준다.
        mainItem = contents.first?.contentItem.randomElement()
        
    }
    
    //Content 값들 가져오는 메소드
    func getContent() -> [Content] {
        //path -> 경로지정
        //date -> FileManager를 사용하여, 경로에 있는 데이터를 가져와 달라는 요청
        //list -> list는 PropertyListDecoder를 사용하여 decode를 하여 배열을 가져온다. 만약 없으면 빈 값으로 전달.
        guard let path = Bundle.main.path(forResource: "Content", ofType: "plist"),
              let data = FileManager.default.contents(atPath: path),
              let list = try? PropertyListDecoder().decode([Content].self, from: data) else { return [] }
        return list
    }
}

//UICollectionView DataSource, Delegate
extension HomeViewController {
    //색션당 보여질 셀의 갯수
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
            //첫번째 색션에서는 1개만 보여지고
            //그 외의 색션에서는 plist에 담겨있는 item수 많큼 보여준다.
        case 0:
            return 1
        default:
            return contents[section].contentItem.count
        }
    }
    
    //콜랙션 뷰 셀 설정
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch contents[indexPath.section].sectionType {
            //basic 과 large 의 셀 설정
        case .basic, .large :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCollectionViewCell", for: indexPath) as? ContentCollectionViewCell else { return UICollectionViewCell() }
            cell.imageView.image = contents[indexPath.section].contentItem[indexPath.row].image
            return cell
            
        case .rank :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCollectionViewRankCell", for: indexPath) as? ContentCollectionViewRankCell else { return UICollectionViewCell() }
            cell.imageView.image = contents[indexPath.section].contentItem[indexPath.row].image
            cell.rankLabel.text = String(describing: indexPath.row + 1)
            
            return cell
            
        case .main :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCollectionViewMainCell", for: indexPath) as? ContentCollectionViewMainCell else { return UICollectionViewCell() }
            
            cell.imageView.image = mainItem?.image
            cell.descriptionLabel.text = mainItem?.description
            
            return cell
        }
    }
    
    //HeaderView 설정
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ContentCollectionViewHeader", for: indexPath) as? ContentCollectionViewHeader else { fatalError("Could not dequeue Header") }
            
            //fetalError 처리
            //호출 즉시 크래시를 발생시킨다. (프로세스를 죽임)
            
            headerView.sectionNameLabel.text = contents[indexPath.section].sectionName
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }
    
    //색션 개수 설정
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return contents.count
    }
    
    //셀 선택
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let isFirstSection = indexPath.section == 0
        let selectedItem = isFirstSection
        ? mainItem
        : contents[indexPath.section].contentItem[indexPath.row]
        
        let contentDetailView = ContentDetailView(item: selectedItem)
        let hostingVC = UIHostingController(rootView: contentDetailView)
        self.show(hostingVC, sender: nil)
    }
    
    
    //각각의 섹션 타입에 대한 UICollectionViewLayout 생성 (분기)
    private func layout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout {[weak self] sectionNumber, environment -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            
            
            switch self.contents[sectionNumber].sectionType {
            case .basic:
                return self.createBasicTypeSection()
            case .large :
                return self.createLargeTypeSection()
            case .rank :
                return self.createRankTypeSection()
            case .main :
                return self.createMainTypeSection()
            }
        }
    }
    
    //기본 화면 Section Layout설정
    private func createBasicTypeSection() -> NSCollectionLayoutSection {
        //Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(0.75))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 5, bottom: 0, trailing: 5)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        let sectionHeader = self.createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
        
    }
    
    //큰 화면 Section Layout 설정
    private func createLargeTypeSection() -> NSCollectionLayoutSection {
        //Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(0.75))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 5, bottom: 0, trailing: 5)
        //Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(350))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        //Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        
        let sectionHeader = self.createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
        
    }
    
    //Rank 화면 Section Layout 설정
    private func createRankTypeSection() -> NSCollectionLayoutSection {
        //Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(0.9))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 5, bottom: 0, trailing: 5)
        //Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        //Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        let sectionHeader = self.createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    //Main 화면 Section Layout 설정
    private func createMainTypeSection() -> NSCollectionLayoutSection {
        //Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        //Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(450))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        //Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 0, bottom: 20, trailing: 0)
        
        return section
    }
    
    //SectionHeader Layout 설정
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        //Section Header 사이즈
        //너비는 기기에 따라 다르겠지만, 높이는 30을 고정
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30))
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        return sectionHeader
    }
    

}

//SwiftUI를 활용한 미리보기
struct HomeViewController_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            HomeViewControllerRepresentable().preferredColorScheme(.dark).edgesIgnoringSafeArea(.all)
        }
    }
}

struct HomeViewControllerRepresentable : UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let layout = UICollectionViewLayout()
        let homeViewController = HomeViewController(collectionViewLayout: layout)
        return UINavigationController(rootViewController: homeViewController)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    typealias UIViewControllerType = UIViewController
}
