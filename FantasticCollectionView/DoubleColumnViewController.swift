//
//  DoubleColumnViewController.swift
//  FantasticCollectionView
//
//  Created by JimFu on 2021/11/30.
//

import UIKit

class DoubleColumnViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollection()
        configureDataSource()
        // Do any additional setup after loading the view.
    }
    
    var collectonview: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Int, Int>! = nil
}

extension DoubleColumnViewController {
    func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
//        section.orthogonalScrollingBehavior = .continuous
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func configureCollection() {
        collectonview = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        collectonview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectonview)
    }
    
    func configureDataSource() {
        let normalCell = UICollectionView.CellRegistration<TextCell, Int> { cell, indexPath, identifier in
            cell.label.text = "\(identifier)"
            cell.contentView.backgroundColor = .yellow
            cell.layer.borderWidth = 1.0
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectonview) { (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: normalCell, for: indexPath, item: identifier)
        }
        
        var snapShot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapShot.appendSections([1])
        snapShot.appendItems(Array(0...30))
        dataSource.apply(snapShot)
    }
}
