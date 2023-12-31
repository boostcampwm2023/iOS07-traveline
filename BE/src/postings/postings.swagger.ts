export const findOne_OK = {
  id: '22550a18-fe73-42d7-9c64-6e7da27660e7',
  title: '혼자 부산 여행',
  createdAt: '2023-11-28T06:36:27.981Z',
  thumbnail: null,
  startDate: '2023-04-16',
  endDate: '2023-04-16',
  days: ['16일'],
  period: '당일치기',
  headcount: '1인',
  budget: '10 - 50만 원',
  location: '부산',
  season: '봄',
  vehicle: '대중교통',
  theme: ['힐링', '쇼핑', '감성'],
  withWho: null,
  writer: {
    id: '000056789012345678901234567890123456',
    name: 'pong',
    avatar: null,
    resourceId: 'temp111',
    socialType: 1,
    email: 'pong@naver.com',
    allowedIp: ['아이피', '아이피'],
    bannedIp: ['아이피', '아이피'],
  },
  likeds: 2,
  reports: 0,
  isLiked: true,
  isOwner: false,
};

export const searchByWord_OK = [
  '부산 사람의 바다',
  '부산스러운 여행',
  '부부의 신혼여행',
];

export const search_OK = [
  {
    id: '4d365e7c-3e82-472d-bf87-7faf65d9377d',
    title: '즐거운 여행❤️',
    created_at: '2023-12-04T01:51:14.671Z',
    thumbnail:
      'https://traveline.kr.object.ncloudstorage.com/123456789012345678901234567890123456/4d365e7c-3e82-472d-bf87-7faf65d9377d/01eeaf67-6710-40b7-97ab-cd11d8a64794.jpg?AWSAccessKeyId=qjvpzL57YZV54DgXNdvd&Expires=1701864219&Signature=0LpCyEAHQKCLqIaTq3zseYTiBVA%3D',
    period: '2박 3일',
    headcount: '5인 이상',
    budget: '10 - 50만 원',
    location: '대전',
    season: '여름',
    vehicle: null,
    withWho: ['가족'],
    theme: ['힐링', '맛집'],
    writer: {
      id: '123456789012345678901234567890123456',
      name: 'pong',
      avatar: null,
    },
    likeds: '1',
  },
  {
    id: '9a0396ba-4892-436a-a97c-58be59b59327',
    title: '대전 여행😎 ',
    created_at: '2023-12-02T08:36:04.676Z',
    thumbnail: null,
    period: '2박 3일',
    headcount: '5인 이상',
    budget: '10 - 50만 원',
    location: '대전',
    season: '여름',
    vehicle: null,
    withWho: ['가족'],
    theme: ['힐링', '맛집'],
    writer: {
      id: '123456789012345678901234567890123456',
      name: 'pong',
      avatar: null,
    },
    likeds: '0',
  },
  {
    id: 'e9c76262-cb37-45a4-b713-a08a625b79d7',
    title: 'trip~',
    createdAt: '2023-11-28T05:58:04.646Z',
    thumbnail: null,
    period: '2박 3일',
    headcount: '5인 이상',
    budget: '10 - 50만 원',
    location: '대전',
    season: '여름',
    vehicle: null,
    withWho: ['가족'],
    theme: ['힐링', '맛집'],
    writer: {
      id: '123456789012345678901234567890123456',
      name: 'pong',
      avatar: null,
    },
    likeds: '1',
  },
];

export const create_update_remove_OK = {
  id: 'c89f207a-f528-4d53-8ac2-1356fa22eb21',
};

export const like_OK = { isLiked: false };

export const report_OK = {
  posting: 'c0265845-4991-4f04-a5c3-4cf12207d675',
  reporter: '000056789012345678901234567890123456',
};

export const findMyPosting_OK = [
  {
    id: '4d2084e5-0b1f-449a-9908-2918bd384f66',
    title: '❤️',
    createdAt: '2023-11-30T05:40:19.625Z',
    thumbnail: null,
    period: '당일치기',
    headcount: null,
    budget: null,
    location: '부산',
    season: '여름',
    vehicle: null,
    theme: null,
    withWho: null,
    writer: {
      id: '123456789012345678901234567890123456',
      name: 'pong',
      avatar: null,
    },
    likeds: '5',
    reports: '3',
  },
  {
    id: '4e8076d2-48e6-4397-8652-3e163d1c09b3',
    title: 'bread lover❤️',
    createdAt: '2023-11-30T02:39:18.314Z',
    thumbnail: null,
    period: '2박 3일',
    headcount: '5인 이상',
    budget: '10 - 50만 원',
    location: '대전',
    season: '여름',
    vehicle: null,
    theme: ['힐링', '맛집'],
    withWho: ['가족'],
    writer: {
      id: '123456789012345678901234567890123456',
      name: 'pong',
      avatar: null,
    },
    likeds: '2',
    reports: '0',
  },
];
