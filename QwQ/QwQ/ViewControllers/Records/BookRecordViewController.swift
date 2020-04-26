//
//  BookRecordViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 18/3/20.
//

/**
`BookRecordViewController` shows full record details of a book record.
*/

import UIKit

class BookRecordViewController: RecordViewController {

    // MARK: View properties
    @IBOutlet private var datePicker: UIDatePicker!

    override func setUpViews() {
        super.setUpViews()

        guard let bookRecord = record as? BookRecord else {
            return
        }

        datePicker.date = bookRecord.time
    }
}
