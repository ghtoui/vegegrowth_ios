//
//  MainViewController.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/05/18.
//

import UIKit
import RxSwift

final class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    private let disposeBag = DisposeBag()
    private var viewModel: MainViewModelType
    
    required init?(coder: NSCoder) {
        self.viewModel = MainViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItemSettings()

        bind()
    }
    
    private func bind() {
        // テーブルの作成
        viewModel.outputs.tableData
            .drive(tableView.rx.items(cellIdentifier: "vegeCell")) {
                index, model, cell in
                    cell.textLabel?.text = model
                    cell.imageView?.image = UIImage(named: "nae")
            }
            .disposed(by: disposeBag)
        
        // セルの削除
        tableView.rx.itemDeleted
            .subscribe(onNext: { indexPath in
                self.viewModel.inputs.deleteItem.accept(indexPath.row)
            })
            .disposed(by: disposeBag)
        
        // セルをタップした時
        tableView.rx.itemSelected
            .bind { [weak self] indexPath in
                self?.viewModel.inputs.cellSelected.accept(indexPath.row)
            }
            .disposed(by: disposeBag)
        
        // タップしたlabelTextを取得
        viewModel.outputs.labelText
            .drive(onNext: { [weak self] labelText in
                self?.goTo(labelText: labelText)
            })
            .disposed(by: disposeBag)
        
        // 追加ボタンをタップした時
        addButton.rx.tap
            .bind(to: viewModel.inputs.addButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.outputs.showAlert
            .subscribe(onNext: {
                self.showAddVegeAlert()
            })
            .disposed(by: disposeBag)
    }
    
    private func showAddVegeAlert() {
        var textField = UITextField()
        let alert = UIAlertController(title: "管理する野菜の名前を入力してください",
                                      message: "",
                                      preferredStyle: .alert)
        // 追加処理
        let add_action = UIAlertAction(title: "追加",style: .default) { (action) in
            guard let text = textField.text else {
                return
            }
            // ViewModelへ通知
            self.viewModel.inputs.addTextButtonTapped.accept(text)
        }
        // キャンセル処理, 何もしない
        let cancel_action = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "野菜の名前を入力"
            textField = alertTextField
        }
        alert.addAction(add_action)
        alert.addAction(cancel_action)
            present(alert, animated: true, completion: nil)
    }
    
    // 画面遷移
    private func goTo(labelText: String) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(identifier: "GrowthRegisterView") { coder in
            return GrowthRegisterViewController(coder: coder, vegeText: labelText)
        }
        navigationController?.pushViewController(VC, animated: true)
    }
    
    private func navigationItemSettings() {
        let buttonFontSize: CGFloat = 20
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
