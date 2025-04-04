//
//  NewsListItemCell.swift
//  news-app
//
//  Created by Georgius Yoga on 2/4/25.
//

import UIKit
import SnapKit

final class NewsListItemCell: UITableViewCell {

    // MARK: - Properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
            .font(.systemFont(ofSize: 18, weight: .bold))
            .textColor(.black)
            .align(.left)
            .numberOfLines(-1)

        return label
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
            .font(.systemFont(ofSize: 12, weight: .regular))
            .textColor(.systemGray)
            .align(.left)
            .numberOfLines(4)

        return label
    }()

    // MARK: - Life Cycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }

    // MARK: - Helpers

    private func commonInit() {
        backgroundColor = .secondarySystemGroupedBackground
        selectionStyle = .none
        setupViewLayout()
    }

    private func setupViewLayout() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(12)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).inset(-8)
            make.bottom.equalToSuperview().inset(16)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.text = nil
        descriptionLabel.text = nil
    }

    internal func configure(with model: NewsListItemViewModel) {
        
        titleLabel.text = model.news.title
        descriptionLabel.text = model.news.description
    }
}
