import UIKit
 // Created by Cyrus Shakya , Anup saud and Nabin pun

class HangmanViewController: UIViewController {
    
    @IBOutlet weak var stickmanImage: UIImageView!
    
    @IBOutlet weak var firstLetterField: UITextField!
    @IBOutlet weak var secondLetterField: UITextField!
    @IBOutlet weak var thirdLetterField: UITextField!
    @IBOutlet weak var fourthLetterField: UITextField!
    @IBOutlet weak var fifthLetterField: UITextField!
    @IBOutlet weak var sixthLetterField: UITextField!
    @IBOutlet weak var seventhLetterField: UITextField!
    
    @IBOutlet weak var loseCounterLabel: UILabel!
    @IBOutlet weak var winCounterLabel: UILabel!
    
    let words : [Int: String] = [1:"HANGMAN", 2:"COUNTRY", 3:"PLATEAU", 4:"CODINGS", 5:"STUDENT",6: "THUNDER", 7:"AVOCADO",8:"SPEAKER",9:"RAJGEDA",10:"DALEGAY"]
    
    var keyboardView:[UIButton]=[]
    
    var currentWord: String = ""
    var failedAttempt:Int=0
    
    var letterFieldList :[Int:UITextField]=[:]
    
    var correctPrediction:Bool=false
    var correctPredictCounter=0
    
    var wins = 0
    var losses = 0
    
    var disableUI:Bool=false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        styleTextField()
        startNewGame()
    }
    
    func startNewGame(){
        //make win or loss to 0
        winCounterLabel.text="Win: \(String(wins))"
        loseCounterLabel.text="Losses: \(String(losses))"
        
        // array to add hangman text view
         letterFieldList=[1:firstLetterField,2:secondLetterField,3:thirdLetterField,4:fourthLetterField,5:fifthLetterField,6:sixthLetterField,7:seventhLetterField
        ]
        
        
        //clearing all the ui elements and variable
        currentWord=newWord()
        failedAttempt=0
        correctPredictCounter=0
        
        
        // making image default
        stickmanImage.image = UIImage(named: "hangbar")
        
        // making text view field empty
        for (index,_) in letterFieldList.enumerated(){
            letterFieldList[index+1]?.text=""
        }
        
    }
    
    
    func newWord() -> String{
        let keyName = words.keys.randomElement() ?? 1
        let selectedWord: String?=words[keyName] ?? ""
        let newWordUppercased=selectedWord?.uppercased()
        print("selected word \(newWordUppercased ?? "")")
        return newWordUppercased ?? ""

    }
    

    func styleTextField(){
        let myColor = UIColor.white
        
        firstLetterField.layer.borderColor = myColor.cgColor
        secondLetterField.layer.borderColor = myColor.cgColor
        thirdLetterField.layer.borderColor = myColor.cgColor
        fourthLetterField.layer.borderColor = myColor.cgColor
        fifthLetterField.layer.borderColor = myColor.cgColor
        sixthLetterField.layer.borderColor = myColor.cgColor
        seventhLetterField.layer.borderColor = myColor.cgColor
        firstLetterField.layer.borderWidth = 1.0
        secondLetterField.layer.borderWidth = 1.0
        thirdLetterField.layer.borderWidth = 1.0
        fourthLetterField.layer.borderWidth = 1.0
        fifthLetterField.layer.borderWidth = 1.0
        sixthLetterField.layer.borderWidth = 1.0
        seventhLetterField.layer.borderWidth = 1.0
    }
    
    @IBAction func onKeyboardPressed(_ sender: UIButton) {
        
        
        if(disableUI) {
            return
        }
        
        keyboardView.append(sender)
        
        
        let buttonTitleLabel=(sender.titleLabel?.text?.first)!
        let wordCompare:Bool=currentWord.contains(buttonTitleLabel)
        
        let questionWordList = Array(currentWord)
        
        if (wordCompare){
            
            // add key to text view
            for (index, item) in questionWordList.enumerated() where item == buttonTitleLabel {
                print("Index of \(buttonTitleLabel): \(index)")
                letterFieldList[index+1]?.text = String(item)
                correctPredictCounter=correctPredictCounter+1
                
            }
            
            // function to change key color
            defaultKeyboardColor(isCurrentGuessKeyCorrect:true)
            
            if(correctPredictCounter==7){
                correctPrediction=true
                stickmanImage.image = UIImage(named: "safebody")
                showAlert()
            }
      
            
        }
        else{
            // function to change key color
            defaultKeyboardColor(isCurrentGuessKeyCorrect:false)
            
            // increase wrong guess count
            failedAttempt=failedAttempt+1
            
            // func to add body parts according to incorrect guess
            changeStickman(failedAttempt: failedAttempt)
            
        }
        
           func defaultKeyboardColor(isCurrentGuessKeyCorrect:Bool){
               sender.isEnabled=false
               sender.backgroundColor = isCurrentGuessKeyCorrect ? UIColor.green : UIColor.red
               sender.setBackgroundImage(nil, for: .disabled)
               sender.layer.cornerRadius=10
           }
        
        
    }
    
    
    func changeStickman(failedAttempt:Int){
        if(failedAttempt==1){
            stickmanImage.image = UIImage(named: "headonly")
        }
        else if(failedAttempt==2){
            stickmanImage.image = UIImage(named: "body")
        }else if (failedAttempt==3){
            stickmanImage.image = UIImage(named: "leftarm")
        }
        else if (failedAttempt==4){
            stickmanImage.image = UIImage(named: "arms")
        }
        else if (failedAttempt==5){
            stickmanImage.image = UIImage(named: "leftleg")
        }
        else if (failedAttempt==6){
            stickmanImage.image = UIImage(named: "finalbody")
        }
        else{
            stickmanImage.image = UIImage(named: "deadbody")
            correctPrediction=false
            showAlert()
        }
    }
    
    func showAlert(){
        let title=correctPrediction ? "Woohoo!":"Sorry"
        let description=correctPrediction ?"I'm safe! Would you like to play again?" :"The correct word was \(currentWord). Would you like to play again?"
        
        let alert = UIAlertController(title: title, message:description , preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {  _ in
            self.onAlertPress()
            self.winLossCounter()
        }))

        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { [self]_ in
            disableUI=true
            winLossCounter()
        }))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func onAlertPress(){
        
        //clearing all the ui elements and variable
        currentWord=newWord()
        failedAttempt=0
        correctPredictCounter=0
        
        // making image default
        stickmanImage.image = UIImage(named: "hangbar")
        
        // making text view field empty
        for (index,_) in letterFieldList.enumerated(){
            letterFieldList[index+1]?.text=""
        }
        
        
        // all selcted keys to previous state
        for item in keyboardView{
            item.isEnabled=true
            item.backgroundColor = UIColor.systemTeal
            item.setBackgroundImage(nil, for: .normal)
            item.layer.cornerRadius=8
        }
        
    }
    
    
    func winLossCounter(){
        if(correctPrediction){
            wins=wins+1
            winCounterLabel.text="Win: \(String(wins))"
        }
        else{
            losses=losses+1
            loseCounterLabel.text="Losses: \(String(losses))"
        }

    }
    

}
