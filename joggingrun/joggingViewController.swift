//
//  joggingViewController.swift
//  joggingrun
//
//  Created by YOUNGWHAN SONG on 9/14/16.
//  Copyright © 2016 YOUNGWHAN SONG. All rights reserved.
//

import UIKit

class joggingViewController: UIViewController {
	
	var run1ImageView: UIImageView
	
	required init?(coder aDecoder: NSCoder) {
		let run1FileName = "run1.png"
		let run2FileName = "run2.png"
		
		let run1Image = UIImage(named: run1FileName)!
		let run2Image = UIImage(named: run2FileName)!
		
		let imgListArray : [UIImage] = [run1Image, run2Image]
		
		run1ImageView = UIImageView.init()
		run1ImageView.frame = CGRect(x: 50, y: 50, width: 100, height: 100)
		run1ImageView.animationImages = imgListArray
		run1ImageView.animationDuration = 1.0

		super.init(coder: aDecoder)
	}
	
	@IBAction func startAction(_ sender: UIButton) {
		run1ImageView.startAnimating()
	}
	
	@IBAction func stopAction(_ sender: UIButton) {
		run1ImageView.stopAnimating()
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(run1ImageView)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear( animated )
	}
}

