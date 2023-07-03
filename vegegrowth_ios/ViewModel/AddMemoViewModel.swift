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
    var endMemoButtonTapped: PublishRelay<String> { get }
}

protocol AddMemoViewModelOutputs {
    var memoText: BehaviorRelay<String> { get }
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
    var endMemoButtonTapped =  PublishRelay<String>()

    // MARK: - outsputs
    var memoText = BehaviorRelay<String>(value: "")
    var endMemo = PublishRelay<Void>()
    
    private var detailVege: DetailVegeClass
    private var vegeManager = VegeManagerClass()
    
    init(vegeText: String, index: Int) {
        let vegeIdDict = vegeManager.getVegeIdDict()
        guard let vegeId = vegeIdDict[vegeText] else {
            fatalError("vegeIdが見つかりません")
        }
        detailVege = DetailVegeClass(vegeId: vegeId)
        getMemoText(index: index)
    }
    private func getMemoText(index: Int) {
        let datas = detailVege.getUserDetailVegeList()
        guard !datas.isEmpty else {
            return
        }
        let data = datas[index]
        var memoText = data.memoText
        self.memoText.accept(memoText)
    }
}
