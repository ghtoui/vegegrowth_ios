//
//  BrowseViewController.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/07/14.
//

import UIKit
import RxSwift
import RxCocoa

class BrowseViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    
    private let loadingIndicator = UIActivityIndicatorView(style: .gray)

    private var viewModel: BrowseViewModelType!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 画面が表示されたら処理を開始
        viewModel = BrowseViewModel()
        // Do any additional setup after loading the view.
        // ローディングの設定
        initialLoadingIndicator()
        bind()
    }
    
    private func bind() {
        // テーブル作成
        viewModel.outputs.tableData
            .drive(tableView.rx.items(cellIdentifier: "browseCell")) {
                index, model, cell in
                cell.textLabel?.text = model.name
                cell.imageView?.image = UIImage(named: "nae")
            }
            .disposed(by: disposeBag)
        
        // loading処理
        viewModel.outputs.isLoading
            .drive(loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        // セルをタップした時
        tableView.rx.itemSelected
            .bind { [weak self] indexPath in
                self?.viewModel.inputs.cellSelected.accept(indexPath.row)
            }
            .disposed(by: disposeBag)
        
        // タップしたmodelを取得
        viewModel.outputs.selectedModel
            .subscribe(onNext: { [weak self] model in
                self?.goTo(model: model)
            })
            .disposed(by: disposeBag)
        
        reloadButton.rx.tap
            .bind(to: viewModel.inputs.reloadButtonTapped)
            .disposed(by: disposeBag)
    }
    
    private func initialLoadingIndicator() {
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
    }
    
    // 画面遷移
    private func goTo(model: BrowseData) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(identifier: "ViewerView") { coder in
            return ViewerViewController(coder: coder, model: model)
        }
        navigationController?.pushViewController(VC, animated: true)
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
