//
//  PopoverContentController.swift
//  QwQ
//
//  Created by Tan Su Yee on 19/3/20.
//

import UIKit

class PopoverContentController: UIViewController {
    let sortCriteria = Constants.sortCriteria
    var delegate: PopoverContentControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension PopoverContentController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortCriteria.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: Constants.popoverContentReuseIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: Constants.popoverContentReuseIdentifier)
        }
        cell?.textLabel?.text = sortCriteria[indexPath.row]
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedVehicle = sortCriteria[indexPath.row]
        self.delegate?.popoverContent(controller: self, didselectItem: selectedVehicle)
        self.dismiss(animated: true, completion: nil)
    }
}

protocol PopoverContentControllerDelegate: AnyObject {
    func popoverContent(controller: PopoverContentController, didselectItem name: String)
}
