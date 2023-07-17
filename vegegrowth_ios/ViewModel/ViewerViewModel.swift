//
//  ViewerViewModel.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/07/16.
//

import Foundation
import Charts
import RxSwift
import RxCocoa

class ViewerViewModel: BaseManageViewModel {
    private var model: BrowseData!
    private var index: Int = 0
    
    override init() {
        super.init()
        reloadManageData()
    }
    
    override func setModelData(model: BrowseData) {
        self.model = model
        reloadManageData()
    }
    
    override func gestureBind() {
        rightSwipe
            .subscribe(onNext: { [weak self] _ in
                self?.showPrevImg()
                self?.reloadManageData()
            })
            .disposed(by: disposeBag)
        
        leftSwipe
            .subscribe(onNext: { [weak self] _ in
                self?.showNextImg()
                self?.reloadManageData()
            })
            .disposed(by: disposeBag)
        
        tapGesture
            .subscribe(onNext: { [weak self] in
                guard let isPopup: Bool = self?.isPopupImg.value else {
                    return
                }
                self?.isPopupImg.accept(!isPopup)
            })
            .disposed(by: disposeBag)
    }
    
    private func showNextImg() {
        guard model != nil else {
            return
        }
        if (index == model.date.count - 1) {
            index = 0
        } else {
            index += 1
        }
        
        if (model.date.count == 0) {
            index = 0
        }
    }
    
    private func showPrevImg() {
        guard model != nil else {
            return
        }
        if (index == 0) {
            index = model.date.count - 1
        } else {
            index -= 1
        }
    }
    
    override func getShowImg() -> UIImage? {
        guard let img = Data(base64Encoded: model.base64EncodedImage[index]) else {
            return nil
        }
        return UIImage(data: img)
    }
    
    override func reloadManageData() {
        var dayCountText: String = ""
        super.reloadManageData()
        guard model != nil else {
            return
        }
        var detailText: String
        
        let firstData = model.date[0]
        let dayCount = date.diffDate(firstDateText: model.date[index], secondDateText: firstData)

        let dateText = "\(model.date[index])"
        let vegeLengthText = "\(model.vegeLength[index])cm"
        dayCountText = "\(dayCount)日目"
        detailText = dayCountText + "\n" + dateText + "\n" + vegeLengthText
        
        // 更新通知
        isHiddenLabelRelay.accept(true)
        slideImgRelay.accept(getShowImg())
        
        currentIndex.accept(index)
        detailLabelTextRelay.accept(detailText)
        var memoLabelText = ""
        if memoLabelText == "" {
            memoLabelText = "メモされていません"
        }
        memoLabelTextRelay.accept(memoLabelText)
    }
}
