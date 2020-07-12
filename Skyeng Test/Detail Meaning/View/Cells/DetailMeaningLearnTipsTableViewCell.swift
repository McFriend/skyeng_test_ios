//
//  DetailMeaningLearnTipsTableViewCell.swift
//  Skyeng Test
//
//  Created by Георгий Сабанов on 12.07.2020.
//  Copyright © 2020 Georgiy Sabanov. All rights reserved.
//

import UIKit
struct DetailMeaningLearnTipsTableViewCellData {
    let title: String
    let text: String
}
class DetailMeaningLearnTipsTableViewCell: TableViewCell {
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    var data: DetailMeaningLearnTipsTableViewCellData?
    
    override func adjustUI() {
        super.adjustUI()
        selectionStyle = .none
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        titleLabel.textColor = .secondaryLabel
        titleLabel.font = .preferredFont(forTextStyle: .caption1)
        subtitleLabel.textColor = .label
        subtitleLabel.font = .preferredFont(forTextStyle: .body)
        subtitleLabel.numberOfLines = 0
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(snp.leadingMargin).offset(8)
            make.trailing.equalTo(snp.trailingMargin).offset(-8)
            make.top.equalToSuperview().offset(8)
        }
        subtitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(snp.leadingMargin).offset(8)
            make.trailing.equalTo(snp.trailingMargin).offset(-8)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if let text = data?.text, let html = getHtmlForText(text: text) {
            subtitleLabel.setAttributedText(fromHtml: html)
        }
    }
    
    func configured(with data: DetailMeaningLearnTipsTableViewCellData) -> DetailMeaningLearnTipsTableViewCell {
        titleLabel.text = data.title
        if let html = getHtmlForText(text: data.text.trimmingCharacters(in: .whitespacesAndNewlines)) {
            subtitleLabel.setAttributedText(fromHtml: html)
        }
        return self
    }
    
    func getHtmlForText(text: String) -> String? {
        let htmlPath: String
        if traitCollection.userInterfaceStyle == .dark {
            htmlPath = Bundle.main.path(forResource: "main_dark", ofType: "html") ?? ""
        } else {
            htmlPath = Bundle.main.path(forResource: "main_light", ofType: "html") ?? ""
        }
        guard !htmlPath.isEmpty else { return nil }
        let url = URL(fileURLWithPath: htmlPath)
        guard let html = try? String(contentsOf: url, encoding: .utf8) else { return nil }
        return String(format: html, text)
    }
}
