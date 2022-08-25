//
//  GameViewController.swift
//  MojiSagashi
//
//  Created by 村中令 on 2022/08/21.
//

import UIKit

class GameViewController: UIViewController {
    private var valueArray: [String]
    private var randomButtonPosition: [ButtonPosition] = []
    private var randomButton: [UIButton] = []
    private var randomButtonAndButtonPosition : [UIButton: String] = [:]
    private var requiredResultScreenTransition: RequiredResultScreenTransition?
    private var missCount = 0

    private var gameTimer: Timer?
    private var timerFloat: Float = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        gameTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: {[weak self] _ in
            self?.timerFloat += 0.01
        })
        showRandomNumbers()
    }

    required init?(coder: NSCoder, valueArray: [String], gameType: String) {
        self.valueArray = valueArray
        requiredResultScreenTransition = RequiredResultScreenTransition(
            arrayCount: valueArray.count,
            fontSize: TextSizeRepository.load()!,
            gameTypeCharacter: gameType
        )
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    @IBAction func reloadButtons(_ sender: Any) {

    }

    func showRandomNumbers() {
        view.subviews.forEach { object in
            randomButton.forEach { label in
                if object === label {
                    object.removeFromSuperview()
                }
            }
        }
        // randomButtonの数を、valueArray分作成する必要がある。
        // 下記のcountは、Buttonが作成されたあとに＋１されて、while分で、valueArray分以上作成しないようにするために用いる。
        var count = 1
        for i in valueArray {
            while randomButtonPosition.count < count {
                let rangeX = 0...UIScreen.main.bounds.size.width - 60
                let rangeY = view.safeAreaInsets.top + 50...UIScreen.main.bounds.size.height - 150

                let randomValueX = CGFloat.random(in: rangeX)
                let randomValueY = CGFloat.random(in: rangeY)

                let newButtonPosition = ButtonPosition(
                    minX: randomValueX,
                    maxX: randomValueX + 60,
                    minY: randomValueY,
                    maxY: randomValueY + 60)

                let boolArray = randomButtonPosition.compactMap { labelPosition in
                    return labelPosition.isOverlap(labelPosition: newButtonPosition)
                }

                if boolArray.contains(true) {
                    continue
                }

                let newButton = creatUIButton(
                    minX: newButtonPosition.minX,
                    minY: newButtonPosition.minY,
                    text: "\(i)"
                )
                randomButtonPosition.append(newButtonPosition)
                randomButton.append(newButton)
                randomButtonAndButtonPosition.updateValue(i, forKey: newButton)
                self.view.addSubview(newButton)
            }
            count += 1
        }
    }


    func creatUIButton(minX: CGFloat, minY: CGFloat, text: String) -> UIButton{
        // UILabelの設定
        let newButton = UIButton() // ラベルの生成
        newButton.frame = CGRect(x: minX, y: minY, width: 60 , height: 60) // 位置とサイズの指定
        newButton.titleLabel?.textAlignment = NSTextAlignment.center // 横揃えの設定
        newButton.titleLabel?.baselineAdjustment = .alignCenters
        newButton.contentVerticalAlignment = .fill
        newButton.setTitle("\(text)", for: .normal) // テキストの設定
        newButton.setTitleColor( UIColor.init(named: "string")!, for: .normal) // テキストカラーの設定
        newButton.titleLabel?.font = UIFont(name: "HiraKakuProN-W6", size: CGFloat(TextSizeRepository.load()!)) // フォントの設定
        newButton.isUserInteractionEnabled = true
        newButton.addTarget(self,
                             action: #selector(self.buttonTapped(sender:)),
                             for: .touchUpInside)
        return newButton
    }

    @objc func buttonTapped(sender: UIButton) {
        if valueArray.first == randomButtonAndButtonPosition[sender]! {
            // TapされたUIButtonが、順番通り（1.2.3....）にTapされていれば、そのUIButtonを削除する処理。正解の場合。
            self.view.subviews.forEach { object in
                if object === sender {
                    object.removeFromSuperview()
                }
            }
            // numbersの最初の要素を削除して、次にタップして欲しい値を先頭に持ってくる。
            valueArray.remove(at: 0)

            if valueArray.count == 0 {
                requiredResultScreenTransition?.timerResult = timerFloat
                requiredResultScreenTransition?.missCount = missCount
                performSegue(withIdentifier: "result", sender: nil)
            }
        } else {
            // TapされたUIButtonが、順番通り（1.2.3....）にTapできていない場合の処理。不正解の場合。
            missCount += 1
        }
    }
}

private extension GameViewController {
    @IBSegueAction
    func makeResultVC(coder: NSCoder, sender: Any?, segueIdentifier: String?) -> ResultViewController? {
        return ResultViewController(
            coder: coder,requiredResultScreenTransition!
        )
    }

    @IBAction
    func backToGameViewController(segue: UIStoryboardSegue) {
    }
}
