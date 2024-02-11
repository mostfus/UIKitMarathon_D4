//
//  ViewController.swift
//  UIKitMarathon_D4
//
//  Created by Maksim Vaselkov on 10.02.2024.
//

import UIKit

class CustomCell: UITableViewCell {
    static let identifier = "cellId"

    private(set) var cellDidSelected = false
    var indexPath: IndexPath?

    func toggleCellSelection() {
        cellDidSelected.toggle()
    }
}

class ViewController: UIViewController {

    @IBAction func shuffleButton(_ sender: Any) {
        cells = cells.shuffled()
        shuffled = true

        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            self?.shuffled = false
        }
        tableView.beginUpdates()
        tableView.reloadData()
        tableView.endUpdates()
        tableView.layoutSubviews()
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
            cell.textLabel?.text = "\(i)"
            cell.selectionStyle = .none
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

        switch cell.accessoryType {
        case .checkmark:
            cell.accessoryType = .none
        default:
            cell.accessoryType = .checkmark

            let cellForInsert = cells.remove(at: indexPath.row)
            cells.insert(cellForInsert, at: 0)

            tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cells[indexPath.row]

        return cell
    }
}
