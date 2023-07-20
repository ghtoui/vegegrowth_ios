//
//  BrowseViewModel.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/07/15.
//

import Foundation
import RxSwift
import RxCocoa

protocol BrowseViewModelInputs {
    var cellSelected: PublishRelay<Int> { get }
    var reloadButtonTapped: PublishRelay<Void> { get }
}

protocol BrowseViewModelOutputs {
    var tableData: Driver<[BrowseData]> { get }
    var isLoading: Driver<Bool> { get }
    var selectedModel: PublishRelay<BrowseData> { get }
}

protocol BrowseViewModelType {
    var inputs: BrowseViewModelInputs { get }
    var outputs: BrowseViewModelOutputs { get }
}

class BrowseViewModel: BrowseViewModelType, BrowseViewModelInputs, BrowseViewModelOutputs {
    
    var inputs: BrowseViewModelInputs { return self }
    var outputs: BrowseViewModelOutputs { return self }
    
    // MARK: -inputs
    var cellSelected = PublishRelay<Int>()
    var reloadButtonTapped = PublishRelay<Void>()
    
    // MARK: -outputs
    var tableData: Driver<[BrowseData]>
    var isLoading: Driver<Bool>
    var selectedModel = PublishRelay<BrowseData>()
    
    private let tableDataRelay: BehaviorRelay<[BrowseData]> = BehaviorRelay(value: [])
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    private var browse = browseClass()
    
    private let disposeBag = DisposeBag()
    
    init() {
        tableData = tableDataRelay.asDriver(onErrorDriveWith: .empty())
        isLoading = isLoadingRelay.asDriver(onErrorDriveWith: .empty())
        
        cellSelected
            .subscribe(onNext: { [weak self] index in
                self?.cellSelected(index: index)
            })
            .disposed(by: disposeBag)
        
        // 更新ボタンを押したら、リロードするように
        reloadButtonTapped
                .subscribe(onNext: { [weak self] _ in
                    self?.getData()
                })
                .disposed(by: disposeBag)
        
        getData()
    }
    
    private func getData() {
        // データの検知したら、tableDataRelayに値が挿入される
        // 最初にonsubscribeが実行され、終了時にdoが実行される
        browse.fetchData()
            .asDriver(onErrorDriveWith: .empty())
            .do(onCompleted: { [weak self] in
                // ローディングの終了
                self?.isLoadingRelay.accept(false)
            }, onSubscribe: { [weak self] in
                // ローディングの開始
                self?.isLoadingRelay.accept(true)
            })
            .drive(tableDataRelay)
            .disposed(by: disposeBag)
        sendData()
    }
    
    private func sendData() {
        browse.sendData()
            .subscribe(onNext: { bool in
                print("----------")
                print(bool)
                print("----------")
            })
            .disposed(by: disposeBag)
    }
    
    // 選択したセルを取得
    private func cellSelected(index: Int) {
        let model = tableDataRelay.value[index]
        selectedModel.accept(model)
    }
}
