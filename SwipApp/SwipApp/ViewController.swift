//
//  ViewController.swift
//  SwipApp
//
//  Created by Bonadea 02 on 24/01/18.
//  Copyright © 2018 Bonadea 02. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CardViewDataSouce,CardViewDelegate {
    
    @IBOutlet var cardsView : CardView!

    override func viewDidLoad() {
        super.viewDidLoad()
        cardsView.dataSource = self
        cardsView.delegate = self
        cardsView.loadCards(index: 0)
        // Do any additional setup after loading the view, typically from a nib.
    }

    func numberOfcards(_ cardView: CardView) -> Int
    {
        return 7
    }
    
    func cardView(_ cardView: CardView, cardFor index: Int) -> UIView
    {
        // custom view
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        label.text = "\(index + 1)"
        label.backgroundColor = UIColor.yellow
        label.textAlignment = .center
        
        return label
    }
    
    func cardView(_ card: UIView, didSelectCardAt index: Int)
    {
        print("card no \(index + 1) tapped")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

