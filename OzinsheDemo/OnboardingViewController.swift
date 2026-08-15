//
//  OnboardingViewController.swift
//  OzinsheDemo
//
//  Created by Allan Auezkhan on 12.08.2026.
//

import UIKit
import AdvancedPageControl

class OnboardingViewController: UIViewController {

    // MARK: - Data
    private let slides: [OnboardingSlide] = [
        OnboardingSlide(
            imageName: "firstSlide",
            title: NSLocalizedString("onboarding_title_1".localized(), comment: ""),
            subtitle: NSLocalizedString("onboarding_subtitle_1".localized(), comment: "")
        ),
        OnboardingSlide(
            imageName: "secondSlide",
            title: NSLocalizedString("onboarding_title_2".localized(), comment: ""),
            subtitle: NSLocalizedString("onboarding_subtitle_2".localized(), comment: "")
        ),
        OnboardingSlide(
            imageName: "thirdSlide",
            title: NSLocalizedString("onboarding_title_3".localized(), comment: ""),
            subtitle: NSLocalizedString("onboarding_subtitle_3".localized(), comment: "")
        )
    ]
    
    // MARK: - UI Elements
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .black
        cv.dataSource = self
        cv.delegate = self
        cv.register(OnboardingSlideCell.self, forCellWithReuseIdentifier: OnboardingSlideCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("skip", comment: ""), for: .normal)
        // Dark text color for the white background pill
        button.setTitleColor(UIColor(named: "111827") ?? .darkGray, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 12) ?? .systemFont(ofSize: 12, weight: .medium)
        // White background to match design
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let pageControl: AdvancedPageControlView = {
        let pc = AdvancedPageControlView()
        let drawer = ExtendedDotDrawer(
            numberOfPages: 3,
            height: 6,
            width: 6,
            space: 6,
            raduis: 3,
            currentItem: 0,
            indicatorColor: UIColor(named: "B376F7") ?? UIColor(red: 179/255, green: 118/255, blue: 247/255, alpha: 1.0),
            dotsColor: UIColor(named: "D1D5DB") ?? UIColor(red: 209/255, green: 213/255, blue: 219/255, alpha: 1.0)
        )
        pc.drawer = drawer
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("next", comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor(named: "7C3AED") ?? UIColor(red: 124/255, green: 58/255, blue: 237/255, alpha: 1.0)
        button.layer.cornerRadius = 12
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        // Add subviews in order
        view.addSubview(collectionView)
        view.addSubview(skipButton)
        view.addSubview(pageControl)
        view.addSubview(nextButton)
        
        // Explicitly bring control elements to the front above collection view cell layers
        view.bringSubviewToFront(skipButton)
        view.bringSubviewToFront(nextButton)
        view.bringSubviewToFront(pageControl)
        
        NSLayoutConstraint.activate([
            // CollectionView background
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Skip Button top right
            skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // PageControl positioning
            pageControl.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -24),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 10),
            pageControl.widthAnchor.constraint(equalToConstant: 120),
            
            // Bottom Action Button
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            nextButton.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        pageControl.numberOfPages = slides.count
    }

    private func finishOnboarding() {
        guard let window = view.window else { return }
        let loginVC = LoginViewController()
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = UINavigationController(rootViewController: loginVC)
        })
    }
    
    private func setupActions() {
        skipButton.addTarget(self, action: #selector(didTapSkip), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
    }
    
    @objc private func didTapSkip() {
        let lastPageIndex = slides.count - 1
        let lastPageIndexPath = IndexPath(item: lastPageIndex, section: 0)
        
        collectionView.scrollToItem(
            at: lastPageIndexPath,
            at: .centeredHorizontally,
            animated: true
        )
    }
    
    
    @objc private func didTapNext() {
        finishOnboarding()
    }
    
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegateFlowLayout
extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: OnboardingSlideCell.identifier,
            for: indexPath
        ) as? OnboardingSlideCell else {
            return UICollectionViewCell()
        }
        
        let slide = slides[indexPath.item]
        cell.configure(imageName: slide.imageName, title: slide.title, subtitle: slide.subtitle)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleWidth = scrollView.frame.width
        guard visibleWidth > 0 else { return }
        
        let offset = scrollView.contentOffset.x
        let progress = offset / visibleWidth
        
        pageControl.setPageOffset(progress)
        
        let currentPage = Int(round(progress))
        let isLastPage = (currentPage == slides.count - 1)
        
        UIView.animate(withDuration: 0.25) {
            self.nextButton.isHidden = !isLastPage
            self.skipButton.alpha = isLastPage ? 0 : 1
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
