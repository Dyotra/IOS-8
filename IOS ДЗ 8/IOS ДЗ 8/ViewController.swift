import UIKit
import SnapKit

protocol TaskComposite {
    var parent: TaskComposite? { get set }
    var children: [TaskComposite] { get set }
    var name: String? { get set }
}

class Task: TaskComposite {
    var parent: TaskComposite?
    var children: [TaskComposite] = []
    var name: String?
    
    init(parent: TaskComposite?) {
        self.parent = parent
    }
}

class ViewController: UIViewController {
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    var task: TaskComposite?
    
    init(task: TaskComposite) {
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        makeConstraints()
    }
    
    @objc func tap() {
        let alertController = UIAlertController(title: "Новая задача", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Введите задачу"
        }
        
        let action = UIAlertAction(title: "Добавить", style: .default, handler: { (action) -> Void in
            if let text = (alertController.textFields?[0] as? UITextField)?.text {
                let newTask = Task(parent: self.task)
                newTask.name = text
                self.task?.children.append(newTask)
                self.tableView.reloadData()
            }
        })
        
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        
        alertController.addAction(action)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
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
        title = task?.name
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
        return task?.children.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = task?.children[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let subTask = task?.children[indexPath.row]
        let viewContoller = ViewController(task: subTask!)
        navigationController?.pushViewController(viewContoller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            task?.children.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}


