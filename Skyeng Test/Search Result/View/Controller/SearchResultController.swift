//
//  SearchResultController.swift
//  Skyeng Test
//
//  Created by Георгий Сабанов on 11.07.2020.
//  Copyright © 2020 Georgiy Sabanov. All rights reserved.
//

import UIKit

class SearchResultController: TableViewController {
    var viewModel: SearchResultViewModel? {
        get {
            _viewModel as? SearchResultViewModel
        }
        set {
            _viewModel = newValue
        }
    }
    
    override func bind() {
        guard let viewModel = viewModel else { return }
        viewModel.result.map({$0.text}).bind(to: self.navigationItem.rx.title).disposed(by: viewModel.bag)
        viewModel.result.map({$0.meanings})
        .bind(to: tableView.rx.items) { (tableView, row, element) in
            if let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.typeName) as? SearchResultTableViewCell {
                return cell.configured(with: viewModel.cellData(for: element))
            }
            return UITableViewCell()
        }
        .disposed(by: viewModel.bag)
        tableView.rx.itemSelected.subscribe(onNext: { [unowned self] (indexPath) in
            self.tableView.deselectRow(at: indexPath, animated: true)
            let model = viewModel.result.value.meanings[indexPath.row]
            guard let vc = self.viewModel?.nextController(for: model) else { return }
            self.show(vc, sender: self)
        }).disposed(by: viewModel.bag)
    }
    
    override func adjustUI() {
        super.adjustUI()
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.typeName)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 4)).setBackgroundColor(to: .clear)
        tableView.separatorStyle = .none
    }

    override func configureConstraints() {
        super.configureConstraints()
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.snp.topMargin)
            make.bottom.equalToSuperview()
        }
    }
}
