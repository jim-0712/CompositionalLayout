//
//  TwelveViewController.swift
//  FantasticCollectionView
//
//  Created by JimFu on 2021/12/2.
//

import UIKit

class TwelveViewController: UIViewController {
    
    enum SectionType {
        case main
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureCollectionview()
        configureDataSource()
    }
    
    var collectionview: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<SectionType, Int>! = nil

}

extension TwelveViewController {
    func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(0.33))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                               heightDimension: .absolute(450))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 4)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func configureCollectionview() {
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
        
        dataSource = UICollectionViewDiffableDataSource<SectionType, Int> (collectionView: collectionview) { (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: normalCell, for: indexPath, item: identifier)
        }
        
        var snapShot = NSDiffableDataSourceSnapshot<SectionType, Int>()
        snapShot.appendSections([.main])
        snapShot.appendItems(Array(0...17))
        dataSource.apply(snapShot)
    }
}
