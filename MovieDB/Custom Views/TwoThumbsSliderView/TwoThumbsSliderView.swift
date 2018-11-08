//
//  TwoThumbsSliderView.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 31/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import UIKit

class TwoThumbsSliderView: UIControl {
    
    enum HighlightMode {
        case integer
        case fractional
        case none
    }
    
    var minValue: Double = 0.0 {
        didSet {
            updatePositions()
        }
    }
    
    var maxValue: Double = 5.0 {
        didSet {
            updatePositions()
        }
    }
    
    var lowerValue: Double = 0.0 {
        didSet {
            lowerValue = max(minValue, min(upperValue, lowerValue))
            updatePositions()
        }
    }
    
    var upperValue: Double = 5.0 {
        didSet {
            upperValue = min(maxValue, max(lowerValue, upperValue))
            updatePositions()
        }
    }
    
    var intLowerValue: Int {
        return lround(lowerValue)
    }
    
    var intUpperValue: Int {
        return lround(upperValue)
    }
    
    var highlightMode: HighlightMode = .none {
        didSet {
            updateHighlights()
        }
    }
    
    private lazy var hapticFeeback = UISelectionFeedbackGenerator()
    
    private var widthRange: Double {
        return Double(slidingStroke.bounds.width)
    }
    
    private weak var backgroundStroke: UIView!
    private weak var slidingStroke: UIView!
    
    private weak var lowerThumb: UIView!
    private weak var lowerThumbPositionConstraint: NSLayoutConstraint!
    private weak var lowerHighlight: UILabel!
    
    private weak var upperThumb: UIView!
    private weak var upperThumbPositionConstraint: NSLayoutConstraint!
    private weak var upperHighlight: UILabel!
    
    private let thumbSize: CGFloat = 20.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let cornerRadius = thumbSize / CGFloat(2)
        self.lowerThumb.layer.cornerRadius = cornerRadius
        self.upperThumb.layer.cornerRadius = cornerRadius
        
