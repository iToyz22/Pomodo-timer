//
//  ViewController.swift
//  Pomodoro timer
//
//  Created by Anatoliy on 29.05.2022.
//

import UIKit

class ViewController: UIViewController {
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Pomodoro timer"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .red
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let shapeView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "elipse")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    var timerLable: UILabel = {
        let lable = UILabel()
        var countSecond: Int = 0
        var countMinutes: Int = 0
        lable.text = "0\(countMinutes) : 0\(countSecond)"
        lable.font = UIFont.boldSystemFont(ofSize: 60)
        lable.textColor = .systemPink
        lable.textAlignment = .center
        lable.translatesAutoresizingMaskIntoConstraints = false
        
        return lable
    }()
    
    var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("WORK", for: .normal)
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 25
        button.tintColor = .systemPink
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    var relaxButton: UIButton = {
        let button = UIButton()
        button.setTitle("RELAX", for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 25
        button.tintColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var timer = Timer()
    var durationTimer = 0
    let shapeLayer = CAShapeLayer()
    var runningTimer = false
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        animationCircular()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        targetButton()
        setConstraints()
    }
    
    @objc func setTimerLabel() {
        let countMinutes = Int(Double(durationTimer) / 60)
        let countSecond = durationTimer - (countMinutes * 60)
        var minuteString = String(countMinutes)
        var secondString = String(countSecond)
        
        if (countMinutes < 10) {
            minuteString = "0" + minuteString
        }
        
        if (countSecond < 10) {
            secondString = "0" + secondString
        }
        
        timerLable.text = minuteString + ":" + secondString
    }
    
    @objc
    func timerAction() {
        setTimerLabel()
        durationTimer = durationTimer - 1
        
        if durationTimer == 0 {
            timer.invalidate()
        }
    }
    
    @objc
    func addTapped() {
        durationTimer = 1500
        self.startAndPauseButton()
        
        if durationTimer == 0 {
            timer.invalidate()
        }
    }
    
    @objc func addTappedRelax() {
        durationTimer = 300
        self.startAndPauseButtonRelax()
        self.animationCircular()
        
        if durationTimer == 0 {
            timer.invalidate()
        }
    }
    
    func start() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        runningTimer = true
    }
    
    func pause() {
        timer.invalidate()
        runningTimer = false
    }
    func startAndPauseButton() {
        if runningTimer == false {
            return start()
        } else {
            startButton.setTitle("PAUSE", for: .normal)
            return pause()
        }
    }
    func startAndPauseButtonRelax() {
        if runningTimer == false {
            return start()
        } else {
            relaxButton.setTitle("PAUSE", for: .normal)
            return pause()
        }
    }
    
    func targetButton() {
        relaxButton.addTarget(self, action: #selector(addTappedRelax), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
    }
    //Animation
    func animationCircular() {
        
        let center = CGPoint(x:  shapeView.frame.width / 2, y: shapeView.frame.height / 2)
        
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        
        let circularPath = UIBezierPath(arcCenter: center , radius: 138, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.lineWidth = 60
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeView.layer.addSublayer(shapeLayer)
        
        if durationTimer >= 300  {
            shapeLayer.strokeColor = #colorLiteral(red: 0.8117350942, green: 0.2054043847, blue: 0.8012659077, alpha: 1).cgColor
        } else  {
            shapeLayer.strokeColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1).cgColor
        }
    }
    
    func basicAnimation() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 0
        basicAnimation.duration = CFTimeInterval(durationTimer)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = true
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }
}
extension ViewController {
    
    func setConstraints() {
        
        view.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 150),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        view.addSubview(shapeView)
        NSLayoutConstraint.activate([
            shapeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shapeView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            shapeView.heightAnchor.constraint(equalToConstant: 300),
            shapeView.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        view.addSubview(timerLable)
        NSLayoutConstraint.activate([
            timerLable.centerXAnchor.constraint(equalTo: shapeView.centerXAnchor),
            timerLable.centerYAnchor.constraint(equalTo: shapeView.centerYAnchor)
        ])
        
        view.addSubview(startButton)
        NSLayoutConstraint.activate([
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.heightAnchor.constraint(equalToConstant: 70),
            startButton.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        view.addSubview(relaxButton)
        NSLayoutConstraint.activate([
            relaxButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            relaxButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            relaxButton.heightAnchor.constraint(equalToConstant: 70),
            relaxButton.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
}
