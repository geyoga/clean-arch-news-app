//
//  ViewController.swift
//  news-app
//
//  Created by Georgius Yoga on 27/3/25.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    // MARK: - Properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello World"

        return label
    }()
    
    // MARK: - Life Cycles
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.title = "News App"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        initializeUI()
    }

    // MARK: - Helpers

    private func initializeUI() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}

