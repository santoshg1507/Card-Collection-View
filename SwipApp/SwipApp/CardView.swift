//
//  CardView.swift
//  SwipApp
//
//  Created by Bonadea 02 on 24/01/18.
//  Copyright © 2018 Bonadea 02. All rights reserved.
//

import UIKit

protocol CardViewDataSouce {
    func numberOfcards(_ cardView: CardView) -> Int
    func cardView(_ cardView: CardView, cardFor index: Int) -> UIView
}

protocol CardViewDelegate {
    func cardView(_ card: UIView, didSelectCardAt index: Int)
}



class CardView: UIView,UIGestureRecognizerDelegate {
    
    
    var numberOfcards = 0
    var currentIndex = 0
    
    var horizontalMarginOfCard : CGFloat = 10
    var verticalMarginOfCard : CGFloat = 30
    var cardPadding : CGFloat = 5

    private var startPoint : CGPoint?
    private var centerPoint : CGPoint?
    private var startAngle : Float?

    var delegate : CardViewDelegate?
    var dataSource : CardViewDataSouce?

    
    func loadCards(index : Int)
    {
        if let dataSource = self.dataSource
        {
            currentIndex = index
            self.clipsToBounds = true
            
            for v in self.subviews
            {
                v.removeFromSuperview()
            }
            
            self.numberOfcards = dataSource.numberOfcards(self)
            let maxIndex = numberOfcards < 4 ? numberOfcards : 4
            for cIndex in 0 ..< maxIndex
            {
                let i = (3 - cIndex)
                let rem = (currentIndex + i) % numberOfcards
                
                let card1 = dataSource.cardView(self, cardFor: rem)
                card1.isUserInteractionEnabled = true
                card1.layer.masksToBounds = false
                card1.layer.shadowColor = UIColor.gray.cgColor
                card1.layer.shadowOpacity = 1
                card1.layer.shadowOffset = CGSize(width: -1, height: 1)
                card1.layer.shadowRadius = 4.0
                card1.layer.cornerRadius = 4.0
                card1.tag = i
                //card1.clipsToBounds = true

                
                self.addSubview(card1)

                let leading = NSLayoutConstraint(item: card1,
                                                 attribute: .leading,
                                                 relatedBy: .equal,
                                                 toItem: self,
                                                 attribute: .leading,
                                                 multiplier: 1.0,
                                                 constant: horizontalMarginOfCard)
                
                let top = NSLayoutConstraint(item: card1,
                                                 attribute: .top,
                                                 relatedBy: .equal,
                                                 toItem: self,
                                                 attribute: .top,
                                                 multiplier: 1.0,
                                                 constant: (verticalMarginOfCard + CGFloat(CGFloat(i) * cardPadding)))
                
                let trailing = NSLayoutConstraint(item: card1,
                                             attribute: .trailing,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .trailing,
                                             multiplier: 1.0,
                                             constant: -horizontalMarginOfCard)
                
                let bottom = NSLayoutConstraint(item: card1,
                                             attribute: .bottom,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .bottom,
                                             multiplier: 1.0,
                                             constant: -(verticalMarginOfCard - CGFloat(CGFloat(i) * cardPadding)))
                
                NSLayoutConstraint.activate([leading, trailing, top, bottom])
                self.addConstraint(leading)
                self.addConstraint(top)
                self.addConstraint(trailing)
                self.addConstraint(bottom)
                card1.translatesAutoresizingMaskIntoConstraints = false
                
                if cIndex + 1 == maxIndex
                {
                    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGesture(sender:)))
                    panGesture.delegate = self
                    card1.addGestureRecognizer(panGesture)
                    
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture(sender:)))
                    tapGesture.delegate = self
                    card1.addGestureRecognizer(tapGesture)
                }

            }

        }
        else
        {
            print("datasouce not set")
        }

    }
    
    @objc func tapGesture(sender: UIPanGestureRecognizer)
    {
        if let delegate = self.delegate
        {
            if let view = sender.view
            {
                delegate.cardView(view, didSelectCardAt: currentIndex)
            }
        }
        else
        {
            print("delegate not set")
        }
    }
    
    @objc func panGesture(sender: UIPanGestureRecognizer)
    {
        
        let point = sender.location(in: self)

        if let gestureView = sender.view
        {
            if sender.state == UIGestureRecognizerState.began {
                
                self.startPoint = point
                self.centerPoint = gestureView.center
                self.startAngle = atan2f(Float(self.frame.size.height - point.y), Float(self.frame.size.width/2 - point.x)) - Float.pi/2
                
            }
            if sender.state == UIGestureRecognizerState.changed {
                
                if let startAngle = self.startAngle, let centerPoint = self.centerPoint, let startPoint = self.startPoint
                {
                    self.setAnchorPoint(anchorPoint: CGPoint(x: 0.5, y: 1), forLayer: gestureView.layer)
                    
                    let  cAngle = atan2f(Float(self.frame.size.height - point.y), Float(self.frame.size.width/2 - point.x)) - Float.pi/2;
                    
                    let angle : Float = 0.0 + (cAngle - startAngle)
                    
                    let rotationTransform = CGAffineTransform(rotationAngle: CGFloat(angle))
                    
                    gestureView.transform = rotationTransform;
                    
                    gestureView.center.x = centerPoint.x  + (point.x - startPoint.x)
                    gestureView.center.y = centerPoint.y + centerPoint.y  + (point.y - startPoint.y)  - 20
                    
                    print(centerPoint.y  + (point.y - startPoint.y))
                    
                }
                

            }
            else if sender.state == UIGestureRecognizerState.ended
            {
                
                if point.x > self.frame.size.width*3/4 || point.x < self.frame.size.width*1/4
                {
                    
                    self.removeCard(card: gestureView)
                }
                else
                {
                    self.undoCardPosition(card: gestureView)
                    
                }
                
            }
           
        }
        
    }
    func undoCardPosition(card : UIView)
    {

        UIView.animate(withDuration: 0.3, animations: {
            
            card.center.x = self.centerPoint!.x
            card.center.y = self.centerPoint!.y + self.centerPoint!.y - 20
            let angle : Float = 0
            let rotationTransform = CGAffineTransform(rotationAngle: CGFloat(angle))
            card.transform = rotationTransform;
            
            
        }) { (finished) in
            self.startAngle = nil
            self.centerPoint = nil
            
            self.loadCards(index: self.currentIndex )

        }
    }
    
    func removeCard(card : UIView)
    {
        self.startAngle = nil
        self.centerPoint = nil

        UIView.animate(withDuration: 0.3, animations: {
            card.alpha = 0.0
        }) { (finished) in
            card.removeFromSuperview()
            self.loadCards(index: self.currentIndex + 1)
        }
    }

    private func setAnchorPoint(anchorPoint: CGPoint, forLayer layer: CALayer)
    {
        var newPoint = CGPoint(x: layer.bounds.size.width * anchorPoint.x, y: layer.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: layer.bounds.size.width * layer.anchorPoint.x, y: layer.bounds.size.height * layer.anchorPoint.y)
        newPoint = newPoint.applying(layer.affineTransform())
        oldPoint = oldPoint.applying(layer.affineTransform())
        
        var position = layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        layer.position = position
        layer.anchorPoint = anchorPoint
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true

    }

}
