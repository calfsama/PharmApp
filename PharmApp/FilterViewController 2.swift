//
//  FilterViewController.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 10/03/23.
//

import UIKit

class FilterViewController: UIViewController {
    var searchProduct: String = ""
    let slider = DoubledSlider()
    var network = NetworkService()
    var popularCondition: Bool = false
    var notPopularCondition: Bool = false
    
    lazy var minPrice: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var maxPrice: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var uiview: UIView = {
        let uiview = UIView()
        uiview.backgroundColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1)
        uiview.layer.cornerRadius = 4
        uiview.translatesAutoresizingMaskIntoConstraints = false
        return uiview
    }()
    
    lazy var price: UILabel = {
        let label = UILabel()
        label.text = "Цена"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var raiting: UILabel = {
        let label = UILabel()
        label.text = "Рейтинг"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var popular: UILabel = {
        let label = UILabel()
        label.text = "популярные"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var notPopular: UILabel = {
        let label = UILabel()
        label.text = "непопулярные"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var showButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0.118, green: 0.745, blue: 0.745, alpha: 1)
        button.setTitle("Показать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var notPopularButton: UIButton = {
        let button =  UIButton()
        button.setImage(UIImage(named: "Radiobutton 1"), for: .normal)
        //button.addTarget(self, action: #selector(actionForNotPopularButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var popularButton: UIButton = {
        let button =  UIButton()
        button.setImage(UIImage(named: "Radiobutton 1"), for: .normal)
        //button.addTarget(self, action: #selector(actionForPopularButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var data: DataFilter?
    var filterData: Filter?

    @objc func tapped() {
        self.dismiss(animated: true)
        data?.data(minimumPrice: "\(slider.values.minimum)", maximumPrice: "\(slider.values.maximum)", kind: "String")
        filterData?.updateData(minPrice: "\(slider.values.minimum)", maxPrice: "\(slider.values.maximum)")
        self.dismiss(animated: true)
    }
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    let maxDimmedAlpha: CGFloat = 0.6
    lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = maxDimmedAlpha
        return view
    }()
    
    // Constants
    let defaultHeight: CGFloat = 300
    let dismissibleHeight: CGFloat = 300
    let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
    // keep current new height, initial is default height
    var currentContainerHeight: CGFloat = 300
    
    // Dynamic container constraint
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        // tap gesture on dimmed view to dismiss
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
        dimmedView.addGestureRecognizer(tapGesture)
        slider.minimumValue = 1
        slider.maximumValue = 2000
        minPrice.text = "\(Int(slider.minimumValue))"
        maxPrice.text = "\(Int(slider.maximumValue))"
        slider.values.minimum = 1
        slider.values.maximum = 2000
        slider.addTarget(self, action: #selector(didChangeSliderValue), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        setupPanGesture()
    }
    
    @objc func handleCloseAction() {
        animateDismissView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentContainer()
    }
    
    func setupView() {
        view.backgroundColor = .clear
    }
    
    func setupConstraints() {
        // Add subviews
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
       // containerView.addSubview(contentStackView)
        containerView.addSubview(price)
        containerView.addSubview(minPrice)
        containerView.addSubview(maxPrice)
        containerView.addSubview(slider)
        containerView.addSubview(raiting)
        containerView.addSubview(popularButton)
        containerView.addSubview(popular)
        containerView.addSubview(notPopularButton)
        containerView.addSubview(notPopular)
        containerView.addSubview(showButton)
        
        // Set static constraints
        NSLayoutConstraint.activate([
            // set dimmedView edges to superview
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // set container static constraint (trailing & leading)
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            price.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            price.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            slider.topAnchor.constraint(equalTo: price.bottomAnchor, constant: 20),
            slider.widthAnchor.constraint(equalToConstant: view.frame.size.width - 32),
            slider.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            
            minPrice.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 5),
            minPrice.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            maxPrice.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 5),
            maxPrice.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            raiting.topAnchor.constraint(equalTo: minPrice.bottomAnchor, constant: 16),
            raiting.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            popularButton.topAnchor.constraint(equalTo: raiting.bottomAnchor, constant: 20),
            popularButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            popularButton.heightAnchor.constraint(equalToConstant: 20),
            popularButton.widthAnchor.constraint(equalToConstant: 20),

            popular.leadingAnchor.constraint(equalTo: popularButton.trailingAnchor, constant: 5),
            popular.topAnchor.constraint(equalTo: raiting.bottomAnchor, constant: 20),

            notPopularButton.topAnchor.constraint(equalTo: raiting.bottomAnchor, constant: 20),
            notPopularButton.leadingAnchor.constraint(equalTo: popular.trailingAnchor, constant: 25),
            notPopularButton.heightAnchor.constraint(equalToConstant: 20),
            notPopularButton.widthAnchor.constraint(equalToConstant: 20),

            notPopular.topAnchor.constraint(equalTo: raiting.bottomAnchor, constant: 20),
            notPopular.leadingAnchor.constraint(equalTo: notPopularButton.trailingAnchor, constant: 5),

            showButton.topAnchor.constraint(equalTo: notPopular.bottomAnchor, constant: 40),
            showButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            showButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            showButton.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        // Set dynamic constraints
        // First, set container to default height
        // after panning, the height can expand
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        
        // By setting the height to default height, the container will be hide below the bottom anchor view
        // Later, will bring it up by set it to 0
        // set the constant to default height to bring it down again
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        // Activate constraints
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
    
    @objc func actionForPopularButton() {
        if popularCondition == false {
            popularCondition = true
            notPopularCondition = false
            notPopularButton.setImage(UIImage(named: "Radiobutton 1"), for: .normal)
            popularButton.setImage(UIImage(named: "Radiobutton 2"), for: .normal)
            print("Find popular")
        }
        else if popularCondition == true {
            popularCondition = false
            popularButton.setImage(UIImage(named: "Radiobutton 1"), for: .normal)
        }
    }
    
    @objc func actionForNotPopularButton() {
        if notPopularCondition == false {
            notPopularCondition = true
            popularCondition = false
            popularButton.setImage(UIImage(named: "Radiobutton 1"), for: .normal)
            notPopularButton.setImage(UIImage(named: "Radiobutton 2"), for: .normal)
            print("Find not popular")
        }
        else if notPopularCondition == true {
            notPopularCondition = false
            notPopularButton.setImage(UIImage(named: "Radiobutton 1"), for: .normal)
        }
    }
    
    @objc private func didChangeSliderValue() {
        print(self.slider.values.minimum)
        print(self.slider.values.maximum)
        minPrice.text = "\(Int(slider.values.minimum))"
        maxPrice.text = "\(Int(slider.values.maximum))"
    }

    
    func setupPanGesture() {
        // add pan gesture recognizer to the view controller's view (the whole screen)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        // change to false to immediately listen on gesture movement
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }
    
    // MARK: Pan gesture handler
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        // Drag to top will be minus value and vice versa
//        print("Pan gesture y offset: \(translation.y)")
        
        // Get drag direction
        let isDraggingDown = translation.y > 0
//        print("Dragging direction: \(isDraggingDown ? "going down" : "going up")")
        
        // New height is based on value of dragging plus current container height
        let newHeight = currentContainerHeight - translation.y
        
        // Handle based on gesture state
        switch gesture.state {
        case .changed:
            // This state will occur when user is dragging
            if newHeight < maximumContainerHeight {
                // Keep updating the height constraint
                containerViewHeightConstraint?.constant = newHeight
                // refresh layout
                view.layoutIfNeeded()
            }
        case .ended:
            // This happens when user stop drag,
            // so we will get the last height of container
            
            // Condition 1: If new height is below min, dismiss controller
            if newHeight < dismissibleHeight {
                self.animateDismissView()
            }
            else if newHeight < defaultHeight {
                // Condition 2: If new height is below default, animate back to default
                animateContainerHeight(defaultHeight)
            }
            else if newHeight < maximumContainerHeight && isDraggingDown {
                // Condition 3: If new height is below max and going down, set to default height
                animateContainerHeight(defaultHeight)
            }
            else if newHeight > defaultHeight && !isDraggingDown {
                // Condition 4: If new height is below max and going up, set to max height at top
                animateContainerHeight(maximumContainerHeight)
            }
        default:
            break
        }
    }
    
    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            // Update container height
            self.containerViewHeightConstraint?.constant = height
            // Call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
        // Save current height
        currentContainerHeight = height
    }
    
    // MARK: Present and dismiss animation
    func animatePresentContainer() {
        // update bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = 0
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }
    
    func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
    
    func animateDismissView() {
        // hide blur view
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            // once done, dismiss without animation
            self.dismiss(animated: false)
        }
        // hide main view by updating bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }
}
