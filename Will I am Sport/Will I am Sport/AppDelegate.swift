//
//  AppDelegate.swift
//  Will I am Sport
//
//


import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var orientationLock: UIInterfaceOrientationMask = .all

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
