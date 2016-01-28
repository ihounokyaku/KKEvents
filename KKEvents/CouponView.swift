//
//  CouponView.swift
//  KKEvents
//
//  Created by Southard Dylan on 1/22/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit

class CouponView: UIView {
    
    @IBOutlet weak var labelTest: UILabel!
    
    @IBOutlet weak var imageViewer: UIImageView!
    //@IBOutlet weak var couponTableView: UITableView!
    
    var animator:UIDynamicAnimator!
    var container:UICollisionBehavior!
    //var snap:UISnapBehavior
    var dynamicItem:UIDynamicItemBehavior!
    var gravity:UIGravityBehavior!
    
    var panGestureRecognizer:UIPanGestureRecognizer!
    
    
    var imageName = ""
    var arrowUpImage:UIImage = UIImage()
    var arrowDownImage:UIImage = UIImage()
   // var imageViewer:UIImageView = UIImageView()

    
    
  
func changeLabel (label:String){
    self.labelTest.text = label
}
    func setImage (arrowUp:UIImage, arrowDown:UIImage){
        self.arrowDownImage = arrowDown
        self.arrowUpImage = arrowUp
        
        //self.imageName = "arrowDown.png"
        //self.arrowImage = UIImage(named: self.imageName)!
        //self.imageViewer.image = (self.arrowImage)
       // self.imageViewer = UIImageView(frame:CGRectMake(0, 0, 30, 12))
       // let boundaryWidth = UIScreen.mainScreen().bounds.size.width
       // let boundaryHeight = UIScreen.mainScreen().bounds.size.height

       // self.imageViewer.frame.origin.x = boundaryWidth / 2 - 15
       // self.imageViewer.frame.origin.y = boundaryHeight - 20
        
       // self.addSubview(imageViewer)

        
        
        
    }


    func setup () {
        
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        panGestureRecognizer.cancelsTouchesInView = false
        
        self.addGestureRecognizer(panGestureRecognizer)
        
        animator = UIDynamicAnimator(referenceView: self.superview!)
        dynamicItem = UIDynamicItemBehavior(items: [self])
        dynamicItem.allowsRotation = false
        dynamicItem.elasticity = 0
        
        gravity = UIGravityBehavior(items: [self])
        gravity.gravityDirection = CGVectorMake(0, -1)
        
        container = UICollisionBehavior(items: [self])
        
        configureContainer()
        
        animator.addBehavior(gravity)
        animator.addBehavior(dynamicItem)
        animator.addBehavior(container)
                
        
        //var imageViewObject :UIImageView
        //imageViewObject = UIImageView(frame:CGRectMake(0, 0, 100, 100));
       // imageViewObject.image = UIImage(named:"imageName.png")
       // self.view.addSubview(imageViewObject)
       // let horizontalConstraint = NSLayoutConstraint(item: imageViewer, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: superview, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
       // self.addConstraint(horizontalConstraint)
        
       // let verticalConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: , attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
       // self.addConstraint(verticalConstraint)
        
      //  imageViewer.frame.origin.x = self.frame.size.width / 2
        
        
       // imageViewer.frame.origin.y = self.frame.origin.y = (self.frame.size.height / 2) + 44
        
    }
    
    func configureContainer (){
        let boundaryWidth = UIScreen.mainScreen().bounds.size.width
        container.addBoundaryWithIdentifier("upper", fromPoint: CGPointMake(0, -self.frame.size.height + 100), toPoint: CGPointMake(boundaryWidth, -self.frame.size.height + 100))
        
        let boundaryHeight = UIScreen.mainScreen().bounds.size.height
        container.addBoundaryWithIdentifier("lower", fromPoint: CGPointMake(0, boundaryHeight), toPoint: CGPointMake(boundaryWidth, boundaryHeight))
        
        
    }
    
    func handlePan (pan:UIPanGestureRecognizer){
        let velocity = pan.velocityInView(self.superview).y
        
        var movement = self.frame
        movement.origin.x = 0
        movement.origin.y = movement.origin.y + (velocity * 0.05)
        
        if pan.state == .Ended {
            panGestureEnded()
        }else if pan.state == .Began {
            snapToBottom()
        }else{
            //    animator.removeBehavior(snap)
            //   snap = UISnapBehavior(item: self, snapToPoint: CGPointMake(CGRectGetMidX(movement), CGRectGetMidY(movement)))
            //   animator.addBehavior(snap)
        }
        
    }
    
    func panGestureEnded () {
        //  animator.removeBehavior(snap)
        
        let velocity = dynamicItem.linearVelocityForItem(self)
        
        if fabsf(Float(velocity.y)) > 10 {
            if velocity.y < 0 {
                snapToTop()
            }else{
                snapToBottom()
            }
        }else{
            if let superViewHeigt = self.superview?.bounds.size.height {
                if self.frame.origin.y > superViewHeigt / 2 {
                    snapToBottom()
                }else{
                    snapToTop()
                }
            }
        }
        
    }
    
    func snapToBottom() {
        
        gravity.gravityDirection = CGVectorMake(0, 2.5)
        //self.imageName = "arrowUp.png"
        //self.arrowImage = UIImage(named: self.imageName)!
        
       // self.imageViewer.image = self.arrowUpImage
        

    }
    
    func snapToTop(){
        gravity.gravityDirection = CGVectorMake(0, -2.5)
        //self.imageName = "arrowDown.png"
        //self.arrowImage = UIImage(named: self.imageName)!
        //self.imageViewer.image = self.arrowDownImage
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
