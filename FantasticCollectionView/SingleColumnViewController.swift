//
//  SingleColumnViewController.swift
//  FantasticCollectionView
//
//  Created by JimFu on 2021/11/30.
//

import UIKit

class SingleColumnViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureCollectionView()
        configureDataSource()
    }
    
    var collertionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Int, Int>! = nil

}

extension SingleColumnViewController {
    func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.2))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                     subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
//        section.orthogonalScrollingBehavior = .continuous
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    
    func configureCollectionView() {
        collertionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        collertionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collertionView)
    }
    
    func configureDataSource() {
        
        let cellRegister = UICollectionView.CellRegistration<TextCell, Int> { cell, indexPath, identifier in
            cell.label.text = "\(identifier)"
            cell.contentView.backgroundColor = .yellow
            cell.layer.borderWidth = 1.0
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collertionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Int) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegister, for: indexPath, item: itemIdentifier)
        }
        
        var snapShot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapShot.appendSections([1])
        snapShot.appendItems(Array(0...30))
        dataSource.apply(snapShot)
    }
}
