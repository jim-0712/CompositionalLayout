//
//  MutipleSectionViewController.swift
//  FantasticCollectionView
//
//  Created by JimFu on 2021/11/30.
//

import UIKit

class MutipleSectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureCollection()
        configureDataSource()
    }
    
    enum SectionType: Int, CaseIterable {
        case normal, threeC, fiveC
        var count: Int {
            switch self {
            case .normal: return 1
            case .threeC: return 3
            case .fiveC: return 5
            }
        }
    }
    
    var collectionview: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<SectionType, Int>! = nil
}

extension MutipleSectionViewController {
    func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { section, layoutEnvironment in
            guard let sectionKind = SectionType(rawValue: section) else { return nil }
            let columns = sectionKind.count
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(60))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            return section
        }
        return layout
    }
    
    func configureCollection() {
        collectionview = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        collectionview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionview.backgroundColor = .blue
        view.addSubview(collectionview)
    }
    
    func configureDataSource() {
        let normalCell = UICollectionView.CellRegistration<TextCell, Int> { cell, indexPath, identifier in
            cell.label.text = "\(identifier)"
            cell.contentView.backgroundColor = .yellow
            cell.layer.borderWidth = 1.0
        }
        
        dataSource = UICollectionViewDiffableDataSource<SectionType, Int>(collectionView: collectionview) { (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: normalCell, for: indexPath, item: identifier)
        }
        
        let index = 10
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, Int>()
        SectionType.allCases.forEach { type in
            snapshot.appendSections([type])
            let itemOffset = type.rawValue * index
            let itemUpperbound = itemOffset + index
            snapshot.appendItems(Array(itemOffset..<itemUpperbound))
        }
        dataSource.apply(snapshot)
    }
}
