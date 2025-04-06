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
    private lazy var newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
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
        contentView.addSubview(newsImageView)

        newsImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.width.equalTo(100)
            make.height.equalTo(100)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.lessThanOrEqualToSuperview().inset(16)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(16)
            make.trailing.equalTo(newsImageView.snp.leading).inset(-10)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).inset(-8)
            make.bottom.equalToSuperview().inset(16)
            make.trailing.equalTo(newsImageView.snp.leading).inset(-10)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.text = nil
        descriptionLabel.text = nil
        newsImageView.image = nil
    }

    internal func configure(
        with model: NewsListItemViewModel,
        imageRepository: ImageRepository
    ) {
        
        titleLabel.text = model.news.title
        descriptionLabel.text = model.news.description
        updateNewsImage(
            imageRepository: imageRepository,
            imageUrl: model.news.imageUrl
        )
    }

    private func updateNewsImage(imageRepository: ImageRepository, imageUrl: String) {
        newsImageView.image = nil
        Task {
            do {
                let imageData = try await imageRepository.fetchImage(with: imageUrl)
                newsImageView.image = UIImage(data: imageData)
            } catch {}
        }

    }
}
