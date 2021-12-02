//
//  ViewController.swift
//  FantasticCollectionView
//
//  Created by JimFu on 2021/11/29.
//

import UIKit

class ViewController: UIViewController {
    
    enum Section {
        case main
    }

    class ListItem: Hashable {
        private let identifier = UUID()
        let title: String
        let items: [ListItem]
        let controller: UIViewController.Type?
        
        init(title: String, items: [ListItem] = [], vc: UIViewController.Type? = nil) {
            self.title = title
            self.items = items
            self.controller = vc
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
        
        static func == (lhs: ViewController.ListItem, rhs: ViewController.ListItem) -> Bool {
            return lhs.identifier == rhs.identifier
        }
    }
    
    
    var dataSource: UICollectionViewDiffableDataSource<Section, ListItem>! = nil
    var collectionView: UICollectionView! = nil
    
    private var lists: [ListItem] = [ListItem(title: "SingleDataSource",
                                              items: [ListItem(title: "1 Column", vc: SingleColumnViewController.self),
                                                      ListItem(title: "2 Columns", vc: DoubleColumnViewController.self),
                                                      ListItem(title: "2 x 2", vc: FourSpaceViewController.self),
                                                      ListItem(title: "MutipleSection", vc: MutipleSectionViewController.self)])]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "Title"
        configureCollectionView()
        configureDataSource()
    }
}

extension ViewController {
    func configureCollectionView() {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemGroupedBackground
        self.collectionView = collectionView
        collectionView.delegate = self
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let listConfiguration = UICollectionLayoutListConfiguration(appearance: .sidebar)
        let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        return layout
    }
    
    func configureDataSource() {
        
        let containerCell = UICollectionView.CellRegistration<UICollectionViewListCell, ListItem> { cell, indexPath, item in
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = item.title
            contentConfiguration.textProperties.font = .preferredFont(forTextStyle: .headline)
            cell.contentConfiguration = contentConfiguration
            
            let disclosureOptions = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options: disclosureOptions)]
            cell.backgroundConfiguration = UIBackgroundConfiguration.clear()
        }
        
        let normalCell = UICollectionView.CellRegistration<UICollectionViewListCell, ListItem> { cell, indexPath, item in
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = item.title
            contentConfiguration.textProperties.font = .preferredFont(forTextStyle: .headline)
            cell.contentConfiguration = contentConfiguration
        }

        dataSource = UICollectionViewDiffableDataSource<Section, ListItem>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: ListItem) -> UICollectionViewCell? in
            // Return the cell.
            if item.items.isEmpty {
                return collectionView.dequeueConfiguredReusableCell(using: normalCell, for: indexPath, item: item)
            } else {
                return collectionView.dequeueConfiguredReusableCell(using: containerCell, for: indexPath, item: item)
            }
        }
        
        let snapshot = initialSnapshot()
        self.dataSource.apply(snapshot, to: .main, animatingDifferences: false)
    }
    
    func initialSnapshot() -> NSDiffableDataSourceSectionSnapshot<ListItem> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<ListItem>()

        func addItems(_ menuItems: [ListItem], to parent: ListItem?) {
            snapshot.append(menuItems, to: parent)
            for menuItem in menuItems where !menuItem.items.isEmpty {
                addItems(menuItem.items, to: menuItem)
            }
        }
        addItems(lists, to: nil)
        return snapshot
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = self.dataSource.itemIdentifier(for: indexPath) else { return }
        collectionView.deselectItem(at: indexPath, animated: true)
        if let viewcontroller = item.controller {
            self.navigationController?.pushViewController(viewcontroller.init(), animated: true)
        }
    }
}
