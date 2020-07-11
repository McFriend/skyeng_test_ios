//
//  SearchResultTableViewCell.swift
//  Skyeng Test
//
//  Created by Георгий Сабанов on 11.07.2020.
//  Copyright © 2020 Georgiy Sabanov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import RxKingfisher
class SearchResultTableViewCellViewModel: ViewModel {
    var searchText: BehaviorRelay<String?>
    var title: BehaviorRelay<String?>
    var subtitle: BehaviorRelay<String?>
    var previewURL: BehaviorRelay<String?>

    init(searchText: BehaviorRelay<String?>, title: BehaviorRelay<String?>, subtitle: BehaviorRelay<String?>, previewURL: BehaviorRelay<String?>) {
        self.searchText = searchText
        self.title = title
        self.subtitle = subtitle
        self.previewURL = previewURL
    }
}

class SearchResultTableViewCell: TableViewCell {
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let previewImageView = UIImageView()
    let titleLabelFont = UIFont.preferredFont(forTextStyle: .title3)
    let subtitleLabelFont = UIFont.preferredFont(forTextStyle: .caption1)
    let titleLabelColor = UIColor.label
    let subtitleLabelColor = UIColor.secondaryLabel

    var viewModel: SearchResultTableViewCellViewModel? {
        get {
            _viewModel as? SearchResultTableViewCellViewModel
        }
        set {
            _viewModel = newValue
        }
    }
            
    func configured(with viewModel: SearchResultTableViewCellViewModel) -> SearchResultTableViewCell{
        prepareForReuse()
        self.viewModel = viewModel
        bindViewModel()
        return self
    }
    
    func bindViewModel() {
        guard let viewModel = viewModel else { return }
        Observable.combineLatest(viewModel.title.map({$0 ?? ""}), viewModel.searchText.map({$0 ?? ""})).map { [unowned self] (title, searchText) -> NSAttributedString in
            let attrString = NSMutableAttributedString(string: title, attributes: [.font: self.titleLabelFont, .foregroundColor: self.titleLabelColor])
            let searchRange = NSString(string: title).range(of: searchText)
            attrString.addAttribute(.font, value: self.titleLabelFont.boldVersion, range: searchRange)
            return attrString
        }.bind(to: titleLabel.rx.attributedText).disposed(by: viewModel.bag)
        viewModel.subtitle.bind(to: subtitleLabel.rx.text).disposed(by: viewModel.bag)
        viewModel.previewURL.map({"https:" + ($0 ?? "")}).compactMap({URL(string: $0)}).bind(to: previewImageView.kf.rx.image()).disposed(by: viewModel.bag)
    }
    
    override func adjustUI() {
        super.adjustUI()
        accessoryType = .disclosureIndicator
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(previewImageView)
        titleLabel.font = titleLabelFont
        titleLabel.textColor = titleLabelColor
        subtitleLabel.font = subtitleLabelFont
        subtitleLabel.textColor = subtitleLabelColor
        previewImageView.contentMode = .scaleAspectFill
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        previewImageView.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview().offset(8)
            make.bottom.lessThanOrEqualToSuperview().offset(-8)
            make.height.equalTo(36)
            make.width.equalTo(48)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(previewImageView.snp.trailing).offset(8)
            make.top.equalToSuperview().offset(6)
            make.trailing.equalToSuperview().offset(-8)
        }
        subtitleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.lessThanOrEqualToSuperview().offset(-8)
        }
    }
}
