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
        viewModel.outputs.tableData
            .drive(tableView.rx.items(cellIdentifier: "browseCell")) {
                index, model, cell in
                cell.textLabel?.text = model.name
                cell.imageView?.image = UIImage(named: "nae")
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.isLoading
            .drive(loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    private func initialLoadingIndicator() {
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
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
