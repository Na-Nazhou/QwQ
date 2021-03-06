//
//  SegmentedControl.swift
//  QwQ
//
//  Created by Tan Su Yee on 18/3/20.
//

import UIKit

class SegmentedControl: UIControl {
    
    private var labels = [UILabel]()
    var thumbView = UIView()
    
    var items = Constants.segmentedControlTitles {
        didSet {
            setupLabels()
        }
    }
    
    var selectedIndex = Constants.segmentedControlDefaultSelectedIndex {
        didSet {
            displayNewSelectedIndex()
        }
    }
    
    var selectedLabelColor = Constants.segmentedControlSelectedLabelColor {
        didSet {
            setSelectedColors()
        }
    }
    
    var unselectedLabelColor = Constants.segmentedControlUnselectedLabelColor {
        didSet {
            setSelectedColors()
        }
    }
    
    var thumbColor = Constants.segmentedControlThumbColor {
        didSet {
            setSelectedColors()
        }
    }
    
    var borderColor = Constants.segmentedControlBorderColor {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    var font = Constants.segmentedControlFont {
        didSet {
            setFont()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        setupView()
    }
    
    private func setupView() {
        layer.cornerRadius = frame.height / 2
        layer.borderColor = Constants.segmentedControlLayerBorderColor
        layer.borderWidth = Constants.segmentedControlLayerBorderWidth
        
        backgroundColor = .clear
        
        setupLabels()
        
        addIndividualItemConstraints(items: labels, mainView: self, padding: 0)
        
        insertSubview(thumbView, at: 0)
    }
    
    private func setupLabels() {
        for label in labels {
            label.removeFromSuperview()
        }
        
        labels.removeAll(keepingCapacity: true)
        
        for index in 1...items.count {
            
            let label = UILabel(frame: Constants.segmentedControlLabelFrame)
            label.text = items[index - 1]
            label.backgroundColor = .clear
            label.textAlignment = .center
            label.font = Constants.segmentedControlLabelFont
            label.textColor = index == 1 ? selectedLabelColor : unselectedLabelColor
            label.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(label)
            labels.append(label)
        }
        
        addIndividualItemConstraints(items: labels, mainView: self, padding: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var selectFrame = self.bounds
        let newWidth = selectFrame.width / CGFloat(items.count)
        selectFrame.size.width = newWidth
        thumbView.frame = selectFrame
        thumbView.backgroundColor = thumbColor
        thumbView.layer.cornerRadius = thumbView.frame.height / 2
        
        displayNewSelectedIndex()
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        var calculatedIndex: Int?
        for (index, item) in labels.enumerated() {
            if item.frame.contains(location) {
                calculatedIndex = index
            }
        }
        
        if calculatedIndex != nil {
            selectedIndex = calculatedIndex!
            sendActions(for: .valueChanged)
        }
        
        return false
    }
    
    func displayNewSelectedIndex() {
        for item in labels {
            item.textColor = unselectedLabelColor
        }
        
        let label = labels[selectedIndex]
        label.textColor = selectedLabelColor
        
        UIView.animateKeyframes(withDuration: Constants.segmentedControlAnimationDuration,
                                delay: Constants.segmentedControlAnimationDelay,
                                options: [],
                                animations: {
                                    self.thumbView.frame = label.frame
                                },
                                completion: nil)
    }
    
    private func addIndividualItemConstraints(items: [UIView], mainView: UIView, padding: CGFloat) {
        for (index, button) in items.enumerated() {
            let topConstraint = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal,
                                                   toItem: mainView, attribute: .top,
                                                   multiplier: 1.0, constant: 0)
            
            let bottomConstraint = NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal,
                                                      toItem: mainView, attribute: .bottom,
                                                      multiplier: 1.0, constant: 0)

            var rightConstraint: NSLayoutConstraint!
            if index == items.count - 1 {
                rightConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal,
                                                     toItem: mainView, attribute: .right,
                                                     multiplier: 1.0, constant: -padding)
            } else {
                let nextButton = items[index + 1]
                rightConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal,
                                                     toItem: nextButton, attribute: .left,
                                                     multiplier: 1.0, constant: -padding)
            }
            
            var leftConstraint: NSLayoutConstraint!
            if index == 0 {
                leftConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal,
                                                    toItem: mainView, attribute: .left,
                                                    multiplier: 1.0, constant: padding)
            } else {
                let prevButton = items[index - 1]
                leftConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal,
                                                    toItem: prevButton, attribute: .right,
                                                    multiplier: 1.0, constant: padding)
                
                let firstItem = items[0]
                let widthConstraint = NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal,
                                                         toItem: firstItem, attribute: .width,
                                                         multiplier: 1.0, constant: 0)
                
                mainView.addConstraint(widthConstraint)
            }
            
            mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
        }
    }
    
    private func setSelectedColors() {
        for item in labels {
            item.textColor = unselectedLabelColor
        }
        
        if labels.isEmpty {
            labels[0].textColor = selectedLabelColor
        }
        
        thumbView.backgroundColor = thumbColor
    }
    
    private func setFont() {
        for item in labels {
            item.font = font
        }
    }
}
