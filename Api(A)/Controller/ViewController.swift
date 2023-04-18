//
//  ViewController.swift
//  Api(A)
//
//  Created by undhad kaushik on 01/03/23.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var myTabelView: UITableView!
    
    var arr : MainData!
    var arr1: [Place] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nibregister()
        apiCall()
    }
    
    private func nibregister(){
        let nibFile: UINib = UINib(nibName: "TableViewCell", bundle: nil)
        myTabelView.register(nibFile, forCellReuseIdentifier: "cell")
        myTabelView.separatorStyle = .none
    }
    
    
    private func apiCall(){
        AF.request("https://api.zippopotam.us/us/33162", method: .get).responseData{ [self] response in
            debugPrint(response)
            if response.response?.statusCode == 200 {
                guard let apiData = response.data else { return }
                do{
                    let result = try JSONDecoder().decode(MainData.self, from: apiData)
                    print(result)
                    self.arr = result
                    self.arr1 = arr.places
                    self.myTabelView.reloadData()
                }catch{
                    print(error.localizedDescription)
                }
            }else{
                print("sumthing went rong")
            }
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return arr?.places.count ?? 0
        return arr1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let abc: MainData = arr!
        cell.dataSourceNameLabel.text = "\(arr.places[indexPath.row].placeName)"
        cell.descriptionLabel.text = "\(arr.places[indexPath.row].longitude)"
        cell.datasetNameLabel.text = "\(arr.places[indexPath.row].stateAbbreviation)"
        cell.datasetLinkLabel.text = "\(arr.places[indexPath.row].state)"
        cell.tabelIdLabel.text = "\(arr.places[indexPath.row].latitude)"
        cell.topicLabel.text = "\(arr.places[indexPath.row].stateAbbreviation)"
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 398
    }
    
}


struct MainData: Decodable {
    var postCode: String
    var country: String
    var countryAbbreviation: String
    var places: [Place]
    
    enum CodingKeys: String, CodingKey {
        case postCode = "post code"
        case country , places
        case countryAbbreviation = "country abbreviation"
    }
}


struct Place: Decodable {
    var placeName: String
    var longitude: String
    var state: String
    var stateAbbreviation: String
    var latitude: String
    
    enum CodingKeys: String, CodingKey {
        case placeName = "place name"
        case longitude , state , latitude
        case stateAbbreviation = "state abbreviation"
    }
}

