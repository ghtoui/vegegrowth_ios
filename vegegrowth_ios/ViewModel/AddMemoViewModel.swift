//
//  AddMemoViewModel.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/07/01.
//

import Foundation
import RxCocoa
import RxSwift

protocol AddMemoViewModelInputs {
    var endMemoButtonTapped: PublishRelay<Void> { get }
    var memoText: PublishRelay<String> { get }
}

protocol AddMemoViewModelOutputs {
    var initialMemoText: Driver<String> { get }
    var endMemo: PublishRelay<Void> { get }
}

protocol AddMemoViewModelType {
    var inputs: AddMemoViewModelInputs { get }
    var outputs: AddMemoViewModelOutputs { get }
}

final class AddMemoViewModel: AddMemoViewModelType, AddMemoViewModelInputs, AddMemoViewModelOutputs {
    
    var inputs: AddMemoViewModelInputs { return self }
    var outputs: AddMemoViewModelOutputs { return self }
    
    // MARK: - inputs
    var endMemoButtonTapped =  PublishRelay<Void>()
    var memoText = PublishRelay<String>()

    // MARK: - outsputs
    var initialMemoText: Driver<String>
    var endMemo = PublishRelay<Void>()
    
    private var index: Int
    private var memoTextRelay = BehaviorRelay(value: "")
    
    private var detailVege: DetailVegeClass
    private var vegeManager = VegeManagerClass()
    
    private let disposeBag = DisposeBag()
    
    init(vegeText: String, index: Int) {
        self.index = index
        
        let vegeIdDict = vegeManager.getVegeIdDict()
        guard let vegeId = vegeIdDict[vegeText] else {
            fatalError("vegeIdが見つかりません")
        }
        detailVege = DetailVegeClass(vegeId: vegeId)
        
        initialMemoText = memoTextRelay.asDriver(onErrorDriveWith: .empty())
        
        getMemoText()
        
        endMemoButtonTapped
            .withLatestFrom(memoText)
            .subscribe(onNext: {[weak self] text in
                self?.saveMemo(memoText: text)
            })
            .disposed(by: disposeBag)
    }
    
    private func saveMemo(memoText: String) {
        var datas = detailVege.getUserDetailVegeList()
        guard !datas.isEmpty else {
            return
        }
        detailVege.editDetailMemo(index: index, memoText: memoText)
        
        endMemo.accept(())
    }
    
    private func getMemoText() {
        let datas = detailVege.getUserDetailVegeList()
        guard !datas.isEmpty else {
            return
        }
        let data = datas[index]
        let memoText = data.memoText
        self.memoTextRelay.accept(memoText)
    }
}
