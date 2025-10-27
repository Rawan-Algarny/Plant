//
//  NotificationManager.swift
//  Plant
//
//  Created by Rawan Algarny on 06/05/1447 AH.
//
//
//import UserNotifications
//import SwiftUI
//
//class NotificationManager {
//    static let shared = NotificationManager()
//    
//    // Request permission from user
//    func requestPermission() {
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//            if granted {
//                print("✅ Notification permission granted")
//            } else {
//                print("❌ Notification permission denied")
//            }
//        }
//    }
//    
//    // Schedule notification based on watering schedule
//    func scheduleNotification(for reminder: PlantReminder) {
//        let content = UNMutableNotificationContent()
//        content.title = "Planto"
//        content.body = "Hey! let's water your plant"
//        content.sound = .default
//        
//        // Get interval in seconds based on watering schedule
//        let intervalSeconds = getIntervalSeconds(from: reminder.wateringDays)
//        
//        // ✅ REPEATING TRIGGER based on time interval
//        let trigger = UNTimeIntervalNotificationTrigger(
//            timeInterval: intervalSeconds,
//            repeats: true
//        )
//        
//        // Create request with unique ID
//        let request = UNNotificationRequest(
//            identifier: reminder.id.uuidString,
//            content: content,
//            trigger: trigger
//        )
//        
//        // Schedule notification
//        UNUserNotificationCenter.current().add(request) { error in
//            if let error = error {
//                print("❌ Error scheduling notification: \(error)")
//            } else {
//                print("✅ Notification scheduled for \(reminder.name) - \(reminder.wateringDays)")
//            }
//        }
//    }
//    
//    // Cancel notification when reminder is deleted
//    func cancelNotification(for reminderId: UUID) {
//        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminderId.uuidString])
//        print("🗑️ Notification cancelled")
//    }
//    
//    // ✅ Convert watering schedule to seconds
//    private func getIntervalSeconds(from wateringDays: String) -> TimeInterval {
//        switch wateringDays {
//        case "Every day":
//            return 86400 // 24 hours in seconds
//        case "Every 2 days":
//            return 172800 // 48 hours
//        case "Every 3 days":
//            return 259200 // 72 hours
//        case "Weekly":
//            return 604800 // 7 days
//        default:
//            return 86400 // Default to daily
//        }
//    }
//}
