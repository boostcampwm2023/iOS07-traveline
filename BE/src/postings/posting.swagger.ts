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
  likeds: [
    {
      user: '000056789012345678901234567890123456',
      posting: '22550a18-fe73-42d7-9c64-6e7da27660e7',
      isDeleted: false,
    },
    {
      user: '123456789012345678901234567890123456',
      posting: '22550a18-fe73-42d7-9c64-6e7da27660e7',
      isDeleted: true,
    },
  ],
  writer: {
    id: '000056789012345678901234567890123456',
    name: 'pong',
    avatar: null,
    resourceId: 'km',
    socialType: 1,
  },
  liked: 2,
  report: 0,
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
    id: 'c0fc7b89-97fc-4e02-99b4-80a958c98172',
    title: 'bread lover❤️',
    createdAt: '2023-11-28T09:28:07.880Z',
    thumbnail: null,
    startDate: '2023-08-16',
    endDate: '2023-08-18',
    days: 3,
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
      name: 'lemon',
      avatar: null,
      resourceId: 'temp',
      socialType: 1,
    },
    liked: [],
    report: [
      {
        reporter: '000056789012345678901234567890123456',
        posting: 'c0fc7b89-97fc-4e02-99b4-80a958c98172',
      },
    ],
  },
  {
    id: '51336ad1-3769-4827-bfb1-1080df368532',
    title: 'bread lover',
    createdAt: '2023-11-28T06:19:24.042Z',
    thumbnail: null,
    startDate: '2023-08-16',
    endDate: '2023-08-18',
    days: 3,
    period: '2박 3일',
    headcount: '5인 이상',
    budget: '10 - 50만 원',
    location: '대전',
    season: '여름',
    vehicle: null,
    theme: ['힐링', '맛집'],
    withWho: ['가족'],
    writer: {
      id: '000056789012345678901234567890123456',
      name: 'pong',
      avatar: null,
      resourceId: 'km',
      socialType: 1,
    },
    liked: [
      {
        user: '123456789012345678901234567890123456',
        posting: '51336ad1-3769-4827-bfb1-1080df368532',
      },
    ],
    report: [],
  },
  {
    id: 'e9c76262-cb37-45a4-b713-a08a625b79d7',
    title: 'trip~',
    createdAt: '2023-11-28T05:58:04.646Z',
    thumbnail: null,
    startDate: '2023-12-29',
    endDate: '2024-01-03',
    days: 6,
    period: '3박 ~',
    headcount: '2인',
    budget: '100만 원 ~',
    location: '서울',
    season: '겨울',
    vehicle: '대중교통',
    theme: ['맛집', '액티비티'],
    withWho: ['친구'],
    writer: {
      id: '000056789012345678901234567890123456',
      name: 'pong',
      avatar: null,
      resourceId: 'km',
      socialType: 1,
    },
    liked: [
      {
        user: '000056789012345678901234567890123456',
        posting: 'e9c76262-cb37-45a4-b713-a08a625b79d7',
      },
      {
        user: '123456789012345678901234567890123456',
        posting: 'e9c76262-cb37-45a4-b713-a08a625b79d7',
      },
    ],
    report: [],
  },
];

export const create_OK = {
  title: 'bread lover❤️',
  startDate: '2023-08-16T00:00:00.000Z',
  endDate: '2023-08-18T00:00:00.000Z',
  days: 3,
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
    name: 'lemon',
    avatar: null,
    resourceId: 'temp',
    socialType: 1,
  },
  thumbnail: null,
  id: 'c89f207a-f528-4d53-8ac2-1356fa22eb21',
  createdAt: '2023-11-28T14:13:28.668Z',
};

export const update_OK = {
  generatedMaps: [],
  raw: [],
  affected: 1,
};

export const remove_OK = {
  title: 'bread lover',
  createdAt: '2023-11-28T09:14:32.247Z',
  thumbnail: null,
  startDate: '2023-08-16',
  endDate: '2023-08-18',
  days: 3,
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
    name: 'lemon',
    avatar: null,
    resourceId: 'temp',
    socialType: 1,
  },
  liked: [],
  report: [],
};

export const like_OK = {
  posting: 'c89f207a-f528-4d53-8ac2-1356fa22eb21',
  user: '123456789012345678901234567890123456',
  isDeleted: false,
};

export const report_OK = {
  posting: 'c0265845-4991-4f04-a5c3-4cf12207d675',
  reporter: '000056789012345678901234567890123456',
};
