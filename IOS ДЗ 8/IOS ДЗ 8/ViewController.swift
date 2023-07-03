//
//  ViewController.swift
//  IOS ДЗ 8
//
//  Created by Bekpayev Dias on 30.06.2023.
//

import UIKit
import SnapKit

struct Task {
    let name: String
}

class ViewController: UIViewController {
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    var tasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        makeConstraints()
    }
}

private extension ViewController {
    @objc func tap() {
        let alertController = UIAlertController(title: "Новая задача", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Введите задачу"
        }
        
        let addAction = UIAlertAction(title: "Добавить", style: .default) { [weak self] _ in
            if let textField = alertController.textFields?.first, let taskName = textField.text, !taskName.isEmpty {
                let newTask = Task(name: taskName)
                self?.tasks.append(newTask)
                self?.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func setupScene() {
        title = "My tasks"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .bold)]
        navigationController?.navigationBar.setTitleVerticalPositionAdjustment(10, for: .default)
        
        let barButton = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(tap))
        let largeButtonFont = UIFont.systemFont(ofSize: 40)
        barButton.setTitleTextAttributes([NSAttributedString.Key.font: largeButtonFont], for: .normal)
        navigationItem.rightBarButtonItem = barButton
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func makeConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        let task = tasks[indexPath.row]
        cell.configCell(labelText: task.name)
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
