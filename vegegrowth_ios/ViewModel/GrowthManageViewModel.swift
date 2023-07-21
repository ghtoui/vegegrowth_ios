//
//  GrowthManageViewModel.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/06/11.
//

import Foundation
import Charts
import RxSwift
import RxCocoa

class GrowthManageViewModel: BaseManageViewModel {
    
    private var browse = browseClass()
    
    override init() {
        super.init()
        
        editMemoButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.moveEditMemoView.accept(())
            })
            .disposed(by: disposeBag)
    }
    
    override func getDatas() -> [VegeLengthObject] {
        let datas = detailVege.getUserDetailVegeList()
        guard !datas.isEmpty else {
            isHiddenLabelRelay.accept(false)
            return []
        }
        return datas
    }
    
}
