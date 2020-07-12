//
//  SearchViewController.swift
//  Skyeng Test
//
//  Created by Георгий Сабанов on 11.07.2020.
//  Copyright © 2020 Georgiy Sabanov. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class SearchViewController: TableViewController {
    let searchField = UISearchBar()
    var viewModel: SearchViewModel? {
        get {
            _viewModel as? SearchViewModel
        }
        set {
            _viewModel = newValue
        }
    }
    
    override func bind() {
        guard let viewModel = viewModel else { return }
        viewModel.title.bind(to: self.navigationItem.rx.title).disposed(by: viewModel.bag)
        viewModel.results.compactMap({$0})
        .bind(to: tableView.rx.items) { (tableView, row, element) in
            if let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.typeName) as? SearchResultTableViewCell {
                return cell.configured(with: viewModel.cellData(for: element))
            }
            return UITableViewCell()
        }
        .disposed(by: viewModel.bag)
        tableView.rx.willDisplayCell.compactMap({ [unowned self] event -> Int? in
            guard self.viewModel?.loadedAll.value != true else { return nil }
            let total = event.indexPath.row + 1
            let pageSize = viewModel.pageSize.value
            let (q, r) = total.quotientAndRemainder(dividingBy: pageSize)
            let nextPage = q + 1
            if r == 0, nextPage != viewModel.page.value {
                return nextPage
            } else {
                return nil
            }
        }).bind(to: viewModel.page).disposed(by: viewModel.bag)
        tableView.rx.itemSelected.subscribe(onNext: { [unowned self] (indexPath) in
            self.tableView.deselectRow(at: indexPath, animated: true)
            guard let model = viewModel.results.value?[indexPath.row], let vc = self.viewModel?.nextController(for: model) else { return }
            self.show(vc, sender: self)
        }).disposed(by: viewModel.bag)
        searchField
            .rx.text
            .orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.searchText)
            .disposed(by: viewModel.bag)
        viewModel.searchPlaceholder.subscribe(onNext: { [unowned self] newValue in
            self.searchField.placeholder = newValue
        }).disposed(by: viewModel.bag)
        searchField.rx.searchButtonClicked.subscribe(onNext: { [unowned self] in
            if self.searchField.isFirstResponder {
                self.searchField.resignFirstResponder()
            }
        }).disposed(by: viewModel.bag)
    }
    
    override func adjustUI() {
        super.adjustUI()
        searchField.searchBarStyle = .minimal
        view.addSubview(searchField)
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.typeName)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 8)).setBackgroundColor(to: .clear)
        tableView.separatorStyle = .none
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        searchField.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.topMargin)
            make.leading.trailing.equalToSuperview()
        }
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(searchField.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
}
