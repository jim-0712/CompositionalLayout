//
//  FourSpaceViewController.swift
//  FantasticCollectionView
//
//  Created by JimFu on 2021/11/30.
//

import UIKit

class FourSpaceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureCollection()
        configureDataSource()
    }
    

    var collectionview: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Int, Int>! = nil

}

extension FourSpaceViewController {
    func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .fractionalHeight(0.5))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                               heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 2)
//        group.interItemSpacing = .fixed(CGFloat(20))
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
//        section.interGroupSpacing = CGFloat(20)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        
        return UICollectionViewCompositionalLayout(section: section)
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
        
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionview) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Int) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: normalCell, for: indexPath, item: itemIdentifier)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapshot.appendSections([1])
        snapshot.appendItems(Array(0...7))
        dataSource.apply(snapshot)
    }
    
}
