//
//  StepTemplatesScreen.swift
//  Workouter
//
//  Created by Uladzimir Papko on 12/29/14.
//  Copyright (c) 2014 visput. All rights reserved.
//

import UIKit

class StepTemplatesScreen: BaseScreen {

    var templateDidSelectAction: ((templateStep: Step) -> ())?
    var templateDidCancelAction: (() -> ())?
    
    private var templates = [Step]
    
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
        searchTemplates()
    }
}

extension StepTemplatesScreen: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.results
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StepTemplateCell.className()) as! StepTemplateCell
        let step = templates[indexPath.row]
        cell.fillWithStep(step)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let template = templates[indexPath.row]
        templateDidSelectAction?(templateStep: template)
    }
}

extension WorkoutsScreen: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        searchTemplates()
    }
    
    func didPresentSearchController(searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }
}

extension StepTemplatesScreen {
    
    @IBAction private func cancelButtonDidPress(sender: id) {
        templateDidCancelAction?()
    }
    
    private func configureSearchController() {
        searchController = SearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        templatesView.templatesTableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.sizeToFit()
        searchController.active = true
        definesPresentationContext = true
    }
    
    private func searchTemplates() {
        templates = [Step]
        templates.append(Step.emptyStep())
        let searchText = searchController.searchBar.text ?? ""
        templates.append(workoutsProvider.searchStepsWithText(searchText))
    }
}
