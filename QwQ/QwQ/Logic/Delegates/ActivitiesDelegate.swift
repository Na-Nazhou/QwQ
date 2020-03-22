//
//  ActivitiesDelegate.swift
//  QwQ
//
//  Created by Nazhou Na on 18/3/20.
//

protocol ActivitiesDelegate: AnyObject {

    func didLoadNewHistoryRecords()

    func didUpdateQueueRecord()

    func didDeleteQueueRecord()
    
    func didDeleteBookRecord()
}
