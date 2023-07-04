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

    @IBOutlet weak var saveCompleteView: UIView!
    @IBOutlet weak var memoView: UITextView!
    @IBOutlet weak var endMemoButton: UIButton!
    
    private var vegeText: String
    private var index: Int
    private var viewModel: AddMemoViewModelType
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        memoView.text = "\(index)"
        bind()
        navigationItemSettings()
    }
    
    init?(coder: NSCoder, vegeText: String, index: Int) {
        viewModel = AddMemoViewModel(vegeText: vegeText, index: index)
        self.vegeText = vegeText
        self.index = index
        super.init(coder: coder)
        
        
        print(vegeText)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        endMemoButton.rx.tap
            .bind(to: viewModel.inputs.endMemoButtonTapped)
            .disposed(by: disposeBag)
        
        memoView.rx.text
            .subscribe(onNext: { [weak self] memoText in
                self?.viewModel.inputs.memoText.accept(memoText ?? "")
            })
            .disposed(by: disposeBag)

        viewModel.outputs.initialMemoText
            .drive(memoView.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.endMemo
            .subscribe(onNext: {[weak self] in
                self?.saveComplete()
            })
            .disposed(by: disposeBag)
    }
    
    // 表示して、n秒後に消す処理
    private func saveComplete() {
        let TIME: Double = 2
        saveCompleteView.isHidden = false
        Timer.scheduledTimer(withTimeInterval: TIME, repeats: false) { timer in
            self.saveCompleteView.isHidden = true
        }
    }
    
    private func navigationItemSettings() {
        // ボタンのサイズ
        let buttonFontSize: CGFloat = 20
        // titleの設定
        navigationItem.title = vegeText + " - メモ登録"
        
        // 右ボタンの設定
        if let rightButton = navigationItem.rightBarButtonItem {
            let attributes: [NSAttributedString.Key: Any] = [
                // フォントサイズを設定
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: buttonFontSize)             ]
            rightButton.setTitleTextAttributes(attributes, for: .normal)
        }
        
        // バックボタンを矢印だけにする
        navigationItem.backButtonDisplayMode = .minimal
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
