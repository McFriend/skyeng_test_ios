//
//  DetailMeaningTranslationTableViewCell.swift
//  Skyeng Test
//
//  Created by Георгий Сабанов on 11.07.2020.
//  Copyright © 2020 Georgiy Sabanov. All rights reserved.
//

import UIKit
import RxSwift
import AVFoundation
import SnapKit
struct DetailMeaningTranslationTableViewCellData{
    let imageUrl: String
    let originalText: String
    let translatedText: String
    let audioUrl: String?
}

class DetailMeaningTranslationTableViewCell: TableViewCell {
    let detailImageView = UIImageView()
    let originalTextLabel = UILabel()
    let translatedTextLabel = UILabel()
    let audioButton = UIButton()
    var data: DetailMeaningTranslationTableViewCellData?
    var player: AVAudioPlayer?
    var audioData: Data?
    var imageWidth: Constraint?
    
    func configured(with data: DetailMeaningTranslationTableViewCellData) -> DetailMeaningTranslationTableViewCell {
        self.data = data
        originalTextLabel.text = data.originalText
        translatedTextLabel.text = data.translatedText
        detailImageView.kf.setImage(with: URL(string: data.imageUrl.httpsUrl))
        return self
    }
    
    override func adjustUI() {
        super.adjustUI()
        selectionStyle = .none
        addSubview(detailImageView)
        addSubview(originalTextLabel)
        addSubview(translatedTextLabel)
        addSubview(audioButton)
        backgroundColor = .secondarySystemBackground
        audioButton.setImage(UIImage(systemName: "speaker.3",
                                     withConfiguration: UIImage.SymbolConfiguration(weight: .bold)),
                             for: .normal)
        audioButton.setImage(UIImage(systemName: "speaker.3.fill",
                                     withConfiguration: UIImage.SymbolConfiguration(weight: .bold)),
                             for: .highlighted)
        audioButton.tintColor = .label
        originalTextLabel.textColor = .label
        translatedTextLabel.textColor = .label
        originalTextLabel.font = UIFont.preferredFont(forTextStyle: .title2).boldVersion
        translatedTextLabel.font = UIFont.preferredFont(forTextStyle: .body)
        originalTextLabel.numberOfLines = 0
        translatedTextLabel.numberOfLines = 0
        detailImageView.contentMode = .scaleAspectFit
        audioButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [unowned self] in
            self.playAudio()
        }).disposed(by: bag)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        updateImageSize()
    }
    
    func updateImageSize() {
        let screenSize = UIScreen.main.bounds
        let isPortrait = screenSize.height > screenSize.width
        detailImageView.snp.remakeConstraints { (make) in
            if isPortrait {
                make.height.equalTo(0)
            }
            make.width.equalTo(isPortrait ? 0 : 200)
            make.top.leadingMargin.equalToSuperview().offset(8)
            make.bottom.lessThanOrEqualToSuperview().offset(-8)
        }
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        detailImageView.snp.makeConstraints { (make) in
            make.width.equalTo(UIScreen.main.isPortrait ? 0 : 200)
            if UIScreen.main.isPortrait {
                make.height.equalTo(0)
            }
            make.top.leadingMargin.equalToSuperview().offset(8)
            make.bottom.lessThanOrEqualToSuperview().offset(-8)
        }
        audioButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(snp.trailingMargin).offset(-8)
            make.top.equalToSuperview().offset(16)
        }
        originalTextLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(detailImageView.snp.trailing).offset(8)
            make.top.equalToSuperview().offset(12)
            make.trailing.equalTo(audioButton.snp.leading).offset(-8)
        }
        translatedTextLabel.snp.makeConstraints { (make) in
            make.top.equalTo(originalTextLabel.snp.bottom).offset(2)
            make.leading.equalTo(detailImageView.snp.trailing).offset(8)
            make.trailing.equalTo(audioButton.snp.leading).offset(-8)
            make.bottom.lessThanOrEqualToSuperview().offset(-16).priority(.high)
        }
        audioButton.setContentHuggingPriority(.required, for: .horizontal)
        audioButton.setContentHuggingPriority(.required, for: .vertical)
        audioButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        audioButton.setContentCompressionResistancePriority(.required, for: .vertical)
        originalTextLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        translatedTextLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    func playAudio() {
        self.player?.stop()
        self.player = nil
        guard let audioURL = data?.audioUrl?.httpsUrl,
            let url = URL(string: audioURL) else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            DispatchQueue.global(qos: .userInitiated).async {
                if self.audioData == nil {
                    guard let audioData = try? Data(contentsOf: url) else { return }
                    self.audioData = audioData
                }
                DispatchQueue.main.async {
                    guard self.audioData != nil else { return }
                    self.player = try? AVAudioPlayer(data: self.audioData!)
                    self.player?.prepareToPlay()
                    self.player?.play()
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        detailImageView.kf.cancelDownloadTask()
        detailImageView.image = nil
    }
}
