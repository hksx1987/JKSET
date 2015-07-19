# JKSET
The iOS SET game demo (not complete version).

This is a iOS version of SET game demo for showing what this game is and how to play it. Most importantly, it is the demo for showing the Objective C programming language.

The project is an assignment of Stanford iOS 7 development course and the purpose of this demo is for showing general features of Objective C. What you can see:

1. This demo not includes other frameworks except Foundation and UIKit. It focus the language.
（该演示的重点在于对objective c语言的使用，而非各种框架的应用）

2. Manually memory management, objects are managed by retain/release.
（该演示为手动内存管理）

3. Object-oriented programming style with good extensibility and flexibility.
（体现了面向对象编程风格，带有良好的延展性，灵活易改动）

4. Well-structured, localization, simple runtime feature.
（良好架构，本地化应用，简单动态特性的体现）

5. Simple UICollectionView with good performance
（简单UICollectionView的应用，并体现良好的性能）


－－－－－－－－－－－－－－－－－－－－－－－－－


Controllers:


JKCardGameViewController

  -The abstract class as generic controller for handle card match game. You can subclass it and use for any card matching game. it’s subclass of UICollectionViewController.


JKSETCardGameViewController

  -The concrete class for handle SET card game. It’s subclass of JKCardGameViewController.


JKSETTrainingViewController

  -The introduction guide for showing user the rule of game and how to play it.



Models:


Card

  -The generic card for matching game. Abstract class.


Deck

  -The generic deck for matching game. Abstract class.


JKCardMatchingGameBrain

  -The logic of card matching game. Handles basic cards dealing and matching. It can be added new APIs for more features and complexity. It’s also the generic class that can be used for any card matching game and it contains delegate callback for receiving matching results.


SETCard

  -The subclass of Card. It shows the basic structure of SET card.


SETDeck

  -The subclass of Deck. It generates 81 SET cards for SET game.


JKSETJudge

  -Additional class for giving user nice description feedback about miss-match details.(Using delegate callback)


JKSETTrainer

  -Additional class for helping user practice the game.



Views:


JKSetCardView

  -The custom view for drawing a SET card. It’s designed to be an abstract class, so you can subclass it and provide different colors and shapes for more customized SET game.


JKClassicSetCardView

  -The concrete class for drawing the classic SET card. It draws the RED, GREEN, PURPLE as color components, and draws the DIAMOND, SQUIGGLE, OVAL as three different shapes.



Categories:


CALayer+IndexPath

  -This category using runtime API to bind the CALayer object with NSIndexPath object, so you can access the particular CALayer object by locating it with indexPath.
