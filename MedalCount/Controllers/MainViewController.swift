/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

final class MainViewController: UIViewController {
  //  MARK: - IBOutlets
  @IBOutlet weak var yearLabel: UILabel!
  @IBOutlet weak var hostLabel: UILabel!
  @IBOutlet weak var medalCountButton: UIButton!
  @IBOutlet weak var logoImageView: UIImageView!

  //  MARK: - Properties
  //  MARK: Step 4
  lazy var slideInTransitioningDelegate = SlideInPresentationManager()
  private let dataStore = GamesDataStore()
  private var presentedGames: Games? {
    didSet {
      configurePresentedGames()
    }
  }

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    presentedGames = nil
  }

  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let controller = segue.destination as? GamesTableViewController {
      if segue.identifier == "SummerSegue" {
        controller.gamesArray = dataStore.allGames.summer
        
        // MARK: Step 5
        slideInTransitioningDelegate.direction = .left
      }
      else if segue.identifier == "WinterSegue" {
        controller.gamesArray = dataStore.allGames.winter
        
        // MARK: Step 6
        slideInTransitioningDelegate.direction = .right
      }
      
      controller.delegate = self
      
      //  MARK: Step 7
      /// UIViewControllerTransitioningDelegate Protocol:
      /// When you want to present a view controller using a custom modal presentation type, set its modalPresentationStyle property to custom and assign an object that conforms to this protocol to its transitioningDelegate property.
      /// The transitioning delegate object is a custom object that you provide and that conforms to the UIViewControllerTransitioningDelegate protocol
      controller.transitioningDelegate = slideInTransitioningDelegate
      
      /// When the view controller’s modalPresentationStyle property is UIModalPresentationStyle.custom, UIKit uses the object in this property to facilitate transitions and presentations for the view controller
      controller.modalPresentationStyle = .custom
      
      // MARK: Step 24
      /// To tell SlideInPresentationManager when to disable compact height
      slideInTransitioningDelegate.disableCompactHeight = false
    }
    else if let controller = segue.destination as? MedalCountViewController {
      controller.medalWinners = presentedGames?.medalWinners
      
      // MARK: Step 8
      slideInTransitioningDelegate.direction = .bottom
      controller.transitioningDelegate = slideInTransitioningDelegate
      controller.modalPresentationStyle = .custom
      
      // MARK: Step 25
      /// To tell SlideInPresentationManager when to disable compact height
      slideInTransitioningDelegate.disableCompactHeight = true

    }
  }
}

// MARK: - Private
private extension MainViewController {
  func configurePresentedGames() {
    /// Property Observer to adjust view coorisponding with situations
    guard let presentedGames = presentedGames else {
      logoImageView.image = UIImage(named: "medals")
      hostLabel.text = nil
      yearLabel.text = nil
      medalCountButton.isHidden = true
      return
    }

    logoImageView.image = UIImage(named: presentedGames.flagImageName)
    hostLabel.text = presentedGames.host
    yearLabel.text = presentedGames.seasonYear
    medalCountButton.isHidden = false
  }
}

// MARK: - GamesTableViewControllerDelegate
extension MainViewController: GamesTableViewControllerDelegate {
  func gamesTableViewController(controller: GamesTableViewController, didSelectGames selectedGames: Games) {
    presentedGames = selectedGames
    dismiss(animated: true)
  }
}
