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

//MARK: - Controlling animate transition directions in this file
final class SlideInPresentationAnimator: NSObject {
  //MARK: Step 19
  //MARK: - Properties
  let direction: PresentationDirection
  let isPresentation: Bool
  
  //MARK: - Initializers
  init(direction: PresentationDirection, isPresentation: Bool) {
    self.direction = direction
    self.isPresentation = isPresentation
    super.init()
  }
  
}

//MARK: - UIViewControllerAnimatedTransitioning
/// The methods in this protocol let you define an animator object, which creates the animations for transitioning a view controller on or off screen in a fixed amount of time.

/// All transitions use a transition animator object:
/// an object that conforms to the UIViewControllerAnimatedTransitioning protocol—to implement the basic animations.
/// Create your [animator object] from a transitioning delegate—an object that conforms to the UIViewControllerTransitioningDelegate protocol.
/// When presenting a view controller, set the presentation style to UIModalPresentationStyle.custom and assign your transitioning delegate to the view controller’s transitioningDelegate property. The view controller retrieves your animator object from the transitioning delegate and uses it to perform the animations. You can provide separate animator objects for presenting and dismissing the view controller.

/// To add user interaction to a view controller transition, you must use an animator object together with an interactive animator object—a custom object that adopts the UIViewControllerInteractiveTransitioning protocol.
extension SlideInPresentationAnimator: UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.3
  }
  
  /// Implementing the animateTransition(using:) method to create the animations themselves. Information about the objects involved in the transition is passed to your animateTransition(using:) method in the form of [a context object]. Use the information provided by that object to move the target view controller’s view on or off screen over the specified duration.
  /// transitionContext: The context object containing information about the transition.
  /// containerView: The container view acts as the superview of all other views (including those of the presenting and presented view controllers) during the animation sequence.
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    /// 1
    /// If this is a presentation, the method asks the transitionContext for the view controller associated with .to. This is the view controller you’re moving to. If dismissal, it asks the transitionContext for the view controller associated with .from. This is the view controller you’re moving from.
    /// .to: A key that identifies the view controller that is visible at the end of a completed transition.
    /// .from: A key that identifies the view controller that is visible at the beginning of the transition, or at the end of a canceled transition.
    let key: UITransitionContextViewControllerKey = isPresentation ? .to : .from

    guard let controller = transitionContext.viewController(forKey: key) else { return }
    
    /// 2
    /// If the action is a presentation, your code adds the view controller’s view to the view hierarchy. This code uses the transitionContext to get the container view.
    if isPresentation {
      transitionContext.containerView.addSubview(controller.view)
    }
    
    /// 3
    /// Calculate the frames you’re animating from and to. The first line asks the transitionContext for the view’s frame when it’s presented. The rest of the section tackles the trickier task of calculating the view’s frame when it’s dismissed. This section sets the frame’s origin so it’s just outside the visible area based on the presentation direction.
    let presentedFrame = transitionContext.finalFrame(for: controller)
    var dismissedFrame = presentedFrame
    switch direction {
    case .left:
      dismissedFrame.origin.x = -presentedFrame.width
    case .right:
      dismissedFrame.origin.x = transitionContext.containerView.frame.size.width
    case .top:
      dismissedFrame.origin.y = -presentedFrame.height
    case .bottom:
      dismissedFrame.origin.y = transitionContext.containerView.frame.size.height
    }
    
    /// 4
    /// Determine the transition’s initial and final frames. When presenting the view controller, it moves from the dismissed frame to the presented frame — vice versa when dismissing.
    let initialFrame = isPresentation ? dismissedFrame : presentedFrame
    let finalFrame = isPresentation ? presentedFrame : dismissedFrame
    
    /// 5
    /// Lastly, this method animates the view from initial to final frame. If this is a dismissal, you remove the view controller’s view from the view hierarchy.
    /// Note that you call completeTransition(_:) on transitionContext to inform the transition has finished.
    let animationDuration = transitionDuration(using: transitionContext)
    controller.view.frame = initialFrame
    UIView.animate(withDuration: animationDuration, animations: {
      controller.view.frame = finalFrame
    }) { (finished) in
      if !self.isPresentation {
        controller.view.removeFromSuperview()
      }
      
      /// You must call this method after your animations have completed to notify the system that the transition animation is done. The parameter you pass must indicate whether the animations completed successfully. The best place to call this method is in the completion block of your animations. The default implementation of this method calls the animator object’s animationEnded(_:) method to give it a chance to perform any last minute cleanup.
      transitionContext.completeTransition(finished)
    }
  }
}
