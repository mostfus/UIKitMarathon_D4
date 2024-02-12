//
//  ViewController.swift
//  UIKitMarathon_D4
//
//  Created by Maksim Vaselkov on 10.02.2024.
//

import UIKit

class CustomCell: UITableViewCell {
    static let identifier = "cellId"

    var value: Int?
}

class ViewController: UIViewController {

    @IBAction func shuffleButton(_ sender: Any) {
        let normalCells = cells
        let shuffledCells = cells.shuffled()
        cells = shuffledCells
        shuffled = true

        var diffs = [Int: Int]()

        for (index, cell) in normalCells.enumerated() {
            guard let newIndex = shuffledCells.firstIndex(of: cell) else {
                continue
            }
            diffs[index] = newIndex
        }

        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            self?.shuffled = false
        }
        tableView.beginUpdates()

        diffs.keys.forEach { key in
            guard let value = diffs[key] else {
                return
            }
            tableView.moveRow(at: .init(row: key, section: 0), to: .init(row: value, section: 0))
        }
        tableView.endUpdates()
        CATransaction.commit()

    }

    private var cells: [CustomCell] = []

    private var shuffled = false

    private var tableView: UITableView = {
        let tv = UITableView()
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
            let cell = CustomCell()
            cell.value = i

            cells.append(cell)
        }
    }

    private func setupTableView() {
        tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)

        view.addSubview(tableView)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.layer.cornerRadius = 16
        tableView.layer.cornerCurve = .continuous
        tableView.estimatedRowHeight = 20


        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CustomCell else {
            return
        }

        cell.backgroundColor = .systemGray3

        switch cell.accessoryType {
        case .checkmark:
            cell.accessoryType = .none
        default:
            cell.accessoryType = .checkmark

            let cellForInsert = cells.remove(at: indexPath.row)
            cells.insert(cellForInsert, at: 0)

            tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
        }

        UIView.animate(withDuration: 0.5) {
            cell.backgroundColor = .clear
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cells[indexPath.row]
        cell.selectionStyle = .none

        if let value = cell.value {
            cell.textLabel?.text = "\(value)"
        }

        return cell
    }
}