        updatePositions()
    }
    
    private func updatePositions() {
        lowerThumbPositionConstraint.constant = CGFloat((lowerValue - minValue) / (maxValue - minValue) * widthRange)
        upperThumbPositionConstraint.constant = CGFloat((upperValue - minValue) / (maxValue - minValue) * widthRange)
        
        updateHighlights()
        
        sendActions(for: .valueChanged)
    }
    
    private func updateHighlights() {
        lowerHighlight.isHidden = false
        upperHighlight.isHidden = false
        switch highlightMode {
        case .integer:
            lowerHighlight.text = "\(lround(lowerValue))"
            upperHighlight.text = "\(lround(upperValue))"
            
        case .fractional:
            lowerHighlight.text = String(format: "%.1f", arguments: [lowerValue])
            upperHighlight.text = String(format: "%.1f", arguments: [upperValue])
            
        case .none:
            lowerHighlight.isHidden = true
            upperHighlight.isHidden = true
            return
        }
        
        lowerHighlight.sizeToFit()
        upperHighlight.sizeToFit()
    }
    
    private func setup() {
        setupSlidingStroke()
        setupBackgroundStroke()
        setupThumbs()
        setupHighlights()
        setupFillStroke()
        setupPanGestureRecognizer()
    }
    
    func setupSlidingStroke() {
        let slidingStroke = UIView()
        slidingStroke.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(slidingStroke)
        
        slidingStroke.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: thumbSize).isActive = true
        
        slidingStroke.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -thumbSize).isActive = true
        
        slidingStroke.heightAnchor.constraint(equalToConstant: 2.0).isActive = true
        
        slidingStroke.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.slidingStroke = slidingStroke
    }
    
    private func setupBackgroundStroke() {
        let backgroundStroke = UIView()
        backgroundStroke.backgroundColor = .lightGray
        backgroundStroke.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(backgroundStroke)
        
        backgroundStroke.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: thumbSize / CGFloat(2)).isActive = true
        
        backgroundStroke.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -thumbSize / CGFloat(2)).isActive = true
        
        backgroundStroke.heightAnchor.constraint(equalToConstant: 2.0).isActive = true
        
        backgroundStroke.centerYAnchor.constraint(equalTo: slidingStroke.centerYAnchor).isActive = true
        
        self.backgroundStroke = backgroundStroke
    }
    
    private func setupThumbs() {
        lowerThumb = setupThumb(lowerThumb: true)
        upperThumb = setupThumb(lowerThumb: false)
    }
    
    private func setupThumb(lowerThumb: Bool) -> UIView {
        let thumb = UIView()
        thumb.backgroundColor = .white
        thumb.layer.borderWidth = 0.4
        thumb.layer.borderColor = UIColor.gray.cgColor
        thumb.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(thumb)
        
        var positionConstraint: NSLayoutConstraint
        if lowerThumb {
            positionConstraint = thumb.trailingAnchor.constraint(equalTo: slidingStroke.leadingAnchor)
            lowerThumbPositionConstraint = positionConstraint
        } else {
            positionConstraint = thumb.leadingAnchor.constraint(equalTo: slidingStroke.leadingAnchor)
            upperThumbPositionConstraint = positionConstraint
        }
        positionConstraint.identifier = "position"
        positionConstraint.isActive = true
        
        thumb.centerYAnchor.constraint(equalTo: slidingStroke.centerYAnchor).isActive = true
        
        thumb.widthAnchor.constraint(equalToConstant: thumbSize).isActive = true
        
        thumb.heightAnchor.constraint(equalTo: thumb.widthAnchor).isActive = true
        
        return thumb
    }
    
    private func setupHighlights() {
        lowerHighlight = setupHighlight(lowerHighlight: true)
        upperHighlight = setupHighlight(lowerHighlight: false)
    }
    
    private func setupHighlight(lowerHighlight: Bool) -> UILabel {
        let highlight = UILabel()
        highlight.textColor = .white
        highlight.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(highlight)
        
        if lowerHighlight {
            highlight.trailingAnchor.constraint(equalTo: lowerThumb.trailingAnchor, constant: -5.0).isActive = true
            highlight.bottomAnchor.constraint(equalTo: lowerThumb.topAnchor, constant: -10.0).isActive = true
        } else {
            highlight.leadingAnchor.constraint(equalTo: upperThumb.leadingAnchor, constant: 5.0).isActive = true
            highlight.bottomAnchor.constraint(equalTo: upperThumb.topAnchor, constant: -10.0).isActive = true
        }
        
        return highlight
    }
    
    private func setupFillStroke() {
        let fillStroke = UIView()
        fillStroke.backgroundColor = .red
        fillStroke.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(fillStroke, belowSubview: lowerThumb)
        
        fillStroke.heightAnchor.constraint(equalTo: backgroundStroke.heightAnchor).isActive = true
        
        fillStroke.leadingAnchor.constraint(equalTo: lowerThumb.centerXAnchor).isActive = true
        
        fillStroke.trailingAnchor.constraint(equalTo: upperThumb.centerXAnchor).isActive = true
        
        fillStroke.centerYAnchor.constraint(equalTo: slidingStroke.centerYAnchor).isActive = true
    }
    
    private func setupPanGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleDragging(gestureRecognizer:)))
        panGestureRecognizer.delegate = self
        panGestureRecognizer.maximumNumberOfTouches = 1
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    var thumbTouchPosition: CGFloat = 0.0
    var touchOffset: CGFloat = 0.0
    weak var draggedThumb: UIView!
    
    @objc private func handleDragging(gestureRecognizer: UIPanGestureRecognizer) {
        
        switch gestureRecognizer.state {
        case .began:
            hapticFeeback.prepare()
            
        case .ended:
            hapticFeeback.selectionChanged()
            
        case .changed:
            let sliderTouchPosition = gestureRecognizer.location(in: slidingStroke).x
            let newPosition = sliderTouchPosition + touchOffset
            let newValue = minValue + Double(newPosition) / widthRange * (maxValue - minValue)
            if draggedThumb === lowerThumb {
                lowerValue = newValue
            } else {
                upperValue = newValue
            }
            
        default:
            return
        }
    }
    
}

extension TwoThumbsSliderView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchPosition = touch.location(in: self).x
        
        let lowerThumbPosition = lowerThumb.frame.midX
        let upperThumbPosition = upperThumb.frame.midX
        
        let distanceToLowerThumb = abs(touchPosition - lowerThumbPosition)
        let distanceToUpperThumb = abs(touchPosition - upperThumbPosition)
        
        if distanceToLowerThumb < distanceToUpperThumb && distanceToLowerThumb < 30.0 {
            draggedThumb = lowerThumb
        } else if distanceToLowerThumb > distanceToUpperThumb && distanceToUpperThumb < 30.0 {
            draggedThumb = upperThumb
        } else {
            draggedThumb = nil
            return false
        }
        
        thumbTouchPosition = touch.location(in: draggedThumb).x
        if draggedThumb === lowerThumb {
            touchOffset = thumbSize - thumbTouchPosition
        } else {
            touchOffset = -thumbTouchPosition
        }
        
        return true
    }
    
}
