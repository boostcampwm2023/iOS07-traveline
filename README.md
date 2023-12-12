# <img align="left" src="https://github.com/boostcampwm2023/iOS07-traveline/assets/74968390/4e4c84da-d6da-445c-8328-21828a4c162a" width="120px"> 🌎 traveline
> 여행 일정을 타임라인을 **기록**하고 **공유**하는 서비스 Traveline 입니다.  
나만의 여행을 공유하고 다양한 여행을 만나보아요 :)

![기능 소개 페이지](https://github.com/boostcampwm2023/iOS07-traveline/assets/51712973/f39271ee-26a8-41d2-b18d-32d44f79fd43)

### 주요 기능
**나랑 비슷한 취향과 환경을 가진 다양한 여행들을 만나고 나만의 여행 계획을 짜보아요 !**
- 지역, 기간, 테마 등 총 8 가지의 필터를 통해 내가 원하는 여행을 찾을 수 있어요.
- 키워드 검색을 통해 원하는 여행을 바로 탐색할 수 있어요.
- 매 날짜마다 시간 순으로 기록된 여행들을 통해 보다 쉽게 일정을 확인할 수 있어요.
- 지도로 보기 기능을 통해 어떤 장소에 머물렀는지 지도로 한눈에 볼 수 있어요.

### Traveline 팀 소개
|S009 김영인|S013 김태현|S041 홍기웅|J048 박경미|J170 황정민|
|:-:|:-:|:-:|:-:|:-:|
|<img src="https://avatars.githubusercontent.com/u/74968390?v=4" width=150>|<img src="https://user-images.githubusercontent.com/51712973/280571628-e1126b86-4941-49fc-852b-9ce16f3e0c4e.jpg" width=150>|<img src="https://avatars.githubusercontent.com/u/91725382?s=400&u=29b8023a56a09685aaab53d4eb0dd556254cd902&v=4" width=150>|<img src="https://github.com/boostcampwm2023/iOS07-Trapture/assets/74968390/76bfffde-8ebc-445d-8f3a-7c21288ae386" width=150>|<img src="https://github.com/boostcampwm2023/iOS07-Trapture/assets/74968390/3f5281e2-d233-49d2-b836-be2a56f93096" width=150>|
|[@0inn](https://github.com/0inn)|[@kth1210](https://github.com/kth1210)|[@otoolz](https://github.com/otoolz)|[@kmi0817](https://github.com/kmi0817)|[@yaongmeow](https://github.com/yaongmeow)|

## 프로젝트 구조
### 🍎 iOS

### 💽 BE

<br>

## 🍎 iOS 기술 스택

### MVVM + CleanArchitecture
- 현재 서비스 기획 간 복잡한 아키텍처의 필요성을 느끼지 못했고, 작업 간 로직 분리의 용이함을 위해 선택했습니다.
- 또한 여러 명이 동시에 개발해야하기 때문에 CleanArchitecture를 활용해 역할 분리를 확실히 해두어 코드의 통일성을 유지했습니다.
- Repository 패턴을 통해 Data Source를 캡슐화할 수 있었고, RepositoryMock을 이용해 서버 개발 상황에 관계없이 개발을 진행할 수 있었습니다.
### Combine
- Third-party인 RxSwift에 비해 시간, 공간적 성능이 우수하기 때문에 First-party인 Combine을 선택했습니다.
- 데이터 스트리밍을 조작하고 구독하는 것에 최적화된 Combine을 UI Binding에 활용했습니다.
### Swift Concurrency
- Concurrency를 활용해 단발성 비동기 응답인 네트워크 로직을 보다 직관적으로 처리해주기 위해 선택했습니다.
- Repository - Network의 흐름을 간결하게 작성할 수 있었습니다.
### MapKit
- 지도 위에 마커를 표시하고 정보를 보여주기 위해 사용했습니다.
- 위치 좌표 정보만 서버에서 받아오면 되기 때문에 다른 Third-party 지도를 사용할 필요가 없다고 생각해 애플 프레임워크인 MapKit을 선택했습니다.
### Keychain
- 로그인 이후 토큰 등 민감한 사용자 정보를 안전하게 저장하고 관리하기 위해 사용했습니다.

## 💽 BE 기술 스택

<br>

## 🔥 우리의 도전들
### 🍎 iOS
#### - [단방향 플로우 ViewModel 구현기](https://github.com/boostcampwm2023/iOS07-traveline/wiki/%5BiOS%5D-%EB%8B%A8%EB%B0%A9%ED%96%A5-%ED%94%8C%EB%A1%9C%EC%9A%B0-ViewModel-%EA%B5%AC%ED%98%84%EA%B8%B0)
#### - [Concurrency와 Combine의 공존](https://github.com/boostcampwm2023/iOS07-traveline/wiki/%5BiOS%5D-Concurrency%EC%99%80-Combine%EC%9D%98-%EA%B3%B5%EC%A1%B4)
#### - [traveline의 이미지 관리하기](https://github.com/boostcampwm2023/iOS07-traveline/wiki/%5BiOS%5D-traveline%EC%9D%98-%EC%9D%B4%EB%AF%B8%EC%A7%80-%EA%B4%80%EB%A6%AC%ED%95%98%EA%B8%B0)
#### - [traveline 디자인 시스템 구축기](https://github.com/boostcampwm2023/iOS07-traveline/wiki/%5BiOS%5D-traveline-%EB%94%94%EC%9E%90%EC%9D%B8-%EC%8B%9C%EC%8A%A4%ED%85%9C-%EA%B5%AC%EC%B6%95%EA%B8%B0)
#### - [KeychainWrapper로 사용자 정보 관리하기](https://github.com/boostcampwm2023/iOS07-traveline/wiki/%5BiOS%5D-KeychainWrapper%EB%A1%9C-%EC%82%AC%EC%9A%A9%EC%9E%90-%EC%A0%95%EB%B3%B4-%EA%B4%80%EB%A6%AC%ED%95%98%EA%B8%B0)
#### - [권한 설정 없이 사진의 시간 메타데이터 가져오기](https://github.com/boostcampwm2023/iOS07-traveline/wiki/%5BiOS%5D-%EA%B6%8C%ED%95%9C-%EC%84%A4%EC%A0%95-%EC%97%86%EC%9D%B4-%EC%82%AC%EC%A7%84%EC%9D%98-%EC%8B%9C%EA%B0%84-%EB%A9%94%ED%83%80%EB%8D%B0%EC%9D%B4%ED%84%B0-%EA%B0%80%EC%A0%B8%EC%98%A4%EA%B8%B0)
#### - [사이드 바 사용성 개선기](https://github.com/boostcampwm2023/iOS07-traveline/wiki/%5BiOS%5D-%EC%82%AC%EC%9D%B4%EB%93%9C-%EB%B0%94%EC%9D%98-%EC%82%AC%EC%9A%A9%EC%84%B1-%EA%B0%9C%EC%84%A0%EA%B8%B0)
#### - [MapKit으로 타임라인 보여주기](https://github.com/boostcampwm2023/iOS07-traveline/wiki/%5BiOS%5D-MapKit%EC%9C%BC%EB%A1%9C-%ED%83%80%EC%9E%84%EB%9D%BC%EC%9D%B8-%EB%B3%B4%EC%97%AC%EC%A3%BC%EA%B8%B0)
#### - [작업을 서로 바꿔서 해보자!](https://github.com/boostcampwm2023/iOS07-traveline/wiki/%5BiOS%5D-%EC%9E%91%EC%97%85%EC%9D%84-%EC%84%9C%EB%A1%9C-%EB%B0%94%EA%BF%94%EC%84%9C-%ED%95%B4%EB%B3%B4%EC%9E%90!)

### 💽 BE



<br>

|📚 문서|[Wiki](https://github.com/boostcampwm2023/iOS07-traveline/wiki)|[팀 노션](https://spiky-rat-16e.notion.site/6b9791faac7e4b9d9a31d225ce8cd157?pvs=4)|[그라운드 룰](https://github.com/boostcampwm2023/iOS07-Trapture/wiki/%E2%9C%A8-%ED%8C%80-%EA%B7%B8%EB%9D%BC%EC%9A%B4%EB%93%9C-%EB%A3%B0)|[컨벤션](https://github.com/boostcampwm2023/iOS07-Trapture/wiki/%F0%9F%93%81-%EC%BB%A8%EB%B2%A4%EC%85%98)|[회의록](https://www.notion.so/bd676cad762c4cffa7b081c65939b0c5?v=76fe42efa9f1497b98764bf47ff47598&pvs=4)|[기획/디자인](https://www.figma.com/file/RrmfjBTxuLMAYRiXrbKQSW/traveline?type=design&node-id=2%3A2&mode=design&t=AD0PpylqwYoldl8g-1)|
|:-:|:-:|:-:|:-:|:-:|:-:|:--:|
