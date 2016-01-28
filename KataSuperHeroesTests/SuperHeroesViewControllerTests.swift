//
//  SuperHeroesViewControllerTests.swift
//  KataSuperHeroes
//
//  Created by Pedro Vicente Gomez on 13/01/16.
//  Copyright © 2016 GoKarumi. All rights reserved.
//

import Foundation
import KIF
import Nimble
import UIKit
@testable import KataSuperHeroes

class SuperHeroesViewControllerTests: AcceptanceTestCase {

    private var repository = MockSuperHeroesRepository()

    func testShowsEmptyCaseIfThereAreNoSuperHeroes() {
        givenThereAreNoSuperHeroes()

        openSuperHeroesViewController()

        let emptyCaseText = tester().waitForViewWithAccessibilityLabel("¯\\_(ツ)_/¯")
            as! UILabel
        expect(emptyCaseText.text).to(equal("¯\\_(ツ)_/¯"))
    }

    func testDoesNotShowEmptyCaseIfThereAreSuperHeroes() {
        givenThereAreSomeSuperHeroes()

        openSuperHeroesViewController()

        tester().waitForAbsenceOfViewWithAccessibilityLabel("¯\\_(ツ)_/¯")
    }

    func testShowsSuperHeroLabelsIfThereAreSuperHeroes() {
        let superHeroes = givenThereAreSomeSuperHeroes()

        openSuperHeroesViewController()

        for superHero in superHeroes {
            let cell = tester().waitForViewWithAccessibilityLabel(superHero.name) as! SuperHeroTableViewCell
            expect(cell.nameLabel.text).to(equal(superHero.name))
        }
    }

    func testNumberOfSuperHeroesShownIsTheSameAsAvailableSuperHeroes() {
        let superHeroes = givenThereAreSomeSuperHeroes()

        openSuperHeroesViewController()

        let superHeroesView = tester().waitForViewWithAccessibilityLabel("SuperHeroesTableView") as! UITableView
        expect(superHeroesView.numberOfRowsInSection(0)).to(equal(superHeroes.count))
    }

    func testDoesNotShowAvengersBadgeIfTheSuperHeroIsNotAnAvenger() {
        let superHeroes = givenThereAreSomeSuperHeroes(1, avengers: false)

        openSuperHeroesViewController()

        tester().waitForAbsenceOfViewWithAccessibilityLabel("\(superHeroes.first!.name) - Avengers Badge")
    }

    func testShowsAvengersBadgeIfTheSuperHeroIsAnAvenger() {
        let superHeroes = givenThereAreSomeSuperHeroes(1, avengers: true)

        openSuperHeroesViewController()

        let cell = tester().waitForViewWithAccessibilityLabel("\(superHeroes.first!.name) - Avengers Badge")
        expect(cell).notTo(beNil())
    }

    func testDoesNotShowLoadingViewIfThereAreSuperHeroes() {
        givenThereAreSomeSuperHeroes()

        openSuperHeroesViewController()

        tester().waitForAbsenceOfViewWithAccessibilityLabel("LoadingView")
    }

    func testShowLoadingViewIfSuperHeroesAreNotLoaded() {
        givenSuperHeroesAreNeverLoaded()

        openSuperHeroesViewController()

        tester().waitForViewWithAccessibilityLabel("LoadingView")
    }

    private func givenThereAreNoSuperHeroes() {
        givenThereAreSomeSuperHeroes(0)
    }

    private func givenThereAreSomeSuperHeroes(numberOfSuperHeroes: Int = 10,
        avengers: Bool = false) -> [SuperHero] {
        var superHeroes = [SuperHero]()
        for i in 0..<numberOfSuperHeroes {
            let superHero = SuperHero(name: "SuperHero - \(i)",
                photo: NSURL(string: "https://i.annihil.us/u/prod/marvel/i/mg/c/60/55b6a28ef24fa.jpg"),
                isAvenger: avengers, description: "Description - \(i)")
            superHeroes.append(superHero)
        }
        repository.superHeroes = superHeroes
        return superHeroes
    }

    private func givenSuperHeroesAreNeverLoaded() {
        repository = MockNeverLoadingSuperHeroesRepository()
    }

    private func openSuperHeroesViewController() {
        let superHeroesViewController = ServiceLocator()
            .provideSuperHeroesViewController() as! SuperHeroesViewController
        superHeroesViewController.presenter = SuperHeroesPresenter(ui: superHeroesViewController,
                getSuperHeroes: GetSuperHeroes(repository: repository))
        let rootViewController = UINavigationController()
        rootViewController.viewControllers = [superHeroesViewController]
        presentViewController(rootViewController)
    }
}