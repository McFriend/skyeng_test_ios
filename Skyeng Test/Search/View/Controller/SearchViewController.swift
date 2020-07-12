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
    let hintLabel = UILabel()
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
        
        Observable.combineLatest(viewModel.hint, viewModel.hintImage).map { [unowned self] (hint, image) -> NSAttributedString? in
            guard hint != nil || image != nil else { return nil }
            let attrString = NSMutableAttributedString()
            if let image = image {
                attrString.append(NSAttributedString(attachment: image))
            }
            if let hint = hint {
                attrString.append(NSAttributedString(string: "\n\n" + hint, attributes: [.font: self.hintLabel.font ?? UIFont.systemFont(ofSize: 15), .foregroundColor: self.hintLabel.textColor ?? UIColor.label]))
            }
            return attrString
        }.do(onNext: { [unowned self] (attrString) in
            self.hintLabel.isHidden = attrString == nil
            self.tableView.isHidden = attrString != nil
        }).bind(to: hintLabel.rx.attributedText).disposed(by: viewModel.bag)
    }
    
    override func adjustUI() {
        super.adjustUI()
        searchField.searchBarStyle = .minimal
        view.addSubview(searchField)
        view.addSubview(hintLabel)
        view.sendSubviewToBack(hintLabel)
        hintLabel.font = .preferredFont(forTextStyle: .headline)
        hintLabel.textColor = .secondaryLabel
        hintLabel.textAlignment = .center
        hintLabel.numberOfLines = 0
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
        hintLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(tableView.snp.centerY)
            make.leading.equalTo(view.snp.leadingMargin).offset(16)
            make.trailing.equalTo(view.snp.trailingMargin).offset(-16)
        }
    }
}
