//
//  GraphControllerViewController.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/06/02.
//

import UIKit
import Charts
import RxSwift
import RxCocoa

class GrowthManageViewController: UIViewController {
    
    @IBOutlet weak var slideImg: UIImageView!
    @IBOutlet weak var slidePopupImg: UIImageView!
    @IBOutlet weak var graphLabel: UILabel!
    @IBOutlet weak var graphView: LineChartView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var editMemoButton: CustomButton!
    
    private var slideImgRightSwipe: UISwipeGestureRecognizer!
    private var slideImgLeftSwipe: UISwipeGestureRecognizer!
    private var slideImgTapGesture: UITapGestureRecognizer!
    
    private var slidePopupImgRightSwipe: UISwipeGestureRecognizer!
    private var slidePopupImgLeftSwipe: UISwipeGestureRecognizer!
    private var slidePopupImgTapGesture: UITapGestureRecognizer!
    
    private var viewModel: GrowthManageViewModelType = GrowthManageViewModel()
    private let disposeBag = DisposeBag()
    
    private var currentIndex: Int!
    private var vegeText: String
    private var overlayView: UIView!
    
    private var graph_class: DetailVegeClass!
    private var slideshow_class: SlideshowClass!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initialUISetting()
        
        
        bind()
        gestureBind()
        
