//
//  BookRecordViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 18/3/20.
//

import UIKit

class BookRecordViewController: RecordViewController {

    // MARK: View properties
    @IBOutlet var datePicker: UIDatePicker!

    override func setUpViews() {
        super.setUpViews()

        guard let bookRecord = record as? BookRecord else {
            return
        }
        datePicker.date = bookRecord.time
    }
}
