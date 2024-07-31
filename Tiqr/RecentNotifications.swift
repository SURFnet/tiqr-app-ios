//
//  RecentNotifications.swift
//  Tiqr Client
//
//  Created by Dániel Zolnai on 26/07/2024.
//

import Foundation

struct RecentNotifications {
    
    private static let keyLastNotificationTimeoutTimestamp = "lastNotificationTimeoutTimestamp"
    private static let keyLastNotificationChallenge = "lastNotificationChallenge"
    
    @available(*, unavailable) private init() {}
    
    private static func defaults() -> UserDefaults {
        return UserDefaults.init(suiteName: "group.org.tiqr.surfnet.testing")!
    }
    
    static func onNewNotification(timeOut: Any?, challenge: Any?) {
        guard let challengeUrl = challenge as? String else {
            assertionFailure("Challenge is not a string! Received: \(challenge ?? "<nil>").")
            return
        }
        var timeOutSeconds = 150
        if timeOut is Int {
            timeOutSeconds = timeOut as! Int
        } else if timeOut is Float {
            timeOutSeconds = Int(timeOut as! Float)
        } else if timeOut is Double {
            timeOutSeconds = Int(timeOut as! Double)
        } else if timeOut is String {
            if let timeOutInt = Int(timeOut as! String) {
                timeOutSeconds = timeOutInt
            }
        }
        let timeoutTimestamp = Int(Date().timeIntervalSince1970) + timeOutSeconds * 1000
        let defaults = defaults()
        defaults.setValue(timeoutTimestamp, forKey: keyLastNotificationTimeoutTimestamp)
        defaults.setValue(challengeUrl, forKey: keyLastNotificationChallenge)
    }
    
    static func getLastNotificationChallenge() -> String? {
        let defaults = defaults()
        let timeoutTimestamp = defaults.integer(forKey: keyLastNotificationTimeoutTimestamp)
        if timeoutTimestamp < Int(Date().timeIntervalSince1970) {
            // Already timed out
            return nil
        }
        let challengeUrl = defaults.string(forKey: keyLastNotificationChallenge)
        // Clear so we don't trigger it twice
        defaults.removeObject(forKey: keyLastNotificationChallenge)
        defaults.removeObject(forKey: keyLastNotificationTimeoutTimestamp)
        return challengeUrl
    }
    
    
    
    
}
