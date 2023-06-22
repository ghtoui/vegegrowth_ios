//
//  MainViewModel.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/06/11.
//

import Foundation
import RxSwift
import RxCocoa

protocol MainViewModelInputs {
    var addButtonTapped: PublishRelay<Void> { get }
    var addTextButtonTapped: PublishRelay<String> { get }
    var cellSelected: PublishRelay<Int> { get }
    var deleteItem: PublishRelay<Int> { get }
    
}

protocol MainViewModelOutputs {
    var tableData: Driver<[String]> { get }
    var labelText: Driver<String> { get }
    var showAlert: PublishRelay<Void> { get }
}

protocol MainViewModelType {
    var inputs: MainViewModelInputs { get }
    var outputs: MainViewModelOutputs { get }
}

final class MainViewModel: MainViewModelType,
                           MainViewModelInputs,
                           MainViewModelOutputs {
    
    var inputs: MainViewModelInputs{ return self }
    var outputs: MainViewModelOutputs{ return self }
    
    // inputs
    var addButtonTapped = PublishRelay<Void>()
    var addTextButtonTapped = PublishRelay<String>()
    var cellSelected = PublishRelay<Int>()
    var deleteItem = PublishRelay<Int>()
    
    // outputs
    var tableData: Driver<[String]> {
        return tableDataRelay.asDriver()
    }
    
    var labelText: Driver<String> {
        return labelTextRelay.asDriver(onErrorJustReturn: "")
    }
    
    var showAlert = PublishRelay<Void>()
    
    
    private let disposeBag = DisposeBag()
    private let tableManager : TablemanagerClass = TablemanagerClass()
    
    private let tableDataRelay = BehaviorRelay<[String]>(value: [])
    private let labelTextRelay = PublishRelay<String>()
    
    init() {
        getData()
        
        addButtonTapped
            .subscribe(onNext: { [weak self] _ in
                self?.showAlert.accept(())
            })
            .disposed(by: disposeBag)
        
        cellSelected
            .subscribe(onNext: { [weak self] index in
                self?.cellSelected(index: index)
            })
        
            .disposed(by: disposeBag)
        
        deleteItem
            .subscribe(onNext: { [weak self] index in
                self?.deleteItem(index: index)
            })
            .disposed(by: disposeBag)
        
        addTextButtonTapped
            .subscribe(onNext: { [weak self] text in
                self?.addTextButtonTapped(text: text)
            })
            .disposed(by: disposeBag)
    }
    
    // 選択したセルのラベルを取得
    private func cellSelected(index: Int) {
        let labelText = tableDataRelay.value[index]
        labelTextRelay.accept(labelText)
    }
    
    // 削除処理
    private func deleteItem(index: Int) {
        tableManager.deleteItem(index: index)
        getData()
    }
    
    // テキスト追加処理
    private func addTextButtonTapped(text: String) {
        tableManager.addVege(vegeText: text)
        getData()
    }
    
    // テーブルの各要素のデータを取得
    private func getName(index: Int) -> String {
        return tableDataRelay.value[index]
    }
    
    // データの取得
    private func getData() {
        tableDataRelay.accept(tableManager.getVegeList())
    }
}
