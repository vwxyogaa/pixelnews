//
//  CovidDetailViewController.swift
//  NewsApp
//
//  Created by macbook on 06/03/22.
//

import UIKit

class CovidDetailViewController: UIViewController {
  @IBOutlet weak var dateTodayLabel: UILabel!
  @IBOutlet weak var amountTotalCasesLabel: UILabel!
  @IBOutlet weak var amountTodayCasesLabel: UILabel!
  @IBOutlet weak var amountDeathLabel: UILabel!
  @IBOutlet weak var amountRecoveredLabel: UILabel!
  
  var covidDetail: UpdateCovidIndoResponse?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadCovidDetail()
  }
  
  // MARK: - Helpers
  func loadCovidDetail() {
    CovidIndoProvider.shared.loadCovidIndo { response in
      switch response {
      case .success(let detailCovid):
        self.covidDetail = detailCovid
        
        if let result = self.covidDetail {
          self.dateTodayLabel.text = "\(result.penambahan.tanggal.string(format: "MMMM dd, yyyy"))"
          self.amountTotalCasesLabel.text = "\(result.total.jumlahPositif )"
          self.amountTodayCasesLabel.text = "+\(result.penambahan.jumlahPositif )"
          self.amountDeathLabel.text = "+\(result.penambahan.jumlahMeninggal )"
          self.amountRecoveredLabel.text = "+\(result.penambahan.jumlahSembuh )"
        }
      case .failure(let error):
        print("Error load covid detail: \(error.localizedDescription)")
      }
    }
  }
  
  @IBAction func seeYourCityTapped(_ sender: Any) {
    let alert = UIAlertController(title: "Hai, sorry this feature will available soon.", message: "", preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
    
    present(alert, animated: true, completion: nil)
  }
}
