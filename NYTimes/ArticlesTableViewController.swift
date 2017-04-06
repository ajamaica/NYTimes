//
//  ArticlesTableViewController.swift
//  NYTimes
//
//  Created by Arturo Jamaica Garcia on 06/04/17.
//  Copyright © 2017 Arturo Jamaica. All rights reserved.
//

import UIKit
import Moya_ModelMapper
import PullToRefreshKit
import Moya

class ArticlesTableViewController: UITableViewController,UISearchResultsUpdating {
    var page = 0
    
    var resultSearchController = UISearchController()
    var results_article = [Article]()
    var results_docs = [Doc]()
    var search_request:Cancellable? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        
        
        get_mostView()
        setUpTableView()
    }
    
    func setUpTableView(){
        self.tableView.estimatedRowHeight = 106.0
        self.tableView.rowHeight = UITableViewAutomaticDimension

        
        self.resultSearchController = ({
            
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.barStyle = UIBarStyle.black
            controller.searchBar.barTintColor = UIColor.white
            controller.searchBar.backgroundColor = UIColor(red: 46.0/255.0, green: 14.0/255.0, blue: 74.0/255.0, alpha: 1.0)
            self.tableView.tableHeaderView = controller.searchBar
            return controller
            
        })()
    }

    
    func get_mostView(){
        NYTimesProvider.request(.mostviewed("all-sections", "1")) { result in
            
            if case let .success(response) = result {
                do {
                    
                    //try response.mapArray() as [Article]
                    let article_array = try response.mapArray(withKeyPath:"results") as [Article]
                    self.results_article = article_array
                    self.tableView.reloadData()
                } catch {
                    
                }
            }
        }
    }
    
    func get_search( query: String,page:Int){
        
        if(query.isEmpty){
            return
        }
        
        if(search_request != nil){
            search_request?.cancel()
        }
        
        search_request = NYTimesProvider.request(.articlesearch(query,page)) { result in
            
            if case let .success(response) = result {
                do {
                    
                    //try response.mapArray() as [Article]
                    let docs_array = try response.mapArray(withKeyPath:"response.docs") as [Doc]
                    self.results_docs = docs_array
                    self.tableView.reloadData()
                } catch {
                    
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(self.resultSearchController.isActive){
            
            return self.results_docs.count
        }else{
            return self.results_article.count
        }

        
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as! ArticleTableViewCell

        
        if(self.resultSearchController.isActive){
            
            let doc = self.results_docs[indexPath.row] as! Doc
            cell.mediaView.isHidden = true
            cell.titletxt.text = doc.title
            cell.excerpttxt.text = doc.abstract
            cell.datetxt.text = doc.byline
            cell.excerpttxt.sizeToFit()
            cell.titletxt.sizeToFit()
            cell.datetxt.sizeToFit()
            
        }else{
            let article = self.results_article[indexPath.row] as! Article
            cell.mediaView.isHidden = true
            cell.titletxt.text = article.title
            cell.excerpttxt.text = article.abstract
            cell.datetxt.text = article.byline
            cell.excerpttxt.sizeToFit()
            cell.titletxt.sizeToFit()
            cell.datetxt.sizeToFit()
        }

        return cell
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
        results_docs = [Doc]()
        self.tableView.reloadData()
        self.page = 1
        
        get_search(query: searchController.searchBar.text!, page: self.page)
        
    }
    



    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
