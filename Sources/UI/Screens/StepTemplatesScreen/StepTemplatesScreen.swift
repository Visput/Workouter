//
//  StepTemplatesScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/29/14.
//  Copyright (c) 2014 visput. All rights reserved.
//

import UIKit

final class StepTemplatesScreen: BaseScreen {

    var templateDidSelectAction: ((step: Step) -> Void)?
    var templateDidCancelAction: (() -> Void)?
    
    var searchRequest = StepsSearchRequest(workout: Workout.emptyWorkout(), searchText: "", includeRestSteps: false)
    
    private var steps = [Step]()
    
    private var searchController: SearchController!
    
    private var workoutsProvider: WorkoutsProvider {
        return modelProvider.workoutsProvider
    }
    private var templatesView: StepTemplatesView {
        return view as! StepTemplatesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        fillViewWithSearchRequest(searchRequest)
        searchStepsWithRequest(searchRequest)
    }
    
    deinit {
        // iOS 9 bug requires to manually remove search controller view from its superview.
        searchController?.view.removeFromSuperview()
    }
}

extension StepTemplatesScreen: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return steps.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var resultCell: UITableViewCell! = nil
        
        let step = steps[indexPath.row]
        if step.name.isEmpty {
            resultCell = tableView.dequeueReusableCellWithIdentifier(NewStepTemplateCell.className())
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(StepTemplateCell.className()) as! StepTemplateCell
            cell.fillWithStep(step)
            resultCell = cell
        }
        
        return resultCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let step = steps[indexPath.row]
        templateDidSelectAction?(step: step)
    }
}

extension StepTemplatesScreen: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        searchRequest = searchRequest.requestBySettingSearchText(searchText!)
        
        searchStepsWithRequest(searchRequest)
    }
    
    func didPresentSearchController(searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }
}

extension StepTemplatesScreen {
    
    override func configureBarButtonItems() {
        super.configureBarButtonItems()
        navigationItem.leftBarButtonItem = UIBarButtonItem.greenCancelItemWithAlignment(.Left,
            target: self,
            action: Selector("cancelButtonDidPress:"))
    }
    
    @objc private func cancelButtonDidPress(sender: AnyObject) {
        templateDidCancelAction?()
    }
    
    private func configureSearchController() {
        searchController = SearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        templatesView.templatesTableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true
    }
    
    private func searchStepsWithRequest(searchRequest: StepsSearchRequest) {
        steps = [Step]()
        steps.append(Step.emptyExersizeStep())
        
        let searchResults = workoutsProvider.searchStepsWithRequest(searchRequest)
        steps.appendContentsOf(searchResults)
        
        templatesView.templatesTableView.reloadData()
    }
    
    private func fillViewWithSearchRequest(searchRequest: StepsSearchRequest) {
        searchController.searchBar.text = searchRequest.searchText
    }
}
