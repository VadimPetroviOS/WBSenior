//
//  MainModel.swift
//  WBSenior
//
//  Created by Вадим on 24.08.2024.
//

import Foundation

final class MockMainApi {
    func getMarketingSpecialists() async throws -> [MarketingSpecialistData] {
        return [
            MarketingSpecialistData(
                name: "Элиот Мюллер",
                grade: "Старший маркетолог, market guru",
                rating: "4.8",
                totalSales: 1234,
                persentage: 78,
                nameCompany: "YOTA Russia"
            ),
            MarketingSpecialistData(
                name: "Маргарита Симонян",
                grade: "Маркетолог, market guru",
                rating: "4.5",
                totalSales: 800,
                persentage: 48,
                nameCompany: "Beeline Russia"
            ),
            MarketingSpecialistData(
                name: "Микаил Сартино",
                grade: "Маркетолог, experience fly",
                rating: "4.9",
                totalSales: 180,
                persentage: 9,
                nameCompany: "MTS Russia"
            ),
            MarketingSpecialistData(
                name: "Игорь Прокофьев",
                grade: "Маркетолог, experience fly",
                rating: "4.9",
                totalSales: 180,
                persentage: 9,
                nameCompany: "YOTA Russia"
            ),
            MarketingSpecialistData(
                name: "Ренат Асторо",
                grade: "Маркетолог, experience fly",
                rating: "4.9",
                totalSales: 180,
                persentage: 9,
                nameCompany: "MTS Russia"
            )
        ]
    }
}
