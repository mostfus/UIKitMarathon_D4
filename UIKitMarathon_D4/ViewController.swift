//
//  ViewController.swift
//  UIKitMarathon_D4
//
//  Created by Maksim Vaselkov on 10.02.2024.
//

import UIKit

class ConfigCell: Equatable {
    static func == (lhs: ConfigCell, rhs: ConfigCell) -> Bool {
        lhs.value == rhs.value
    }

    var value: Int
    var isSelected: Bool

    init(value: Int, isSelected: Bool) {
        self.value = value
        self.isSelected = isSelected
    }
}

class ViewController: UIViewController {

    private let identifier = "cellId"

    func shuffleButton() {
        let normalCells = cells
        let shuffledCells = cells.shuffled()
        cells = shuffledCells

        var diffs = [Int: Int]()

        for (index, cell) in normalCells.enumerated() {
            guard let newIndex = shuffledCells.firstIndex(of: cell) else {
                continue
            }
            diffs[index] = newIndex
        }

        tableView.beginUpdates()

        diffs.keys.forEach { key in
            guard let value = diffs[key] else {
                return
            }
            tableView.moveRow(at: .init(row: key, section: 0), to: .init(row: value, section: 0))
        }
        tableView.endUpdates()
    }

    private var cells: [ConfigCell] = []

    private var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.backgroundColor = .white
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray6

        setupTableView()
        setupArray()
    }

    private func setupArray() {
        for i in 0...40 {
            let cell = ConfigCell(value: i, isSelected: false)
            cells.append(cell)
        }
    }

    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)

        view.addSubview(tableView)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false

        navigationItem.rightBarButtonItem = .init(title: "Shuffle", primaryAction: .init(handler: { [weak self] _ in
            self?.shuffleButton()
        }))

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        let cellConfig = cells[indexPath.row]
        cellConfig.isSelected.toggle()

        switch cell.accessoryType {
        case .checkmark:
            cell.accessoryType = .none
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            cell.accessoryType = .checkmark

            let newIndex = IndexPath(row: 0, section: 0)
            let cellForInsert = cells.remove(at: indexPath.row)
            cells.insert(cellForInsert, at: 0)

            tableView.moveRow(at: indexPath, to: newIndex)
            tableView.deselectRow(at: newIndex, animated: true)
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
        let config = cells[indexPath.row]

        cell.textLabel?.text = "\(config.value)"
        cell.accessoryType = config.isSelected ? .checkmark : .none

        return cell
    }
}
