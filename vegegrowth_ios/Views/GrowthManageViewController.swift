//
//  GraphControllerViewController.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/06/02.
//

import UIKit
import Charts
import RxSwift
import RxCocoa

class GrowthManageViewController: BaseManageViewController {
    
    @IBOutlet weak var editMemoButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        viewModel.inputs.vegeText.accept(vegeText)
    }
    
    init?(coder: NSCoder, vegeText: String) {
        super.init(coder: coder)
        print(vegeText)
        // タイトル変更(タップしたラベルを反映する)
        // navigationcontrollerを使っている
        viewModel = GrowthManageViewModel()
        navigationItem.title = vegeText
        self.vegeText = vegeText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind() {
        super.bind()
        editMemoButton.rx.tap
            .bind(to: viewModel.inputs.editMemoButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.outputs.moveEditMemoView
            .subscribe(onNext: { [weak self] in
                guard let vegeText: String = self?.vegeText, let index: Int = self?.currentIndex else {
                    return
                }
                self?.moveEditMemoView(vegeText: vegeText, index: index)
            })
            .disposed(by: disposeBag)
    }
    
    private func moveEditMemoView(vegeText: String, index: Int) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(identifier: "AddMemoView") { coder in
            return addMemoViewController(coder: coder, vegeText: vegeText, index: index)
        }
        navigationController?.pushViewController(VC, animated: true)
    }
}
