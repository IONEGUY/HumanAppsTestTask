//
//  MainTabBarViewController.swift
//  HumanAppsTestTask
//
//  Created by lifetech on 5.02.2025.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainViewController = MainScreenViewController(viewModel: MainScreenViewModel())
        let settingsViewController = SettingsViewController(viewModel: SettingsViewModel())

        mainViewController.tabBarItem = UITabBarItem(
            title: GlobalConstants.mainScreenTitle,
            image: UIImage(systemName: "photo.on.rectangle"),
            tag: 0
        )
        settingsViewController.tabBarItem = UITabBarItem(
            title: GlobalConstants.settingsTabTitle,
            image: UIImage(systemName: "gear"),
            tag: 1
        )

        viewControllers = [mainViewController, settingsViewController]
            .map { UINavigationController(rootViewController: $0) }
    }
}
