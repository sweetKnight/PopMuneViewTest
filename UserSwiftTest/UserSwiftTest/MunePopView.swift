//
//  MunePopView.swift
//  PopMuneDurate
//
//  Created by 冯剑锋 on 16/6/21.
//  Copyright © 2016年 冯剑锋. All rights reserved.
//

import UIKit

/*!
 *  传递点击事件的代理
 */
@objc(MunePopViewOptionClick)
protocol MunePopViewOptionClick: NSObjectProtocol {
    func munePopViewOptionClick(count:Int)
}

/// 菜单类
class MunePopView: UIView {
    let centerButton = UIImageView()            /** 最开始能看见的按键 */
    let baseButtonTage = 500                    /** tag值的一个最小值 */
    var optionCenterArr = NSMutableArray()      /** 菜单按键出现后的中心位置[x,y]表示数组中一个元素 */
    var myButtonCount = 0                       /** 菜单按键个数 */
    var isOpenMune:Bool = false                 /** 是否是打开状态 */
    weak var delegate: MunePopViewOptionClick?  /** 代理属性 */
    var optionViewScale:CGFloat = 2.0           /** 选择菜单与中心按键大小比 */
    var isBig = false                           /** 是否停留在选择菜单上 */
    var currentCount:Int = -100                 /** 当前停留在哪个 */
    
    init(frame: CGRect, optionsCenterArr:NSArray) {
        super.init(frame: frame)
        optionCenterArr = optionsCenterArr.mutableCopy() as! NSMutableArray
        myButtonCount = optionCenterArr.count
        self.backgroundColor = UIColor.clearColor()
        let halfWidth: CGFloat = bounds.width/2
        
        centerButton.frame = bounds
        centerButton.layer.cornerRadius = halfWidth
        centerButton.layer.masksToBounds = true
        self.addSubview(centerButton)
        
        for i in 0..<myButtonCount {        //创建菜单按键
            let optionBnt = UIImageView(frame:CGRect(x: 0, y: 0, width: bounds.width/optionViewScale, height: bounds.height/optionViewScale))
            optionBnt.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            optionBnt.center = centerButton.center
            optionBnt.layer.cornerRadius = halfWidth/optionViewScale
            optionBnt.layer.masksToBounds = true
            optionBnt.tag = baseButtonTage + i
            optionBnt.backgroundColor = UIColor.redColor()
            self.insertSubview(optionBnt, belowSubview: centerButton)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: touchDelegate
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isOpenMune = true
        let touch: UITouch = touches.first!
        let touchLocationPoint:CGPoint = touch.locationInView(self.superview)
        let centerBtnFrame = centerButton.convertRect(centerButton.bounds, toView: self.superview)
        
        //判断是不是在按键内
        if centerBtnFrame.maxX > touchLocationPoint.x
            && centerBtnFrame.minX < touchLocationPoint.x
            && centerBtnFrame.maxY > touchLocationPoint.y
            && centerBtnFrame.minY < touchLocationPoint.y{
            //弹出菜单
            UIView.animateWithDuration(0.25, animations: {
                for i in 0..<self.myButtonCount {
                    let opintView = self.viewWithTag(i+self.baseButtonTage)!
                    let x:CGFloat = (self.optionCenterArr[i][0] as?CGFloat)!
                    let y:CGFloat = (self.optionCenterArr[i][1] as?CGFloat)!
                    opintView.center = CGPoint(x: opintView.center.x + x, y: opintView.center.y + y)
                }
            })
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch: UITouch = touches.first!
        let touchLocationPoint:CGPoint = touch.locationInView(self.superview)
        for i in 0..<myButtonCount {
            let opintView = self.viewWithTag(i+baseButtonTage)!
            let opintViewFrame = opintView.convertRect(opintView.bounds, toView: self.superview)
            //是不是移动到菜单选项里
            if opintViewFrame.maxX > touchLocationPoint.x
                && opintViewFrame.minX < touchLocationPoint.x
                && opintViewFrame.maxY > touchLocationPoint.y
                && opintViewFrame.minY < touchLocationPoint.y{
                if isBig == false {
                    opintView.transform = CGAffineTransformScale(opintView.transform, 1.2, 1.3)
                    isBig = true
                    currentCount = i
                }
                return
            }
            opintView.transform = CGAffineTransformIdentity
            if currentCount == i {
                isBig = false
            }
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isBig = false
        if isOpenMune {
            isOpenMune = false
            if delegate != nil {
                delegate!.munePopViewOptionClick(currentCount)
            }
            //收回菜单
            UIView.animateWithDuration(0.25, animations: {
                for i in 0..<self.myButtonCount{
                    let opintView = self.viewWithTag(i+self.baseButtonTage)!
                    opintView.center = self.centerButton.center
                    opintView.transform = CGAffineTransformIdentity
                }
            })
            currentCount = -100
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        
    }
    
    //CustemMethod
    /*!
     添加一个菜单按键
    */
    func addOptionItem(centerArr:NSArray){
        let optionBnt = UIImageView(frame:CGRect(x: 0, y: 0, width: bounds.width/optionViewScale, height: bounds.height/optionViewScale))
        optionBnt.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        optionBnt.center = centerButton.center
        optionBnt.layer.cornerRadius = bounds.width/2/optionViewScale
        optionBnt.layer.masksToBounds = true
        optionBnt.tag = baseButtonTage + optionCenterArr.count
        optionBnt.backgroundColor = UIColor.redColor()
        self.insertSubview(optionBnt, belowSubview: centerButton)
        optionCenterArr.addObject(centerArr)
        myButtonCount = optionCenterArr.count
    }
}