        viewModel.inputs.vegeText.accept(vegeText)
    }
    
    init?(coder: NSCoder, vegeText: String) {
        self.vegeText = vegeText
        super.init(coder: coder)
        print(vegeText)
        // タイトル変更(タップしたラベルを反映する)
        // navigationcontrollerを使っている
        navigationItem.title = vegeText
        self.vegeText = vegeText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func bind() {
        
        viewModel.outputs.slideImg
            .drive(slideImg.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.outputs.slideImg
            .drive(slidePopupImg.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.outputs.currentIndex
            .subscribe(onNext: { [weak self] index in
                self?.currentIndex = index
                self?.updateLineChart()
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.isHiddenLabel
            .drive(graphLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.outputs.isPopupImg
            .subscribe(onNext: { [weak self] isPopup in
                self?.changePopupView(isPopup: isPopup)
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.detailLabelText
            .drive(detailLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.memoLabelText
            .drive(memoLabel.rx.text)
            .disposed(by: disposeBag)
        
        editMemoButton.rx.tap
            .bind(to: viewModel.inputs.editMemoButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.outputs.moveEditMemoView
            .subscribe(onNext: { [weak self] in
                guard let vegeText: String = self?.vegeText, let index: Int = self?.currentIndex else {
                    return
                }
                self?.moveEditMemoView(vegeText: vegeText, index: index)
            })
            .disposed(by: disposeBag)
    }
    
    private func gestureBind() {
        slideImgRightSwipe.rx.event
            .subscribe(onNext: { [weak self] gesture in
                // 右方向
                self?.viewModel.inputs.rightSwipe.accept(())
            })
            .disposed(by: disposeBag)
        
        slideImgLeftSwipe.rx.event
            .subscribe(onNext: { [weak self] gesture in
                // 左方向
                self?.viewModel.inputs.leftSwipe.accept(())
            })
            .disposed(by: disposeBag)
        
        slideImgTapGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.inputs.tapGesture.accept(())
            })
            .disposed(by: disposeBag)
        
        slidePopupImgRightSwipe.rx.event
            .subscribe(onNext: { [weak self] gesture in
                // 右方向
                self?.viewModel.inputs.rightSwipe.accept(())
            })
            .disposed(by: disposeBag)
        
        slidePopupImgLeftSwipe.rx.event
            .subscribe(onNext: { [weak self] gesture in
                // 左方向
                self?.viewModel.inputs.leftSwipe.accept(())
            })
            .disposed(by: disposeBag)
        
        slidePopupImgTapGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.inputs.tapGesture.accept(())
            })
            .disposed(by: disposeBag)
    }
    
    // グラフの描画メソッド
    // データの取得はViewModelがやるべき
    func updateLineChart() {
        let datas = viewModel.outputs.getDatas()
        
        // グラフに描画するデータに変換
        var entries: [ChartDataEntry] = []
        var dateList: [String] = []
        for item in datas {
            entries.append(ChartDataEntry(x: Double(item.x), y: Double(item.vegeLength)))
            dateList.append(item.date)
        }
        
//        entries = [ChartDataEntry(x: 0, y: 10),
//                   ChartDataEntry(x: 1, y: 13),
//                   ChartDataEntry(x: 2, y: 10)]
        
        // グラフ描画
        let dataset = LineChartDataSet(entries: entries)
        dataset.lineWidth = 5
        dataset.drawCirclesEnabled = true
        dataset.circleRadius = 4
        dataset.circleColors = [UIColor.lightGray]
        graphView.data = LineChartData(dataSet: dataset)
        
        // グラフの設定
        // x軸オブジェクトを取得
        let xaxis = graphView.xAxis
        // x軸のラベルを下に設定
        xaxis.labelPosition = .bottom
        // x軸のグリッド線非表示
        xaxis.drawGridLinesEnabled = false
        xaxis.drawAxisLineEnabled = false
        
        // x軸ラベルを日付にする
        // X軸のラベルの数を設定
        xaxis.setLabelCount(3, force: true)
        
        
        // X軸のラベルに日付を表示するためのFormatterを設定
        let formatter = ChartFormatter(dateList: dateList)
        xaxis.valueFormatter = formatter
        
        // グラフにタッチ不可能にする
        graphView.highlightPerTapEnabled = false
        graphView.highlightPerDragEnabled = false
        
        // y軸を0始まりに
        graphView.leftAxis.axisMinimum = 0.0
        // 右側のy軸を非表示
        graphView.rightAxis.enabled = false
        
        
        // 境界線を利用して、スライドショーに表示されている画像と関連させる
//                let index = slideshow_class.getCurrentIndex()
        let limitLine_x = ChartLimitLine(limit: datas[currentIndex].vegeLength)
        let limitLine_y = ChartLimitLine(limit: Double(currentIndex))
        
//        let limitLine_x = ChartLimitLine(limit: 0)
//        let limitLine_y = ChartLimitLine(limit: 0)
        // 境界線を全て削除しないと、一生追加される
        graphView.leftAxis.removeAllLimitLines()
        graphView.xAxis.removeAllLimitLines()
        
        graphView.leftAxis.addLimitLine(limitLine_x)
        graphView.xAxis.addLimitLine(limitLine_y)
        
        // ラベルの左右の余白(端が見切れないようにするため)
        //        xaxis.spaceMin = 0.7
        //        xaxis.spaceMax = 0.7
    }
    
    // ポップアップviewにするためのメソッド
    private func changePopupView(isPopup: Bool) {
        print(isPopup)
        slideImg.isHidden = isPopup
        slidePopupImg.isHidden = !isPopup
        overlayView.isHidden = !isPopup
    }
    
    // 画像拡大時に背景を黒くする
    private func setBackground() {
        overlayView = UIView(frame: self.view.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.view.addSubview(overlayView)
        self.view.bringSubviewToFront(slidePopupImg)
        self.overlayView.isHidden = true
    }
    
    private func initialUISetting() {
        setBackground()
       
        // swipe処理を行う準備
        // 右スワイプを準備
        slideImgRightSwipe = UISwipeGestureRecognizer()
        slideImgRightSwipe.direction = .right
        slideImg.addGestureRecognizer(slideImgRightSwipe)
        
        slidePopupImgRightSwipe = UISwipeGestureRecognizer()
        slidePopupImgRightSwipe.direction = .right
        slidePopupImg.addGestureRecognizer(slidePopupImgRightSwipe)
        
        // 左スワイプを準備
        slideImgLeftSwipe = UISwipeGestureRecognizer()
        slideImgLeftSwipe.direction = .left
        slideImg.addGestureRecognizer(slideImgLeftSwipe)
        
        slidePopupImgLeftSwipe = UISwipeGestureRecognizer()
        slidePopupImgLeftSwipe.direction = .left
        slidePopupImg.addGestureRecognizer(slidePopupImgLeftSwipe)
        
        // タップを準備
        slideImgTapGesture = UITapGestureRecognizer()
        slideImg.addGestureRecognizer(slideImgTapGesture)
        
        slidePopupImgTapGesture = UITapGestureRecognizer()
        slidePopupImg.addGestureRecognizer(slidePopupImgTapGesture)
    }
    
    private func navigationItemSettings() {
        // ボタンのサイズ
        let buttonFontSize: CGFloat = 20
        // titleの設定
        navigationItem.title = vegeText
        
        // 右ボタンの設定
        if let rightButton = navigationItem.rightBarButtonItem {
            let attributes: [NSAttributedString.Key: Any] = [
                // フォントサイズを設定
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: buttonFontSize)             ]
            rightButton.setTitleTextAttributes(attributes, for: .normal)
        }
        // バックボタンを矢印だけにする
        navigationItem.backButtonDisplayMode = .minimal
        
    }
    
    private func moveEditMemoView(vegeText: String, index: Int) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(identifier: "AddMemoView") { coder in
            return addMemoViewController(coder: coder, vegeText: vegeText, index: index)
        }
        navigationController?.pushViewController(VC, animated: true)
    }
}

private class ChartFormatter: NSObject, IAxisValueFormatter {
    private let xAxisValues: [String]
    private let dateFormatter = DateFormatter()
    init (dateList: [String]) {
        xAxisValues = dateList
        dateFormatter.dateFormat = "MM/dd"
    }
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value)
        if index >= 0 && index < xAxisValues.count {
            let date = xAxisValues[index]
            return date
        }
        
        return ""
    }
}
