//
//  TableViewController.swift
//  Skyeng Test
//
//  Created by Георгий Сабанов on 11.07.2020.
//  Copyright © 2020 Georgiy Sabanov. All rights reserved.
//

import UIKit

class TableViewController: ViewController {
    let tableView = UITableView(frame: .zero, style: .plain)
    override func adjustUI() {
        super.adjustUI()
        view.addSubview(tableView)
        tableView.keyboardDismissMode = .onDrag
    }
}
