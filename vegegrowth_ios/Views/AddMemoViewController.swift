//
//  addMemoViewController.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/07/01.
//

import UIKit
import RxCocoa
import RxSwift

class addMemoViewController: UIViewController {

    @IBOutlet weak var memoView: UITextView!
    @IBOutlet weak var endMemoButton: UIButton!
    
    private var viewModel: AddMemoViewModelType
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bind()
    }
    
    init?(coder: NSCoder, vegeText: String, index: Int) {
        viewModel = AddMemoViewModel(vegeText: vegeText, index: index)
        super.init(coder: coder)
        
        print(vegeText)
        navigationItem.title = vegeText + " - メモ登録"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
//        endMemoButton.rx.tap
//            .bind(to: viewModel.inputs.endMemoButtonTapped)
//            .disposed(by: disposeBag)
//
//        viewModel.outputs.memoText
//            .bind(to: memoView.rx.text)
//            .disposed(by: disposeBag)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
