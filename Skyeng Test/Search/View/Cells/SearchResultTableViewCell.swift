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
struct SearchResultTableViewCellViewModel {
    var searchText: String?
    var title: String?
    var subtitle: String?
    var previewURL: String?
    var showsDisclosureIndicator: Bool
}

class SearchResultTableViewCell: TableViewCell {
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let previewImageView = UIImageView()
    let titleLabelFont = UIFont.preferredFont(forTextStyle: .title3)
    let subtitleLabelFont = UIFont.preferredFont(forTextStyle: .caption1)
    let titleLabelColor = UIColor.label
    let subtitleLabelColor = UIColor.secondaryLabel
    var viewModel: SearchResultTableViewCellViewModel?
    
    func configured(with viewModel: SearchResultTableViewCellViewModel) -> SearchResultTableViewCell{
        self.viewModel = viewModel
        bindViewModel()
        return self
    }
    
    func bindViewModel() {
        guard let viewModel = viewModel else { return }
        updateTitleLabel(title: viewModel.title ?? "", searchText: viewModel.searchText ?? "")
        subtitleLabel.text = viewModel.subtitle
        if let url = URL(string: "https:" + (viewModel.previewURL ?? "")) {
            previewImageView.kf.setImage(with: url)
        }
    }
    
    func updateTitleLabel(title: String, searchText: String) {
        let attrString = NSMutableAttributedString(string: title, attributes: [.font: self.titleLabelFont, .foregroundColor: self.titleLabelColor])
        let searchRange = NSString(string: title.lowercased()).range(of: searchText.lowercased())
        attrString.addAttribute(.font, value: self.titleLabelFont.boldVersion, range: searchRange)
        self.titleLabel.attributedText = attrString
        accessoryType = (viewModel?.showsDisclosureIndicator ?? false) ? .disclosureIndicator : .none
    }
    
    override func adjustUI() {
        super.adjustUI()
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
            make.trailing.equalToSuperview().offset(-44)
            make.bottom.lessThanOrEqualToSuperview().offset(-8)
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        previewImageView.kf.cancelDownloadTask()
        previewImageView.image = nil
    }
}
