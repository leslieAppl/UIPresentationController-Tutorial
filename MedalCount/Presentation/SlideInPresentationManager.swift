/// Copyright (c) 2020 Razeware LLC
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
//  MARK: Step 2
enum PresentationDirection {
  case left
  case top
  case right
  case bottom
}

class SlideInPresentationManager: NSObject {
  //  MARK: Step 3
  var direction: PresentationDirection = .left
  
  //  MARK: Step 21
  /// To indicate if the presentation supports compact height
  var disableCompactHeight = false
}

//  MARK: Step 1
//  MARK: - UIViewControllerTransitioningDelegate
/// 1.
/// When you want to present a view controller using a custom modal presentation type, set its modalPresentationStyle property to custom and assign an object that conforms to this protocol to its transitioningDelegate property. - Step 7, 8
/// 2.
/// When you present that view controller, UIKit queries your [transitioning delegate] for the objects to use when animating the view controller into position.
/// 3.
/// When implementing your [transitioning delegate object], you can return different [animator objects] depending on whether a view controller is being presented or dismissed. All transitions use a transition animator object—an object that conforms to the UIViewControllerAnimatedTransitioning protocol—to implement the basic animations. - Step 20

extension SlideInPresentationManager: UIViewControllerTransitioningDelegate {
  
  //  MARK: Step 18
  /// When you present a view controller using the UIModalPresentationStyle.custom presentation style, the system calls this method and asks for the presentation controller that manages your custom style. If you implement this method, use it to create and return the custom presentation controller object that you want to use to manage the presentation process.
  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    
    /// Here you instantiate a SlideInPresentationController with the direction from SlideInPresentationManager
    let presentationController = SlideInPresentationController(presentedViewController: presented, presenting: presenting, direction: direction)
    
    //  MARK: Step 23
    /// The delegate object for managing adaptive presentations. The object you assign to this property must conform to the UIAdaptivePresentationControllerDelegate protocol. When the app’s size changes, the presentation controller works with this delegate object to determine an appropriate response.
    /// Note: View controllers presented using the UIModalPresentationStyle.formSheet, UIModalPresentationStyle.popover, or UIModalPresentationStyle.custom style must change to use one of the full-screen presentation styles instead.
    presentationController.delegate = self
    
    return presentationController
  }
  
  //  MARK: Step 20
  /// Hooking up the animation controller
  /// Asks your delegate for the transition [animator object] to use when presenting a view controlle
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return SlideInPresentationAnimator(direction: direction, isPresentation: true)
  }
  
  /// Asks your delegate for the transition [animator object] to use when dismissing a view controller.
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return SlideInPresentationAnimator(direction: direction, isPresentation: false)
  }
}

// MARK: - UIAdaptivePresentationControllerDelegate
extension SlideInPresentationManager: UIAdaptivePresentationControllerDelegate {
  
  //  MARK: Step 22
  /// Asks the delegate for the presentation style to use when the specified set of traits are active.
  /// Note: View controllers presented using the UIModalPresentationStyle.formSheet, UIModalPresentationStyle.popover, or UIModalPresentationStyle.custom style must change to use one of the full-screen presentation styles instead (from delegate Discussion.)
  func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
    
    if traitCollection.verticalSizeClass == .compact && disableCompactHeight {
      return .overFullScreen
    }
    else {
      return .none
    }
    
  }
  
  //  MARK: Step 26
  /// Asks the delegate for the view controller to display when adapting to the specified presentation style. This method returns a view controller that overrides the original controller to present.
  /// This method coorperats with adaptivePresentationStyle(for controller:) method.
  func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
    guard case(.overFullScreen) = style else { return nil }
    return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "RotateViewController")
  }
}
