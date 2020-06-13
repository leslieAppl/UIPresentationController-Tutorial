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

//MARK: - UIPresentationController
//An object that manages the transition animations and the presentation of view controllers onscreen.
//From the time a view controller is presented until the time it is dismissed, UIKit uses a presentation controller to manage various aspects of the presentation process for that view controller.
//The presentation controller can add its own animations on top of those provided by animator objects, it can respond to size changes, and it can manage other aspects of how the view controller is presented onscreen.
//When you present a view controller using the present(_:animated:completion:) method, UIKit always manages the presentation process. Part of that process involves creating the presentation controller that is appropriate for the given presentation style.
//You vend your custom presentation controller object through your view controller’s transitioning delegate. UIKit maintains a reference to your presentation controller object while the presented view controller is onscreen.
class SlideInPresentationController: UIPresentationController {
  
  //MARK: Step 11
  private var dimmingView: UIView!
  
  //MARK: Step 9
  private var direction: PresentationDirection
  
  override var frameOfPresentedViewInContainerView: CGRect {
    //MARK: Step 17
    //In addition to calculating the size of the presented view,
    //you need to return its full frame.
    var frame: CGRect = .zero
    frame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView!.bounds.size)
    
    switch direction {
    case .right:
      //If presenting start from right, the displayed view's x-coordinate  will end at 1/3 points from its super view.
      frame.origin.x = containerView!.frame.width*(1.0/3.0)
    case .bottom:
      //If presenting start from bottom, the displayed view's y-coordinate will ending at 1/3 points from its super view.
      frame.origin.y = containerView!.frame.height*(1.0/3.0)
    default:
      frame.origin = .zero
    }
    return frame
  }
  
  //MARK: Step 10
  init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, direction: PresentationDirection) {
    self.direction = direction
    
    //This method is the designated initializer for the presentation controller.
    //You must call it from any custom initialization methods you define for your presentation controller subclasses.
    super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    
    setupDimmingView()
  }
  
  //The default implementation of this method does nothing.
  //Subclasses can override it and use it to add custom views to the view hierarchy and to create any animations associated with those views.
  override func presentationTransitionWillBegin() {
  
    //MARK: Step 13
    guard let dimmingView = dimmingView else {
      return
    }
    
    // 1
    //Inserting dimmingView into presented containerView
    
    //container view: The view in which the presentation occurs.
    //UIKit sets the value of this property shortly after receiving the presentation controller from your transitioning delegate.
    //The container view is always an ancestor of the presented view controller’s view.
    //When adding custom views to a presentation, add them to the container view.
    //During transition animations, the container view also contains the presenting view controller’s view.
    containerView?.insertSubview(dimmingView, at: 0)

    // 2
    dimmingView.topAnchor.constraint(equalTo: containerView!.topAnchor).isActive = true
    dimmingView.bottomAnchor.constraint(equalTo: containerView!.bottomAnchor).isActive = true
    dimmingView.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor).isActive = true
    dimmingView.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor).isActive = true
    
    // 3
    //When a presentation or dismissal is in progress,
    //this method returns the transition coordinator object associated with that transition.
    //You can use this object to create additional animations
    //and synchronize them with the transition animations.
    //Note: setupDimmingView() do the same thing, if changed its alpha value.
    guard let coordinator = presentedViewController.transitionCoordinator else {
      dimmingView.alpha = 1.0
      return
    }
    
    //Runs the specified animations at the same time as the view controller transition animations.
    //Use this method to perform animations that are not handled by the animator objects themselves.
    //All of the animations you specify must occur inside the animation context’s container view (or one of its descendants).
    //Use the containerView property of the context object to get the container view.
    coordinator.animate(alongsideTransition: { _ in
      self.dimmingView.alpha = 1.0
    })
    
  }
  
  override func dismissalTransitionWillBegin() {
  
    //MARK: Step 14
    guard let coordinator = presentedViewController.transitionCoordinator else {
      dimmingView.alpha = 0.0
      return
    }
    
    coordinator.animate(alongsideTransition: { (_) in
      //This gives the effect of fading the dimming view
      self.dimmingView.alpha = 0.0
    }, completion: nil)
    
  }
  
  //Notifies the presentation controller that layout is about to begin on the views of the container view.
  //This override will respond to layout changes in the presentation controller's containerView.
  //UIKit calls this method before adjusting the layout of the views in the container view.
  override func containerViewWillLayoutSubviews() {
    //MARK: Step 15
    //Here you reset the presented view’s frame to fit any changes to the containerView frame.
    
    
    //presentedView?: The view to be animated by the animator objects during a transition.
    //The default implementation of this method returns the presented view controller’s view.
    //If you want to animate a different view, you may override this method and return that view.
    //The view you specify must either be the presented view controller’s view or must be one of its ancestors.
    //The view returned by this method is given to the animator objects, which are responsible for animating it onscreen.
    //The animator objects retrieve the view using the view(forKey:) method of the context object provided by UIKit.
    presentedView?.frame = frameOfPresentedViewInContainerView
  }
  
  //To give the size of the presented view controller's content to the presentation controller.
  //Container view controllers use this method to return the sizes for their child view controllers.
  // It calls the method once for each child view controller embedded in the view controller.
  //If you are implementing a custom container view controller, you should override this method and use it to return the sizes of the contained children.
  //And SlideInPresentationController is the custom container view controller: UIPresentationController.
  override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
    
    //MARK: Setp 16 -> Setp 17
    //Here calculating the size of the presented view.
    switch direction {
    case .left, .right:
      return CGSize(width: parentSize.width*(2.0/3.0), height: parentSize.height)
    case .bottom, .top:
      return CGSize(width: parentSize.width, height: parentSize.height*(2.0/3.0))
    }
  }
}

// MARK: - Private
private extension SlideInPresentationController {
  //MARK: Step 12
  func setupDimmingView() {
    dimmingView = UIView()
    dimmingView.translatesAutoresizingMaskIntoConstraints = false
    dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
    dimmingView.alpha = 0.0
    
    let recognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(recognizer:)))
    dimmingView.addGestureRecognizer(recognizer)
  }
  
  @objc func handlePan(recognizer: UIPanGestureRecognizer) {
    presentingViewController.dismiss(animated: true, completion: nil)
  }
}
