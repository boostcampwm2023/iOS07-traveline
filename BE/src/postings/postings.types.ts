export const periods = [
  '당일치기',
  '1박 2일',
  '2박 3일',
  '3박 ~',
  '일주일 ~',
  '한 달 ~',
];
export type PeriodType = (typeof periods)[number];
export const headcounts = ['1인', '2인', '3인', '4인', '5인 이상'];
export const budgets = [
  '0 - 10만 원',
  '10 - 50만 원',
  '50 - 100만 원',
  '100만 원 ~',
];
export const locations = [
  '서울',
  '부산',
  '인천',
  '대구',
  '대전',
  '광주',
  '울산',
  '세종',
  '경기',
  '경남',
  '경북',
  '충남',
  '충북',
  '전남',
  '전북',
  '강원',
  '제주',
];
export const themes = [
  '힐링',
  '액티비티',
  '캠핑',
  '맛집',
  '예술',
  '감성',
  '자연',
  '쇼핑',
  '효도',
];
export const withWhos = ['반려동물', '가족', '친구', '연인'];
export const vehicles = ['대중교통', '자차'];
export const seasons = ['봄', '여름', '가을', '겨울'];
export type SeasonType = (typeof seasons)[number];
