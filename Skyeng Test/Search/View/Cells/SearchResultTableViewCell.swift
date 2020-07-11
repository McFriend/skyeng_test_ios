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
struct SearchResultTableViewCellData {
    var searchText: String?
    var title: String?
    var subtitle: String?
    var previewURL: String?
    var showsDisclosureIndicator: Bool
}

class SearchResultTableViewCell: TableViewCell {
    let holder = UIView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let previewImageView = UIImageView()
    let disclosureIcon = UIImageView()
    let titleLabelFont = UIFont.preferredFont(forTextStyle: .title3)
    let subtitleLabelFont = UIFont.preferredFont(forTextStyle: .caption1)
    let titleLabelColor = UIColor.label
    let subtitleLabelColor = UIColor.secondaryLabel
    var data: SearchResultTableViewCellData?
    private let scaleOnHighlightFactor = 0.95
    private let scaleOnHighlightDuration = 0.15
    
    func configured(with data: SearchResultTableViewCellData) -> SearchResultTableViewCell{
        self.data = data
        bindViewModel()
        return self
    }
    
    func bindViewModel() {
        guard let data = data else { return }
        updateTitleLabel(title: data.title ?? "", searchText: data.searchText ?? "")
        subtitleLabel.text = data.subtitle
        if let url = URL(string: data.previewURL?.httpsUrl ?? "") {
            previewImageView.kf.setImage(with: url)
        }
    }
    
    func updateTitleLabel(title: String, searchText: String) {
        let attrString = NSMutableAttributedString(string: title, attributes: [.font: self.titleLabelFont, .foregroundColor: self.titleLabelColor])
        let searchRange = NSString(string: title.lowercased()).range(of: searchText.lowercased())
        attrString.addAttribute(.font, value: self.titleLabelFont.boldVersion, range: searchRange)
        self.titleLabel.attributedText = attrString
        disclosureIcon.isHidden = !(data?.showsDisclosureIndicator ?? false)
    }
    
    override func adjustUI() {
        super.adjustUI()
        selectionStyle = .none
        addSubview(holder)
        holder.layer.cornerRadius = 12
        holder.backgroundColor = .secondarySystemBackground
        holder.addSubview(titleLabel)
        holder.addSubview(subtitleLabel)
        holder.addSubview(previewImageView)
        holder.addSubview(disclosureIcon)
        disclosureIcon.image = UIImage(systemName: "chevron.right")
        disclosureIcon.tintColor = .tertiaryLabel
        titleLabel.font = titleLabelFont
        titleLabel.textColor = titleLabelColor
        subtitleLabel.font = subtitleLabelFont
        subtitleLabel.textColor = subtitleLabelColor
        previewImageView.contentMode = .scaleAspectFill
        previewImageView.clipsToBounds = true
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        holder.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
            make.leading.equalTo(snp.leadingMargin)
            make.trailing.equalTo(snp.trailingMargin)
        }
        disclosureIcon.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
        }
        previewImageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(12)
            make.bottom.lessThanOrEqualToSuperview().offset(-12)
            make.height.equalTo(36)
            make.width.equalTo(48)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(previewImageView.snp.trailing).offset(8)
            make.top.equalToSuperview().offset(10)
            make.trailing.equalTo(disclosureIcon.snp.leading).offset(-12)
        }
        subtitleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom)
            make.trailing.equalTo(disclosureIcon.snp.leading).offset(-12)
            make.bottom.lessThanOrEqualToSuperview().offset(-12)
        }
        disclosureIcon.setContentHuggingPriority(.required, for: .horizontal)
        disclosureIcon.setContentHuggingPriority(.required, for: .vertical)

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        previewImageView.kf.cancelDownloadTask()
        previewImageView.image = nil
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted && !isHighlighted {
            let timing = CAMediaTimingFunction(name: .easeIn)
            let scaleAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
            CATransaction.begin()
            CATransaction.setAnimationTimingFunction(timing)
            scaleAnimation.duration = scaleOnHighlightDuration
            scaleAnimation.fromValue = 1
            scaleAnimation.toValue = scaleOnHighlightFactor
            scaleAnimation.fillMode = .forwards
            scaleAnimation.isRemovedOnCompletion = false
            layer.removeAllAnimations()
            layer.add(scaleAnimation, forKey: "scale")
            CATransaction.commit()
        } else if isHighlighted && !highlighted {
            let timing = CAMediaTimingFunction(name: .easeIn)
            let scaleAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
            CATransaction.begin()
            CATransaction.setAnimationTimingFunction(timing)
            scaleAnimation.duration = scaleOnHighlightDuration
            scaleAnimation.fromValue = scaleOnHighlightFactor
            scaleAnimation.toValue = 1
            scaleAnimation.fillMode = .forwards
            scaleAnimation.isRemovedOnCompletion = false
            layer.removeAllAnimations()
            layer.add(scaleAnimation, forKey: "scale")
            CATransaction.commit()
        }

        super.setHighlighted(highlighted, animated: animated)
    }

}
