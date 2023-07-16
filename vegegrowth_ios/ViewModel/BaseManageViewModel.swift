//
//  BaseManageViewModel.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/07/16.
//

import Foundation
import Charts
import RxSwift
import RxCocoa

protocol GrowthManageViewModelInputs {
    var vegeText: BehaviorRelay<String> { get }
    var rightSwipe: PublishRelay<Void> { get }
    var leftSwipe: PublishRelay<Void> { get }
    var tapGesture: PublishRelay<Void> { get }
    var editMemoButtonTapped: PublishRelay<Void> { get }
}

protocol GrowthManageViewModelOutputs {
    var vegeId: PublishRelay<String> { get }
    var slideImg: Driver<UIImage?> { get }
    var currentIndex: PublishRelay<Int> { get }
    var isHiddenLabel: Driver<Bool> { get }
    var isPopupImg: BehaviorRelay<Bool> { get }
    var detailLabelText: Driver<String> { get }
    var memoLabelText: Driver<String> { get }
    var moveEditMemoView: PublishRelay<Void> { get }
    func getDatas() -> [VegeLengthObject]
}

protocol GrowthManageViewModelType {
    var inputs: GrowthManageViewModelInputs { get }
    var outputs: GrowthManageViewModelOutputs { get }
}

class BaseManageViewModel: GrowthManageViewModelType,
                             GrowthManageViewModelInputs,
                             GrowthManageViewModelOutputs {
    
    var inputs: GrowthManageViewModelInputs { return self }
    var outputs: GrowthManageViewModelOutputs { return self }
    
    // MARK: - inputs
    var vegeText = BehaviorRelay<String>(value: "")
    var rightSwipe = PublishRelay<Void>()
    var leftSwipe = PublishRelay<Void>()
    var tapGesture = PublishRelay<Void>()
    var editMemoButtonTapped = PublishRelay<Void>()
    
    // MARK: - outputs
    var vegeId = PublishRelay<String>()
    var slideImg: Driver<UIImage?>
    var currentIndex = PublishRelay<Int>()
    var isHiddenLabel: Driver<Bool>
    var isPopupImg = BehaviorRelay<Bool>(value: false)
    var detailLabelText: Driver<String>
    var memoLabelText: Driver<String>
    var moveEditMemoView = PublishRelay<Void>()
    
    public let slideImgRelay = BehaviorRelay<UIImage?>(value: nil)
    public let isHiddenLabelRelay = PublishRelay<Bool>()
    public let detailLabelTextRelay = BehaviorRelay<String>(value: "")
    public let memoLabelTextRelay = BehaviorRelay<String>(value: "")
    
    public let vegeManager = VegeManagerClass()
    public let date = DateClass()
    public var detailVege: DetailVegeClass!
    public var slideShow: SlideshowClass!
    
    public var disposeBag = DisposeBag()
    
    init() {
        isHiddenLabel = isHiddenLabelRelay.asDriver(onErrorDriveWith: .empty())
        
        detailLabelText = detailLabelTextRelay.asDriver(onErrorDriveWith: .empty())
        
        memoLabelText = memoLabelTextRelay.asDriver().asDriver(onErrorDriveWith: .empty())
        
        slideImg = slideImgRelay.asDriver().asDriver(onErrorDriveWith: .empty())
        
        vegeText
            .compactMap { [weak self] vegeText in
                guard let vegeIdDict = self?.vegeManager.getVegeIdDict() else {
                    return nil
                }
                return vegeIdDict[vegeText]
            }
            .bind(to: vegeId)
            .disposed(by: disposeBag)
        

        // vegeIdが更新されたら、imgclassとgraphclassを生成する
        // vegeIdに対応したvegeTextListも持ってくる
        vegeId
            .subscribe(onNext: { [weak self] vegeId in
                self?.detailVege = DetailVegeClass(vegeId: vegeId)
                self?.slideShow = SlideshowClass(vegeId: vegeId)
                self?.reloadManageData()
            })
            .disposed(by: disposeBag)
        
        rightSwipe
            .subscribe(onNext: { [weak self] _ in
                self?.slideShow.showPrevImg()
                self?.reloadManageData()
            })
            .disposed(by: disposeBag)
        
        leftSwipe
            .subscribe(onNext: { [weak self] _ in
                self?.slideShow.showNextImg()
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
    
    public func getDatas() -> [VegeLengthObject] {
        return []
    }
    
    private func getGraphData() {
        let datas = detailVege.getUserDetailVegeList()
        var entries: [ChartDataEntry] = []
        var date_list: [String] = []
        for item in datas {
            entries.append(ChartDataEntry(x: Double(item.x), y: Double(item.vegeLength)))
            date_list.append(item.date)
        }
    }
    
    private func getMemo(index: Int) {
        let datas = getDatas()
        var memoLabelText = datas[index].memoText
        if memoLabelText == "" {
            memoLabelText = "メモされていません"
        }
        memoLabelTextRelay.accept(memoLabelText)
    }
    
    // 画面のデータを更新する処理
    private func reloadManageData() {
        var detailText = ""
        let datas = getDatas()
        
        guard !datas.isEmpty else {
            return
        }
        
        let index = slideShow.getCurrentIndex()
        let data = datas[index]
        let firstData = datas[0]
        let dayCount = date.diffDate(firstDateText: data.date, secondDateText: firstData.date)
        
        let dateText = "\(data.date)"
        let vegeLengthText = "\(data.vegeLength)cm"
        let dayCountText = "\(dayCount)日目"
        detailText = dayCountText + "\n" + dateText + "\n" + vegeLengthText
        
        // 更新通知
        isHiddenLabelRelay.accept(true)
        slideImgRelay.accept(slideShow.getShowImg())
        
        currentIndex.accept(index)
        detailLabelTextRelay.accept(detailText)
        getMemo(index: index)
    }
}
