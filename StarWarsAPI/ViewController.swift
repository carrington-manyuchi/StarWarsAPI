//
//  ViewController.swift
//  StarWarsAPI
//
//  Created by Manyuchi, Carrington C on 2025/01/19.
//

import UIKit

class ViewController: UIViewController {
    
    let tableView = UITableView()
    var people: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        fetchDataStandard()
        fetchDataResultType()
    }

    private func configureTable() {
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
    }
    
    private func fetchDataStandard() {
        NetworkManager.shared.StandardfetchingData { [weak self] persons in
            guard let self = self, let persons = persons else {
                print("Failed to fetch or decode data.")
                return
            }
            
            DispatchQueue.main.async {
                self.people.append(contentsOf: persons.map { $0.name })
                self.tableView.reloadData()
            }
        }
    }
    
    
    private func fetchDataResultType() {
        NetworkManager.shared.networkCallWithResultType { [weak self] result in
            switch result {
            case .success(let persons):
               // let pple = persons.map(persons.name)
                
                DispatchQueue.main.async {
                    self?.people.append(contentsOf: persons.map{$0.name})
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = people[indexPath.row]
        return cell
    }
}
