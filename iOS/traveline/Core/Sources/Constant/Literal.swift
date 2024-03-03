//
//  Literal.swift
//  traveline
//
//  Created by 김영인 on 2023/11/17.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

public enum Literal {
    public static let empty: String = ""
    public static let boundary: String = "Boundary-\(UUID().uuidString)"
    
    public enum InfoPlistKey {
        public static let devURL: String = "DevURL"
        public static let prodURL: String = "ProdURL"
    }
    
    public enum Tag {
        public static let region: String = "지역"
        public static let period: String = "기간"
        public static let season: String = "계절"
        public static let theme: String = "테마"
        public static let cost: String = "비용"
        public static let costSubtitle: String = "단위: 만원"
        public static let people: String = "인원"
        public static let with: String = "함께"
        public static let transportation: String = "이동수단"
        
        public enum ThemeDetail {
            public static let healing: String = "힐링"
            public static let activity: String = "액티비티"
            public static let camping: String = "캠핑"
            public static let restaurant: String = "맛집"
            public static let art: String = "예술"
            public static let emotion: String = "감성"
            public static let nature: String = "자연"
            public static let shopping: String = "쇼핑"
            public static let filialPiety: String = "효도"
        }
        
        public enum CostDetail {
            public static let under10: String = "0 - 10"
            public static let under50: String = "10 - 50"
            public static let under100: String = "50 - 100"
            public static let over100: String = "100 -"
            public static let won: String = "만 원"
        }
        
        public enum PeopleDetail {
            public static let one: String = "1인"
            public static let two: String = "2인"
            public static let three: String = "3인"
            public static let four: String = "4인"
            public static let overFive: String = "5인 이상"
        }
        
        public enum WithDetail {
            public static let family: String = "가족"
            public static let friend: String = "친구"
            public static let couple: String = "연인"
            public static let pet: String = "반려동물"
        }
        
        public enum TransportationDetail {
            public static let publicTransport: String = "대중교통"
            public static let drive: String = "자차"
        }
    }
    
    public enum Filter {
        public static let sort: String = "정렬"
        
        public enum SortDetail {
            public static let recent: String = "최신순"
            public static let like: String = "좋아요순"
        }
        
        public enum RegionDetail {
            public static let seoul: String = "서울"
            public static let busan: String = "부산"
            public static let daegu: String = "대구"
            public static let incheon: String = "인천"
            public static let gwangju: String = "광주"
            public static let daejeon: String = "대전"
            public static let ulsan: String = "울산"
            public static let sejong: String = "세종"
            public static let gyeonggi: String = "경기도"
            public static let gangwon: String = "강원도"
            public static let chungbuk: String = "충청북도"
            public static let chungnam: String = "충청남도"
            public static let jeonbuk: String = "전라북도"
            public static let jeonnam: String = "전라남도"
            public static let gyeongbuk: String = "경상북도"
            public static let gyeongnam: String = "경상남도"
            public static let jeju: String = "제주도"
        }
        
        public enum PeriodDetail {
            public static let one: String = "당일치기"
            public static let two: String = "1박 2일"
            public static let three: String = "2박 3일"
            public static let overThree: String = "3박 -"
            public static let week: String = "일주일 -"
            public static let month: String = "한 달 -"
        }
        
        public enum SeasonDetail {
            public static let spring: String = "봄"
            public static let summer: String = "여름"
            public static let fall: String = "가을"
            public static let winter: String = "겨울"
        }
    }
    
    public enum Action {
        public static let modify: String = "수정하기"
        public static let delete: String = "삭제하기"
        public static let report: String = "신고하기"
        public static let translate: String = "번역하기"
    }
    
    public enum Query {
        public enum SortDetail {
            public static let recent: String = "최신순"
            public static let like: String = "좋아요순"
        }
        
        public enum RegionDetail {
            public static let seoul: String = "서울"
            public static let busan: String = "부산"
            public static let daegu: String = "대구"
            public static let incheon: String = "인천"
            public static let gwangju: String = "광주"
            public static let daejeon: String = "대전"
            public static let ulsan: String = "울산"
            public static let sejong: String = "세종"
            public static let gyeonggi: String = "경기"
            public static let gangwon: String = "강원"
            public static let chungbuk: String = "충북"
            public static let chungnam: String = "충남"
            public static let jeonbuk: String = "전북"
            public static let jeonnam: String = "전남"
            public static let gyeongbuk: String = "경북"
            public static let gyeongnam: String = "경남"
            public static let jeju: String = "제주"
        }
        
        public enum PeriodDetail {
            public static let one: String = "당일치기"
            public static let two: String = "1박 2일"
            public static let three: String = "2박 3일"
            public static let overThree: String = "3박 ~"
            public static let week: String = "일주일 ~"
            public static let month: String = "한 달 ~"
        }
        
        public enum SeasonDetail {
            public static let spring: String = "봄"
            public static let summer: String = "여름"
            public static let fall: String = "가을"
            public static let winter: String = "겨울"
        }
        
        public enum ThemeDetail {
            public static let healing: String = "힐링"
            public static let activity: String = "액티비티"
            public static let camping: String = "캠핑"
            public static let restaurant: String = "맛집"
            public static let art: String = "예술"
            public static let emotion: String = "감성"
            public static let nature: String = "자연"
            public static let shopping: String = "쇼핑"
            public static let filialPiety: String = "효도"
        }
        
        public enum CostDetail {
            public static let under10: String = "0 - 10만 원"
            public static let under50: String = "10 - 50만 원"
            public static let under100: String = "50 - 100만 원"
            public static let over100: String = "100만 원 ~"
        }
        
        public enum PeopleDetail {
            public static let one: String = "1인"
            public static let two: String = "2인"
            public static let three: String = "3인"
            public static let four: String = "4인"
            public static let overFive: String = "5인 이상"
        }
        
        public enum WithDetail {
            public static let family: String = "가족"
            public static let friend: String = "친구"
            public static let couple: String = "연인"
            public static let pet: String = "반려동물"
        }
        
        public enum TransportationDetail {
            public static let publicTransport: String = "대중교통"
            public static let drive: String = "자차"
        }
    }
    
    public enum Setting {
        public static let termsOfServiceURL = "https://spiky-rat-16e.notion.site/b222abdf800e4a428a25582f2dc36290?pvs=4"
        public static let privacyPolicyURL = "https://spiky-rat-16e.notion.site/886a133ee0f9473a83d5f3ed8b877498?pvs=4"
        public static let openSourceLicenseURL = "https://spiky-rat-16e.notion.site/e8725bd989ea410390b6ef568324a439?pvs=4"
    }
}
