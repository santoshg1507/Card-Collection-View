# Card-Collection-View
project show the yours view like cards.  you can card by swip the card

Xcode version 9.0
Swift 3.0

The CardView Class has two protocal
1 - DataSource
2 - Delegate

protocol CardViewDataSouce {
    func numberOfcards(_ cardView: CardView) -> Int
    
    func cardView(_ cardView: CardView, cardFor index: Int) -> UIView
}

protocol CardViewDelegate {

    func cardView(_ card: UIView, didSelectCardAt index: Int)
}




    var cardsView : CardView!

    override func viewDidLoad() {
        super.viewDidLoad()
        cardsView.dataSource = self
        cardsView.delegate = self
        cardsView.loadCards(index: 0)
        // Do any additional setup after loading the view, typically from a nib.
    }
