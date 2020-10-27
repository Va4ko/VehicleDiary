//
//  Reminder.swift
//  VehicleDiary
//
//  Created by Vachko on 26.10.20.
//

import Foundation
import UserNotifications

class Reminder: Codable {
    var text: String
    var dueDate: Date
    var reminderID: String
    
    init(_ text: String, dueDate: Date) {
        self.text = text
        self.dueDate = dueDate
        reminderID = text
    }
    
    deinit {
        removeNotification()
    }
    
    func scheduleNotification() {
        removeNotification()
        if dueDate > Date() {
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = UNNotificationSound.default
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: dueDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(
                identifier: reminderID, content: content,
                trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request)
        }

    }
    
    private func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(
            withIdentifiers: ["\(reminderID)"])
    }
}

extension Reminder: Equatable {
    static func == (lhs: Reminder, rhs: Reminder) -> Bool {
        lhs.dueDate == rhs.dueDate
    }
}
