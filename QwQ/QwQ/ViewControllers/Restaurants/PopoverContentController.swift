//
//  PopoverContentController.swift
//  QwQ
//
//  Created by Tan Su Yee on 19/3/20.
//

/**
`PopoverContentController` displays sort criteria in a popover format.
*/

import UIKit

class PopoverContentController: UIViewController {

    // MARK: View properties
    @IBOutlet private var tableView: PopoverTableView!

    let sortCriteria = Constants.sortCriteria
    weak var delegate: PopoverContentControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.maxHeight = Constants.maxTableHeight
    }
}

extension PopoverContentController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortCriteria.count
    }
    
    /// Set up sort criteria display
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: Constants.popoverContentReuseIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: Constants.popoverContentReuseIdentifier)
        }
        cell?.textLabel?.text = sortCriteria[indexPath.row]
        return cell ?? UITableViewCell()
    }
    
    /// Call delegate when a cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedVehicle = sortCriteria[indexPath.row]
        self.delegate?.popoverContent(controller: self, didselectItem: selectedVehicle)
        self.dismiss(animated: true, completion: nil)
    }
}
