//
//  DiffableViewControllerTable.swift
//  UIKitMarathon_D4
//
//  Created by Maksim Vaselkov on 18.02.2024.
//

import UIKit

final class DiffableViewControllerTable: UITableViewController {

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        tableView = .init(frame: .zero, style: .insetGrouped)
    }

    private var data: [String] = []
    private var selected: [String] = []

    private lazy var dataSource: UITableViewDiffableDataSource<String, String> = .init(tableView: tableView) { tableView, indexPath, itemIdentifier in
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = itemIdentifier
        cell?.accessoryType = self.selected.contains(itemIdentifier) ? .checkmark : .none

        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Table Mixer"

        for i in 0...40 {
            data.append("\(i)")
        }

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        navigationItem.rightBarButtonItem = .init(title: "Shuffle", primaryAction: .init(handler: { [weak self] _ in
            guard let self else { return }
            self.data = self.data.shuffled()
            self.updateData(self.data, animated: true)
        }))

        updateData(data, animated: false)
    }

    private func updateData(_ data: [String], animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<String, String>()
        snapshot.appendSections(["first"])
        snapshot.appendItems(data, toSection: "first")
        dataSource.apply(snapshot, animatingDifferences: animated)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let item = dataSource.itemIdentifier(for: indexPath) {

            if self.selected.contains(item) {
                selected = selected.filter({ $0 != item })
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
            } else {
                selected.append(item)
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }

            if let first = dataSource.snapshot().itemIdentifiers.first, first != item,
               tableView.cellForRow(at: indexPath)?.accessoryType != UITableViewCell.AccessoryType.none
            {
                var snapshot = dataSource.snapshot()
                snapshot.moveItem(item, beforeItem: first)
                dataSource.apply(snapshot, animatingDifferences: true)
            }
        }
    }
}
