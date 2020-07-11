//
//  DetailMeaningHeaderTableViewCell.swift
//  Skyeng Test
//
//  Created by Георгий Сабанов on 11.07.2020.
//  Copyright © 2020 Georgiy Sabanov. All rights reserved.
//

import UIKit

struct DetailMeaningHeaderTableViewCellData {
    let imageUrl: String
}
class DetailMeaningHeaderTableViewCell: TableViewCell {
    let detailImageView = UIImageView()
    
    override func adjustUI() {
        super.adjustUI()
        selectionStyle = .none
        addSubview(detailImageView)
        detailImageView.contentMode = .scaleAspectFill
        detailImageView.clipsToBounds = true
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        detailImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            if UIScreen.main.isPortrait {
                make.width.equalTo(detailImageView.snp.height).multipliedBy(16.0/9.0).priority(.high)
            } else {
                make.height.equalTo(0)
            }
        }
    }
    
    func configured(with data: DetailMeaningHeaderTableViewCellData) -> DetailMeaningHeaderTableViewCell {
        detailImageView.kf.setImage(with: URL(string: data.imageUrl.httpsUrl))
        return self
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        detailImageView.kf.cancelDownloadTask()
        detailImageView.image = nil
    }
}
