//
//  NotesSplitViewController.swift
//  SimpleNotes
//
//  Created by Grayson Bianco on 5/9/19.
//  Copyright © 2019 Grayson Bianco. All rights reserved.
//

import Foundation
import UIKit

class NotesSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        preferredDisplayMode = .allVisible
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
