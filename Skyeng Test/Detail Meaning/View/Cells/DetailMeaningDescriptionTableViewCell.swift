//
//  DetailMeaningDescriptionTableViewCell.swift
//  Skyeng Test
//
//  Created by Георгий Сабанов on 11.07.2020.
//  Copyright © 2020 Georgiy Sabanov. All rights reserved.
//

import UIKit
struct DetailMeaningDescriptionTableViewCellData {
    let transcript: String
    let description: String
    let partOfSpeech: String
}
class DetailMeaningDescriptionTableViewCell: TableViewCell {
    let transcriptLabel = UILabel()
    let descriptionLabel = UILabel()
    let partOfSpeechLabel = UILabel()
    
    
    func configured(with data: DetailMeaningDescriptionTableViewCellData) -> DetailMeaningDescriptionTableViewCell {
        transcriptLabel.text = data.transcript
        descriptionLabel.text = data.description
        partOfSpeechLabel.text = data.partOfSpeech
        return self
    }
    
    override func adjustUI() {
        super.adjustUI()
        selectionStyle = .none
        addSubview(transcriptLabel)
        addSubview(descriptionLabel)
        addSubview(partOfSpeechLabel)
        transcriptLabel.font = UIFont.preferredFont(forTextStyle: .title2).boldVersion
        descriptionLabel.font = .preferredFont(forTextStyle: .body)
        partOfSpeechLabel.font = .preferredFont(forTextStyle: .caption1)
        transcriptLabel.textColor = .label
        descriptionLabel.textColor = .label
        partOfSpeechLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0
        transcriptLabel.numberOfLines = 0
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        partOfSpeechLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(snp.leadingMargin).offset(8)
            make.top.equalToSuperview().offset(8)
            make.trailing.equalTo(snp.trailingMargin).offset(-8)
        }
        transcriptLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(partOfSpeechLabel)
            make.trailing.equalTo(partOfSpeechLabel)
            make.top.equalTo(partOfSpeechLabel.snp.bottom)
        }
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(transcriptLabel.snp.bottom)
            make.leading.equalTo(partOfSpeechLabel)
            make.trailing.equalTo(partOfSpeechLabel)
            make.bottom.equalToSuperview().offset(-8).priority(.high)
        }
    }
}
