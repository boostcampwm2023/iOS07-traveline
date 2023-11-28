export enum Period {
  당일치기 = '당일치기',
  '1박 2일' = '1박 2일',
  '2박 3일' = '2박 3일',
  '3박 ~' = '3박 ~',
  '일주일 ~' = '일주일 ~',
  '한 달 ~' = '한 달 ~',
}
export const periods = Object.values(Period);

export enum Headcount {
  '1인' = '1인',
  '2인' = '2인',
  '3인' = '3인',
  '4인' = '4인',
  '5인 이상' = '5인 이상',
}
export const headcounts = Object.values(Headcount);

export enum Budget {
  '0 - 10만 원' = '0 - 10만 원',
  '10 - 50만 원' = '10 - 50만 원',
  '50 - 100만 원' = '50 - 100만 원',
  '100만 원 ~' = '100만 원 ~',
}
export const budgets = Object.values(Budget);

export enum Location {
  서울 = '서울',
  부산 = '부산',
  인천 = '인천',
  대구 = '대구',
  대전 = '대전',
  광주 = '광주',
  울산 = '울산',
  세종 = '세종',
  경기 = '경기',
  경남 = '경남',
  경북 = '경북',
  충남 = '충남',
  충북 = '충북',
  전남 = '전남',
  전북 = '전북',
  강원 = '강원',
  제주 = '제주',
}
export const locations = Object.values(Location);

export enum Theme {
  힐링 = '힐링',
  액티비티 = '액티비티',
  캠핑 = '캠핑',
  맛집 = '맛집',
  예술 = '예술',
  감성 = '감성',
  자연 = '자연',
  쇼핑 = '쇼핑',
  효도 = '효도',
}
export const themes = Object.values(Theme);

export enum WithWho {
  반려동물 = '반려동물',
  가족 = '가족',
  친구 = '친구',
  연인 = '연인',
}
export const withWhos = Object.values(WithWho);

export enum Vehicle {
  대중교통 = '대중교통',
  자차 = '자차',
}
export const vehicles = Object.values(Vehicle);

export enum Season {
  봄 = '봄',
  여름 = '여름',
  가을 = '가을',
  겨울 = '겨울',
}
export const seasons = Object.values(Season);

export enum Sorting {
  최신순 = '최신순',
  좋아요순 = '좋아요순',
}
