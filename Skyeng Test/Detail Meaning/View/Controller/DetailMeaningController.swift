//
//  DetailMeaningController.swift
//  Skyeng Test
//
//  Created by Георгий Сабанов on 11.07.2020.
//  Copyright © 2020 Georgiy Sabanov. All rights reserved.
//

import UIKit

class DetailMeaningController: TableViewController {
    var viewModel: DetailMeaningViewModel? {
        get {
            _viewModel as? DetailMeaningViewModel
        }
        set {
            _viewModel = newValue
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel?.model.accept(viewModel?.model.value)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
    override func bind() {
        super.bind()
        guard let viewModel = viewModel else { return }
        viewModel.model.map({$0?.text}).bind(to: navigationItem.rx.title).disposed(by: viewModel.bag)
        viewModel.model.compactMap({$0}).map({ model -> [Any] in
            var cells: [Any] = []
            if UIScreen.main.isPortrait {
                cells.append(DetailMeaningHeaderTableViewCellData(imageUrl: model.images?.first?.url ?? ""))
            }
            cells.append(DetailMeaningTranslationTableViewCellData(imageUrl: model.images?.first?.url ?? "", originalText: [model.prefix, model.text].compactMap({$0}).joined(separator: " "), translatedText: model.translation?.text ?? "", audioUrl: model.soundUrl))
            cells.append(DetailMeaningDescriptionTableViewCellData(transcript: model.transcription ?? "", description: model.definition?.text ?? "", partOfSpeech: model.partOfSpeechCode?.localizedValue ?? ""))
            if let mnemonics = model.mnemonics {
                cells.append(DetailMeaningLearnTipsTableViewCellData(title: "HOW_TO_LEARN".localized.uppercased(), text: mnemonics))
            }
            return cells
        }).bind(to: self.tableView.rx.items) { tableView, row, element  in
            if let model = element as? DetailMeaningHeaderTableViewCellData, let cell = tableView.dequeueReusableCell(withIdentifier: DetailMeaningHeaderTableViewCell.typeName) as? DetailMeaningHeaderTableViewCell {
                return cell.configured(with: model)
            }
            if let model = element as? DetailMeaningTranslationTableViewCellData, let cell = tableView.dequeueReusableCell(withIdentifier: DetailMeaningTranslationTableViewCell.typeName) as? DetailMeaningTranslationTableViewCell {
                return cell.configured(with: model)
            }
            if let model = element as? DetailMeaningDescriptionTableViewCellData, let cell = tableView.dequeueReusableCell(withIdentifier: DetailMeaningDescriptionTableViewCell.typeName) as? DetailMeaningDescriptionTableViewCell {
                return cell.configured(with: model)
            }
            if let model = element as? DetailMeaningLearnTipsTableViewCellData, let cell = tableView.dequeueReusableCell(withIdentifier: DetailMeaningLearnTipsTableViewCell.typeName) as? DetailMeaningLearnTipsTableViewCell {
                return cell.configured(with: model)
            }
            return UITableViewCell()
        }.disposed(by: viewModel.bag)
        tableView.rx.itemSelected.subscribe(onNext: { [unowned self] (indexPath) in
            self.tableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: viewModel.bag)
    }
    
    override func adjustUI() {
        super.adjustUI()
        tableView.register(DetailMeaningHeaderTableViewCell.self, forCellReuseIdentifier: DetailMeaningHeaderTableViewCell.typeName)
        tableView.register(DetailMeaningTranslationTableViewCell.self, forCellReuseIdentifier: DetailMeaningTranslationTableViewCell.typeName)
        tableView.register(DetailMeaningDescriptionTableViewCell.self, forCellReuseIdentifier: DetailMeaningDescriptionTableViewCell.typeName)
        tableView.register(DetailMeaningLearnTipsTableViewCell.self, forCellReuseIdentifier: DetailMeaningLearnTipsTableViewCell.typeName)
        tableView.tableFooterView = UIView()
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
