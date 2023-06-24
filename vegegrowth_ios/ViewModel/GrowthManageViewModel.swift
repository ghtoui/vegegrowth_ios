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

protocol GrowthManageViewModelInputs {
    var vegeText: BehaviorRelay<String> { get }
    var rightSwipe: PublishRelay<Void> { get }
    var leftSwipe: PublishRelay<Void> { get }
}

protocol GrowthManageViewModelOutputs {
    var vegeId: PublishRelay<String> { get }
    var slideImg: Driver<UIImage?> { get }
    func getDatas() -> [VegeLengthObject]
//    var showLineChart: PublishRelay<Void> { get }
}

protocol GrowthManageViewModelType {
    var inputs: GrowthManageViewModelInputs { get }
    var outputs: GrowthManageViewModelOutputs { get }
}

class GrowthManageViewModel: GrowthManageViewModelType,
                             GrowthManageViewModelInputs,
                             GrowthManageViewModelOutputs {
    
    var inputs: GrowthManageViewModelInputs { return self }
    var outputs: GrowthManageViewModelOutputs { return self }
    
    // MARK: - inputs
    var vegeText = BehaviorRelay<String>(value: "")
    var rightSwipe = PublishRelay<Void>()
    var leftSwipe = PublishRelay<Void>()
    
    // MARK: - outputs
    var vegeId = PublishRelay<String>()
    var slideImg: Driver<UIImage?> {
        return slideImgRelay.asDriver()
    }
//    var showLineChart = PublishRelay<ChartDataEntry>()
    
    private let vegeManager = VegeManagerClass()
    private var graph: GraphClass!
    private var slideShow: SlideshowClass!
    
    private let slideImgRelay = BehaviorRelay<UIImage?>(value: nil)
    
    private var disposeBag = DisposeBag()
    
    
    
    init() {
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
                self?.graph = GraphClass(vegeId: vegeId)
                self?.slideShow = SlideshowClass(vegeId: vegeId)
                self?.slideImgRelay.accept(self?.slideShow.getShowImg())
            })
            .disposed(by: disposeBag)
    }
    
    public func getDatas() -> [VegeLengthObject] {
        return graph.getUserGraphList()
    }
    
    private func getGraphData() {
        let datas = graph.getUserGraphList()
        var entries: [ChartDataEntry] = []
        var date_list: [String] = []
        for item in datas {
            entries.append(ChartDataEntry(x: Double(item.x), y: Double(item.vegeLength)))
            date_list.append(item.date)
        }
        
    }
    
}
